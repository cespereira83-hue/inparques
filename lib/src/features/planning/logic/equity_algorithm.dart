import 'package:drift/drift.dart';
import '../../../data/local/app_database.dart';

class EquityAlgorithm {
  final AppDatabase db;
  EquityAlgorithm(this.db);

  /// Algoritmo Maestro de Disponibilidad (Soporte Multi-Día)
  /// [isOvernight]: Si es true, activa la lógica de rotación cíclica (D2).
  Future<List<Map<String, dynamic>>> getAvailablePersonnel({
    required DateTime targetDate,
    required String dayName,
    bool isOvernight = false,
  }) async {
    // 1. Obtener UNIVERSO (Solo activos)
    final allPersonnel = await (db.select(
      db.funcionarios,
    )..where((t) => t.estaActivo.equals(true)))
        .get();

    // 2. Clasificación de AUSENCIAS (Vacaciones, Reposos)
    final ausencias = await (db.select(db.ausencias)
          ..where(
            (t) =>
                t.fechaInicio.isSmallerOrEqual(Variable(targetDate)) &
                t.fechaFin.isBiggerOrEqual(Variable(targetDate)),
          ))
        .get();

    final idsReposoMedico = <int>{};
    final idsVacaciones = <int>{};

    for (var a in ausencias) {
      if (a.tipo.toLowerCase().contains('reposo') ||
          a.tipo.toLowerCase().contains('medico')) {
        idsReposoMedico.add(a.funcionarioId);
      } else {
        idsVacaciones.add(a.funcionarioId);
      }
    }

    // 3. Descansos Post-Pernocta (Bloqueo VIGENTE y LÓGICO)
    // CORRECCIÓN V5: Implementación de JOIN para validación temporal bidireccional.
    // Un bloqueo de descanso solo aplica si:
    // A) El periodo de descanso aun no ha expirado hoy (Límite > TargetDate).
    // B) La guardia que lo generó YA OCURRIÓ (Fin Guardia <= TargetDate).
    // Esto evita que guardias FUTURAS bloqueen fechas PASADAS (Bloqueo Retroactivo).

    final queryBloqueos = db.select(db.asignaciones).join([
      innerJoin(db.actividades,
          db.actividades.id.equalsExp(db.asignaciones.actividadId))
    ]);

    queryBloqueos.where(
        // Condición A: El descanso sigue activo
        db.asignaciones.fechaBloqueoHasta.isBiggerThan(Variable(targetDate)) &
            // Condición B: El origen NO es futuro (usamos coalesce para seguridad)
            coalesce([db.actividades.fechaFin, db.actividades.fecha])
                .isSmallerOrEqual(Variable(targetDate)));

    final bloqueos = await queryBloqueos.get();

    final idsEnDescanso = bloqueos
        .map((row) => row.readTable(db.asignaciones).funcionarioId)
        .toSet();

    // 4. YA ASIGNADO HOY (Bloqueo Físico por Actividad en curso)
    final startOfDay = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    final endOfDay = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      23,
      59,
      59,
    );

    final actividadesActivas = await (db.select(db.actividades)
          ..where((a) {
            // CORRECCIÓN: Usamos coalesce de SQL para manejar nulos
            // Si fechaFin es NULL, toma a.fecha (asume 1 día)
            final finReal = coalesce([a.fechaFin, a.fecha]);

            // La lógica es: La actividad se solapa con HOY si:
            // (Inicio <= FinDia) Y (Fin >= InicioDia)
            return a.fecha.isSmallerOrEqual(Variable(endOfDay)) &
                finReal.isBiggerOrEqual(Variable(startOfDay));
          }))
        .get();

    final idsActividadesActivas = actividadesActivas.map((a) => a.id).toList();

    Set<int> idsOcupadosHoy = {};
    if (idsActividadesActivas.isNotEmpty) {
      final ocupados = await (db.select(
        db.asignaciones,
      )..where((a) => a.actividadId.isIn(idsActividadesActivas)))
          .get();
      idsOcupadosHoy = ocupados.map((o) => o.funcionarioId).toSet();
    }

