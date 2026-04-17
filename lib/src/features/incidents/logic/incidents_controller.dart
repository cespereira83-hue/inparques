import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../../../data/local/app_database.dart';

/// Clase auxiliar para empaquetar datos hacia el Generador de PDF
class ActaDataDTO {
  final Incidencia incidencia;
  final Actividade actividad;
  final Funcionario inasistente;
  final Funcionario? jefeServicio;
  final Funcionario? testigo1;
  final Funcionario? testigo2;
  final ConfigSetting? config; // Puede ser nulo si no se ha configurado
  final String tipoNombre; // Nuevo campo para el nombre real de la guardia

  ActaDataDTO({
    required this.incidencia,
    required this.actividad,
    required this.inasistente,
    this.jefeServicio,
    this.testigo1,
    this.testigo2,
    this.config,
    this.tipoNombre = "Servicio de Guardia",
  });
}

class IncidentsController extends ChangeNotifier {
  final AppDatabase db;

  IncidentsController(this.db);

  // ==========================================================
  // 1. CONSULTAS PREVIAS (Para llenar el formulario)
  // ==========================================================

  /// Busca actividades YA REALIZADAS (fecha <= hoy) para reportar faltas.
  Future<List<Actividade>> obtenerActividadesPasadas() async {
    final hoy = DateTime.now();
    // Normalizamos al final del día por si se reporta una de hoy mismo
    final finHoy = DateTime(hoy.year, hoy.month, hoy.day, 23, 59, 59);

    return (db.select(db.actividades)
          ..where((a) => a.fecha.isSmallerOrEqual(Variable(finHoy)))
          ..orderBy([(a) => OrderingTerm.desc(a.fecha)]))
        .get();
  }

  /// Obtiene todos los funcionarios asignados a esa actividad (posibles testigos/inasistentes)
  Future<List<Funcionario>> obtenerParticipantes(int actividadId) async {
    final query = db.select(db.asignaciones).join([
      innerJoin(db.funcionarios,
          db.funcionarios.id.equalsExp(db.asignaciones.funcionarioId))
    ]);
    query.where(db.asignaciones.actividadId.equals(actividadId));

    final rows = await query.get();
    return rows.map((r) => r.readTable(db.funcionarios)).toList();
  }

  // ==========================================================
  // 2. LÓGICA DE REGISTRO
  // ==========================================================

  Future<int> registrarInasistencia({
    required int actividadId,
    required int funcionarioId,
    int? testigo1Id,
    int? testigo2Id,
    String? observaciones,
  }) async {
    // Generamos una descripción base para tener registro rápido en BD
    // Nota: El PDF generará su propio texto legal detallado, esto es para el historial en pantalla.
    final actividad = await (db.select(db.actividades)
          ..where((a) => a.id.equals(actividadId)))
        .getSingle();

    final descripcionCorta =
        "Falta registrada en fecha ${actividad.fecha.day}/${actividad.fecha.month}/${actividad.fecha.year}. Actividad: ${actividad.nombreActividad}.";

    // Insertar en BD
    final id = await db.into(db.incidencias).insert(
          IncidenciasCompanion.insert(
            actividadId: actividadId,
            funcionarioInasistenteId: funcionarioId,
            fechaHoraRegistro: DateTime.now(),
            descripcion: descripcionCorta,
            tipo: const Value('Inasistencia'),
            testigoUnoId: Value(testigo1Id),
            testigoDosId: Value(testigo2Id),
            observaciones: Value(observaciones),
          ),
        );

    notifyListeners();
    return id;
  }

  // ==========================================================
  // 3. PREPARACIÓN DE DATOS PARA EL PDF (CRÍTICO)
  // ==========================================================

  Future<ActaDataDTO> prepararDatosActa(int incidenciaId) async {
    // 1. Recuperar Entidades Base
    final incidencia = await (db.select(db.incidencias)
          ..where((i) => i.id.equals(incidenciaId)))
        .getSingle();

    final actividad = await (db.select(db.actividades)
          ..where((a) => a.id.equals(incidencia.actividadId)))
        .getSingle();

    final inasistente = await (db.select(db.funcionarios)
          ..where((f) => f.id.equals(incidencia.funcionarioInasistenteId)))
        .getSingle();

    final config = await db.select(db.configSettings).getSingleOrNull();

    // 2. Recuperar Nombre Real del Tipo de Guardia
    String nombreTipo = "Guardia Ordinaria";
    if (actividad.tipoGuardiaId != null) {
      final tipoObj = await (db.select(db.tiposGuardia)
            ..where((t) => t.id.equals(actividad.tipoGuardiaId!)))
          .getSingleOrNull();
      if (tipoObj != null) {
        nombreTipo = tipoObj.nombre;
      }
    }

    // 3. Recuperar JEFE DE SERVICIO (Búsqueda Robusta)
    // Primero buscamos si alguien tiene el flag 'esJefeServicio' en la asignación
    Funcionario? jefeServicio;

    final queryJefe = db.select(db.asignaciones).join([
      innerJoin(db.funcionarios,
          db.funcionarios.id.equalsExp(db.asignaciones.funcionarioId))
    ]);
    queryJefe.where(db.asignaciones.actividadId.equals(actividad.id) &
        db.asignaciones.esJefeServicio.equals(true));

    final jefeRow = await queryJefe.getSingleOrNull();

    if (jefeRow != null) {
      jefeServicio = jefeRow.readTable(db.funcionarios);
    } else {
      // Fallback: Si no hay flag, usamos el campo jefeServicioId de la actividad (Legado)
      if (actividad.jefeServicioId != null) {
        jefeServicio = await (db.select(db.funcionarios)
              ..where((f) => f.id.equals(actividad.jefeServicioId!)))
            .getSingleOrNull();
      }
    }

    // 4. Recuperar Testigos
    Funcionario? t1;
    if (incidencia.testigoUnoId != null) {
      t1 = await (db.select(db.funcionarios)
            ..where((f) => f.id.equals(incidencia.testigoUnoId!)))
          .getSingleOrNull();
    }

    Funcionario? t2;
    if (incidencia.testigoDosId != null) {
      t2 = await (db.select(db.funcionarios)
            ..where((f) => f.id.equals(incidencia.testigoDosId!)))
          .getSingleOrNull();
    }

    // 5. Empaquetar y Retornar
    return ActaDataDTO(
      incidencia: incidencia,
      actividad: actividad,
      inasistente: inasistente,
      config: config,
      jefeServicio: jefeServicio,
      testigo1: t1,
      testigo2: t2,
      tipoNombre: nombreTipo,
    );
  }
}
