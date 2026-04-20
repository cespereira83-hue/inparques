import 'package:drift/drift.dart';
import '../../../data/local/app_database.dart';

class EquityAlgorithm {
  final AppDatabase db;

  EquityAlgorithm(this.db);

  /// Algoritmo Maestro de Disponibilidad y Equidad
  Future<List<Map<String, dynamic>>> getAvailablePersonnel({
    required DateTime fecha,
    required bool esPernocta,
    int? cupoMaximo,
    int?
        actividadEditandoId, // ID para ignorar la actividad actual si estamos editando
  }) async {
    // Normalización ESTRICTA de inicio y fin de día para evitar bugs de horas/minutos
    final startOfDay = DateTime(fecha.year, fecha.month, fecha.day);
    final endOfDay = DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59);

    // 1. Obtener UNIVERSO (Solo activos)
    final allPersonnel = await (db.select(db.funcionarios)
          ..where((t) => t.estaActivo.equals(true)))
        .get();

    // 2. Clasificación de AUSENCIAS (Vacaciones, Reposos)
    final ausencias = await (db.select(db.ausencias)
          ..where((t) =>
              t.fechaInicio.isSmallerOrEqualValue(endOfDay) &
              t.fechaFin.isBiggerOrEqualValue(startOfDay)))
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
    final queryBloqueos = db.select(db.asignaciones).join([
      innerJoin(db.actividades,
          db.actividades.id.equalsExp(db.asignaciones.actividadId))
    ]);

    Expression<bool> exprBloqueo =
        db.asignaciones.fechaBloqueoHasta.isNotNull() &
            db.asignaciones.fechaBloqueoHasta.isBiggerThanValue(startOfDay) &
            db.actividades.fecha.isSmallerOrEqualValue(endOfDay);

    if (actividadEditandoId != null) {
      exprBloqueo =
          exprBloqueo & db.actividades.id.isNotIn([actividadEditandoId]);
    }

    queryBloqueos.where(exprBloqueo);

    final bloqueos = await queryBloqueos.get();
    final idsEnDescanso = bloqueos
        .map((row) => row.readTable(db.asignaciones).funcionarioId)
        .toSet();

    // 4. YA ASIGNADO HOY (Bloqueo Físico por Actividad en curso ese mismo día)
    final actividadesActivasQuery = db.select(db.actividades)
      ..where((a) {
        // Lógica segura en Drift sin Coalesce
        Expression<bool> overlap = a.fecha.isSmallerOrEqualValue(endOfDay) &
            (a.fechaFin.isBiggerOrEqualValue(startOfDay) |
                (a.fechaFin.isNull() &
                    a.fecha.isBiggerOrEqualValue(startOfDay)));

        if (actividadEditandoId != null) {
          overlap = overlap & a.id.isNotIn([actividadEditandoId]);
        }
        return overlap;
      });

    final actividadesActivas = await actividadesActivasQuery.get();
    final idsActividadesActivas = actividadesActivas.map((a) => a.id).toList();

    Set<int> idsOcupadosHoy = {};
    if (idsActividadesActivas.isNotEmpty) {
      final ocupados = await (db.select(db.asignaciones)
            ..where((a) => a.actividadId.isIn(idsActividadesActivas)))
          .get();
      idsOcupadosHoy = ocupados.map((o) => o.funcionarioId).toSet();
    }

    // 5. CARGA SEMANAL (Cálculo estricto de Lunes a Domingo para D1)
    final int targetWeekday = fecha.weekday; // 1 = Lunes, 7 = Domingo
    final DateTime inicioSemana = DateTime(fecha.year, fecha.month, fecha.day)
        .subtract(Duration(days: targetWeekday - 1));
    final DateTime finSemana = inicioSemana
        .add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    final queryCarga = db.select(db.asignaciones).join([
      innerJoin(db.actividades,
          db.actividades.id.equalsExp(db.asignaciones.actividadId))
    ]);

    Expression<bool> exprCarga =
        db.actividades.fecha.isBiggerOrEqualValue(inicioSemana) &
            db.actividades.fecha.isSmallerOrEqualValue(finSemana);

    if (actividadEditandoId != null) {
      exprCarga = exprCarga & db.actividades.id.isNotIn([actividadEditandoId]);
    }

    queryCarga.where(exprCarga);

    final asignacionesRecientes = await queryCarga.get();
    final Map<int, int> cargaLaboral = {};

    for (var row in asignacionesRecientes) {
      final a = row.readTable(db.asignaciones);
      cargaLaboral[a.funcionarioId] = (cargaLaboral[a.funcionarioId] ?? 0) + 1;
    }

    List<Map<String, dynamic>> availableList = [];

    final diasNombres = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final dayName = diasNombres[fecha.weekday - 1];
    final int limiteCupo = cupoMaximo ?? 4;

    // 6. PROCESAMIENTO Y ASIGNACIÓN DE SEVERIDAD
    for (var f in allPersonnel) {
      // EXCLUSIONES ABSOLUTAS: (No aparecen en la lista)
      if (idsReposoMedico.contains(f.id)) continue;
      if (idsOcupadosHoy.contains(f.id))
        continue; // Estricto: Si está de guardia, fuera.
      if (idsEnDescanso.contains(f.id))
        continue; // Estricto: Si está post-pernocta, fuera.

      int severity = 0;
      String statusText = "Disponible";
      int carga = cargaLaboral[f.id] ?? 0;

      // Filtros de severidad visual
      if (idsVacaciones.contains(f.id)) {
        severity = 2; // Rojo
        statusText = "VACACIONES";
      } else if (!esPernocta && carga >= limiteCupo) {
        severity = 2;
        statusText = "CUPO EXCEDIDO ($carga/$limiteCupo)";
      } else {
        // Validación de preferencias (Amarillo)
        final preferencias = f.diasLibresPreferidos ?? '';
        if (preferencias.contains(dayName)) {
          severity = 1; // Amarillo
          statusText = "PREFERENCIA/ESTUDIO";
        }
      }

      availableList.add({
        'funcionario': f,
        'cargaSemanal': carga,
        'saldo': f.saldoCompensacion,
        'severity': severity,
        'statusText': statusText,
        'ultimaPernocta': f.ultimaFechaPernocta,
      });
    }

    // 7. ORDENAMIENTO INTELIGENTE (El Núcleo del Módulo D)
    availableList.sort((a, b) {
      final int sevA = a['severity'];
      final int sevB = b['severity'];
      if (sevA != sevB) return sevA.compareTo(sevB); // Menor severidad primero

      if (esPernocta) {
        final DateTime? dateA = a['ultimaPernocta'];
        final DateTime? dateB = b['ultimaPernocta'];

        if (dateA == null && dateB == null) {
          return (a['cargaSemanal'] as int).compareTo(b['cargaSemanal'] as int);
        }
        if (dateA == null) return -1;
        if (dateB == null) return 1;

        return dateA.compareTo(dateB);
      } else {
        final int cargaA = a['cargaSemanal'];
        final int cargaB = b['cargaSemanal'];
        if (cargaA != cargaB) return cargaA.compareTo(cargaB);

        return (a['saldo'] as int).compareTo(b['saldo'] as int);
      }
    });

    return availableList;
  }
}