    // 5. Carga Semanal (Solo relevante para D1, pero se calcula siempre para info)
    final inicioSemana = targetDate.subtract(const Duration(days: 7));
    final asignacionesRecientes = await (db.select(db.asignaciones)
          ..where(
            (t) => t.fechaAsignacion.isBiggerOrEqual(Variable(inicioSemana)),
          ))
        .get();
    final Map<int, int> cargaLaboral = {};
    for (var a in asignacionesRecientes) {
      cargaLaboral[a.funcionarioId] = (cargaLaboral[a.funcionarioId] ?? 0) + 1;
    }

    List<Map<String, dynamic>> availableList = [];

    // 6. PROCESAMIENTO
    for (var f in allPersonnel) {
      // Filtros de exclusión absolutos
      if (idsReposoMedico.contains(f.id)) continue;
      if (idsOcupadosHoy.contains(f.id)) continue;

      int severity = 0;
      String statusText = "Disponible";

      // Filtros de severidad (Estado visual)
      if (idsVacaciones.contains(f.id)) {
        severity = 2; // Rojo
        statusText = "VACACIONES";
      } else if (idsEnDescanso.contains(f.id)) {
        severity = 2; // Rojo
        statusText = "POST-GUARDIA";
      } else {
        // Validación de preferencias (Solo afecta D1 usualmente)
        final preferencias = f.diasLibresPreferidos ?? '';
        if (preferencias.contains(dayName)) {
          severity = 1; // Amarillo
          statusText = "ESTUDIO/PREFERENCIA";
        }
      }

      availableList.add({
        'funcionario': f,
        'cargaSemanal': cargaLaboral[f.id] ?? 0,
        'saldo': f.saldoCompensacion,
        'severity': severity,
        'statusText': statusText,
        // Agregamos fecha última pernocta para el sort D2
        'ultimaPernocta': f.ultimaFechaPernocta,
      });
    }

    // 7. ORDENAMIENTO INTELIGENTE (El Núcleo del Módulo D)
    availableList.sort((a, b) {
      // Regla 0: Disponibilidad (Rojos al final siempre)
      final int sevA = a['severity'];
      final int sevB = b['severity'];
      if (sevA != sevB) return sevA.compareTo(sevB); // Menor severidad primero

      if (isOvernight) {
        // --- LÓGICA D2: ROTACIÓN CÍCLICA ---
        // Prioridad: Quien NUNCA ha hecho pernocta (null) va primero.
        // Luego: Quien tiene la fecha más antigua va primero.
        final DateTime? dateA = a['ultimaPernocta'];
        final DateTime? dateB = b['ultimaPernocta'];

        if (dateA == null && dateB == null) {
          // Si ninguno ha hecho, desempate por carga semanal (el que menos ha trabajado)
          return (a['cargaSemanal'] as int).compareTo(b['cargaSemanal'] as int);
        }
        if (dateA == null) return -1; // A es prioritario
        if (dateB == null) return 1; // B es prioritario

        // Ordenar por fecha: La fecha más vieja (menor) va primero
        return dateA.compareTo(dateB);
      } else {
        // --- LÓGICA D1: EQUIDAD SEMANAL ---
        // Prioridad: Quien tenga menos carga esta semana.
        final int cargaA = a['cargaSemanal'];
        final int cargaB = b['cargaSemanal'];
        if (cargaA != cargaB) return cargaA.compareTo(cargaB);

        // Desempate: Saldo de compensación (quien tenga más días a favor, descansa más, so prioridad baja?)
        // Normalmente queremos asignar al que tiene saldo 0 o negativo primero.
        // Aquí ordenamos: Mayor saldo -> Al final.
        return (b['saldo'] as int).compareTo(a['saldo'] as int);
      }
    });

    return availableList;
  }
}
