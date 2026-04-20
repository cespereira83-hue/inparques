import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../../../data/local/app_database.dart';
import 'equity_algorithm.dart';
import '../../reports/logic/weekly_report_generator.dart';

class ReporteDataDTO {
  final Actividade actividad;
  final String tipoNombre;
  final List<Funcionario> funcionarios;
  final Funcionario? jefeServicio;

  ReporteDataDTO({
    required this.actividad,
    required this.tipoNombre,
    required this.funcionarios,
    this.jefeServicio,
  });
}

class IncidenciaDataDTO {
  final Incidencia incidencia;
  final Actividade actividad;
  final Funcionario inasistente;

  IncidenciaDataDTO({
    required this.incidencia,
    required this.actividad,
    required this.inasistente,
  });
}

class PlanningController extends ChangeNotifier {
  final AppDatabase db;
  late final EquityAlgorithm _algorithm;

  DateTime _focusedDay = DateTime.now();
  int _cupoSemanalGlobal = 4;

  PlanningController(this.db) {
    _algorithm = EquityAlgorithm(db);
  }

  EquityAlgorithm get algorithm => _algorithm;
  DateTime get focusedDay => _focusedDay;

  void setFocusedDay(DateTime date) {
    _focusedDay = date;
    notifyListeners();
  }

  void avanzarDiaSiguiente() {
    _focusedDay = _focusedDay.add(const Duration(days: 1));
    notifyListeners();
  }

  Future<int> obtenerCupoDeSemana(DateTime fecha) async {
    return _cupoSemanalGlobal;
  }

  Future<void> guardarCupoDeSemana(DateTime fecha, int cupo) async {
    _cupoSemanalGlobal = cupo;
    notifyListeners();
  }

  Future<Set<DateTime>> obtenerDiasConGuardiaEnSemana(
      DateTime inicioSemana) async {
    final finSemana = inicioSemana.add(const Duration(days: 6));
    final actividades = await (db.select(db.actividades)
          ..where((a) =>
              a.fecha.isBiggerOrEqual(Variable(inicioSemana)) &
              a.fecha.isSmallerOrEqual(Variable(finSemana))))
        .get();
    return actividades
        .map((a) => DateTime(a.fecha.year, a.fecha.month, a.fecha.day))
        .toSet();
  }

  Future<Set<int>> obtenerDiasOcupadosEnMes(int year, int month) async {
    final inicioMes = DateTime(year, month, 1);
    final finMes = DateTime(year, month + 1, 0, 23, 59, 59);
    final actividades = await (db.select(db.actividades)
          ..where((a) =>
              a.fecha.isBiggerOrEqual(Variable(inicioMes)) &
              a.fecha.isSmallerOrEqual(Variable(finMes))))
        .get();
    return actividades.map((a) => a.fecha.day).toSet();
  }

  Future<List<DateTimeRange>> obtenerPernoctasDelMes(
      int year, int month) async {
    final inicioMes = DateTime(year, month, 1);
    final actividades = await (db.select(db.actividades)
          ..where((a) =>
              a.esPernocta.equals(true) &
              a.fecha.isBiggerOrEqual(
                  Variable(inicioMes.subtract(const Duration(days: 30))))))
        .get();

    List<DateTimeRange> rangos = [];
    for (var act in actividades) {
      final finGuardia = act.fechaFin ?? act.fecha;
      if (act.fecha.month == month || finGuardia.month == month) {
        rangos.add(DateTimeRange(start: act.fecha, end: finGuardia));
      }
    }
    return rangos;
  }

  // ===========================================================================
  // INTEGRACIÓN OPTIMIZADA CON ALGORITMO D1/D2
  // ===========================================================================
  Future<List<Map<String, dynamic>>> obtenerPersonalConMetadata({
    DateTime? fecha,
    bool esPernocta = false,
    int? cupoOverride,
    int? actividadEditandoId,
  }) async {
    final targetDate = fecha ?? DateTime.now();

    // 1. Delegamos TODO al Algoritmo Central
    // El algoritmo ahora es lo suficientemente inteligente para descontar
    // la actividad actual si estamos en modo Edición y aplicar exclusiones absolutas.
    final List<Map<String, dynamic>> personalEnriquecido =
        await _algorithm.getAvailablePersonnel(
      fecha: targetDate,
      esPernocta: esPernocta,
      cupoMaximo: cupoOverride,
      actividadEditandoId: actividadEditandoId,
    );

    return personalEnriquecido;
  }

  Future<List<TiposGuardiaData>> obtenerTiposGuardia() async {
    return await (db.select(db.tiposGuardia)
          ..where((t) => t.activo.equals(true)))
        .get();
  }

  Future<List<Ubicacione>> obtenerUbicaciones() async {
    return await (db.select(db.ubicaciones)
          ..where((u) => u.activo.equals(true)))
        .get();
  }

  Future<ReporteDataDTO?> obtenerActividadPorId(int actividadId) async {
    final act = await (db.select(db.actividades)
          ..where((tbl) => tbl.id.equals(actividadId)))
        .getSingleOrNull();
    if (act == null) return null;

    final query = db.select(db.asignaciones).join([
      innerJoin(db.funcionarios,
          db.funcionarios.id.equalsExp(db.asignaciones.funcionarioId))
    ]);
    query.where(db.asignaciones.actividadId.equals(act.id));

    final rows = await query.get();
    final personal = rows.map((row) => row.readTable(db.funcionarios)).toList();

    Funcionario? jefe;
    try {
      final jefeRow = rows.firstWhere(
          (r) => r.readTable(db.asignaciones).esJefeServicio == true,
          orElse: () => rows.first);
      if (jefeRow.readTable(db.asignaciones).esJefeServicio) {
        jefe = jefeRow.readTable(db.funcionarios);
      } else if (act.jefeServicioId != null) {
        jefe = await (db.select(db.funcionarios)
              ..where((f) => f.id.equals(act.jefeServicioId!)))
            .getSingleOrNull();
      }
    } catch (e) {
      if (act.jefeServicioId != null) {
        jefe = await (db.select(db.funcionarios)
              ..where((f) => f.id.equals(act.jefeServicioId!)))
            .getSingleOrNull();
      }
    }

    String tipo = "";
    if (act.tipoGuardiaId != null) {
      final t = await (db.select(db.tiposGuardia)
            ..where((x) => x.id.equals(act.tipoGuardiaId!)))
          .getSingleOrNull();
      tipo = t?.nombre ?? "";
    }

    return ReporteDataDTO(
      actividad: act,
      tipoNombre: tipo,
      funcionarios: personal,
      jefeServicio: jefe,
    );
  }

  Future<void> asignarGuardia({
    required int actividadId,
    required List<int> funcionariosIds,
    DateTime? fechaActividad,
    DateTime? fechaBloqueoHasta,
  }) async {
    final fecha = fechaActividad ?? DateTime.now();
    final diaSemana = _getDayName(fecha);

    await db.transaction(() async {
      for (var fId in funcionariosIds) {
        final funcionario = await (db.select(db.funcionarios)
              ..where((t) => t.id.equals(fId)))
            .getSingle();
        final preferencias = funcionario.diasLibresPreferidos ?? '';
        final esDiaBloqueado = preferencias.contains(diaSemana);

        await db.into(db.asignaciones).insert(
              AsignacionesCompanion.insert(
                funcionarioId: fId,
                actividadId: actividadId,
                fechaAsignacion: Value(DateTime.now()),
                esCompensada: Value(esDiaBloqueado),
                fechaBloqueoHasta: Value(fechaBloqueoHasta),
              ),
            );

        if (esDiaBloqueado) {
          await (db.update(db.funcionarios)..where((t) => t.id.equals(fId)))
              .write(
            FuncionariosCompanion(
                saldoCompensacion: Value(funcionario.saldoCompensacion + 1)),
          );
        }
      }
    });

    _focusedDay = fecha;
    notifyListeners();
  }

  Future<void> guardarActividadCompleta({
    required String nombre,
    required int tipoGuardiaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String lugar,
    required List<int> funcionariosIds,
    required int jefeServicioId,
    bool esPernocta = false,
    int diasDescansoGenerados = 0,
    String? detalles,
  }) async {
    try {
      // FIX DE TIEMPO: Forzamos la fecha de bloqueo a las 00:00:00 del día correspondiente
      final DateTime? fechaBloqueoHasta = esPernocta
          ? DateTime(fechaFin.year, fechaFin.month, fechaFin.day)
              .add(Duration(days: diasDescansoGenerados))
          : null;

      final diaSemana = _getDayName(fechaInicio);

      await db.transaction(() async {
        final actividadId = await db.into(db.actividades).insert(
              ActividadesCompanion.insert(
                nombreActividad: nombre,
                tipoGuardiaId: Value(tipoGuardiaId),
                fecha: fechaInicio,
                fechaFin: Value(fechaFin),
                lugar: lugar,
                esPernocta: Value(esPernocta),
                diasDescansoGenerados: Value(diasDescansoGenerados),
                jefeServicioId: Value(jefeServicioId),
                categoria: Value(esPernocta ? 'Pernocta' : 'Ordinaria'),
                planificacionId: const Value(null),
              ),
            );

        for (var fId in funcionariosIds) {
          final esJefe = (fId == jefeServicioId);
          bool generaCompensacion = false;
          final funcionario = await (db.select(db.funcionarios)
                ..where((t) => t.id.equals(fId)))
              .getSingle();

          if (!esPernocta) {
            final preferencias = funcionario.diasLibresPreferidos ?? '';
            if (preferencias.contains(diaSemana)) {
              generaCompensacion = true;
            }
          }

          await db.into(db.asignaciones).insert(
                AsignacionesCompanion.insert(
                  funcionarioId: fId,
                  actividadId: actividadId,
                  fechaAsignacion: Value(DateTime.now()),
                  fechaBloqueoHasta: Value(fechaBloqueoHasta),
                  esCompensada: Value(generaCompensacion),
                  esJefeServicio: Value(esJefe),
                ),
              );

          var updateCompanion = FuncionariosCompanion(id: Value(fId));
          bool needsUpdate = false;

          if (generaCompensacion) {
            updateCompanion = updateCompanion.copyWith(
                saldoCompensacion: Value(funcionario.saldoCompensacion + 1));
            needsUpdate = true;
          }

          if (esPernocta) {
            updateCompanion =
                updateCompanion.copyWith(ultimaFechaPernocta: Value(fechaFin));
            needsUpdate = true;
          }

          if (needsUpdate) {
            await (db.update(db.funcionarios)..where((t) => t.id.equals(fId)))
                .write(updateCompanion);
          }
        }
      });

      _focusedDay = fechaInicio;
      notifyListeners();
    } catch (e) {
      debugPrint("ERROR CRÍTICO EN TRANSACTION: $e");
      rethrow;
    }
  }

  Future<void> editarActividad({
    required int actividadIdOriginal,
    required String nombre,
    required int tipoGuardiaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String lugar,
    required List<int> funcionariosIds,
    required int jefeServicioId,
    bool esPernocta = false,
    int diasDescansoGenerados = 0,
  }) async {
    try {
      await db.transaction(() async {
        await _revertirSaldosEliminacion(actividadIdOriginal);
        await (db.delete(db.asignaciones)
              ..where((t) => t.actividadId.equals(actividadIdOriginal)))
            .go();
        await (db.delete(db.actividades)
              ..where((t) => t.id.equals(actividadIdOriginal)))
            .go();

        // FIX DE TIEMPO: Forzamos la fecha de bloqueo a las 00:00:00 del día correspondiente
        final DateTime? fechaBloqueoHasta = esPernocta
            ? DateTime(fechaFin.year, fechaFin.month, fechaFin.day)
                .add(Duration(days: diasDescansoGenerados))
            : null;

        final diaSemana = _getDayName(fechaInicio);

        final nuevoId = await db.into(db.actividades).insert(
              ActividadesCompanion.insert(
                nombreActividad: nombre,
                tipoGuardiaId: Value(tipoGuardiaId),
                fecha: fechaInicio,
                fechaFin: Value(fechaFin),
                lugar: lugar,
                esPernocta: Value(esPernocta),
                diasDescansoGenerados: Value(diasDescansoGenerados),
                jefeServicioId: Value(jefeServicioId),
                categoria: Value(esPernocta ? 'Pernocta' : 'Ordinaria'),
                planificacionId: const Value(null),
              ),
            );

        for (var fId in funcionariosIds) {
          final esJefe = (fId == jefeServicioId);
          bool generaCompensacion = false;
          final funcionario = await (db.select(db.funcionarios)
                ..where((t) => t.id.equals(fId)))
              .getSingle();

          if (!esPernocta) {
            final preferencias = funcionario.diasLibresPreferidos ?? '';
            if (preferencias.contains(diaSemana)) {
              generaCompensacion = true;
            }
          }

          await db.into(db.asignaciones).insert(
                AsignacionesCompanion.insert(
                  funcionarioId: fId,
                  actividadId: nuevoId,
                  fechaAsignacion: Value(DateTime.now()),
                  fechaBloqueoHasta: Value(fechaBloqueoHasta),
                  esCompensada: Value(generaCompensacion),
                  esJefeServicio: Value(esJefe),
                ),
              );

          var updateCompanion = FuncionariosCompanion(id: Value(fId));
          bool needsUpdate = false;
          if (generaCompensacion) {
            updateCompanion = updateCompanion.copyWith(
                saldoCompensacion: Value(funcionario.saldoCompensacion + 1));
            needsUpdate = true;
          }
          if (esPernocta) {
            updateCompanion =
                updateCompanion.copyWith(ultimaFechaPernocta: Value(fechaFin));
            needsUpdate = true;
          }
          if (needsUpdate) {
            await (db.update(db.funcionarios)..where((t) => t.id.equals(fId)))
                .write(updateCompanion);
          }
        }
      });

      _focusedDay = fechaInicio;
      notifyListeners();
    } catch (e) {
      debugPrint("ERROR CRÍTICO EN EDICIÓN: $e");
      rethrow;
    }
  }

  // ===========================================================================
  // MÉTODOS DE REPORTE Y LISTADO
  // ===========================================================================

  Future<Map<String, dynamic>> generarPaqueteReporte(
      DateTime inicioSemana) async {
    final finSemana = inicioSemana.add(const Duration(days: 7));
    final config = await db.select(db.configSettings).getSingleOrNull();
    final actividades = await (db.select(db.actividades)
          ..where((a) {
            final finReal = coalesce([a.fechaFin, a.fecha]);
            return a.fecha.isSmallerOrEqual(Variable(finSemana)) &
                finReal.isBiggerOrEqual(Variable(inicioSemana));
          })
          ..orderBy([(a) => OrderingTerm.asc(a.fecha)]))
        .get();

    List<ReporteDataDTO> reporteItems = [];

    for (var act in actividades) {
      String tipo = "[SIN TIPO]";
      if (act.tipoGuardiaId != null) {
        final t = await (db.select(db.tiposGuardia)
              ..where((tbl) => tbl.id.equals(act.tipoGuardiaId!)))
            .getSingleOrNull();
        if (t != null) tipo = t.nombre;
      }

      final query = db.select(db.asignaciones).join([
        innerJoin(db.funcionarios,
            db.funcionarios.id.equalsExp(db.asignaciones.funcionarioId))
      ]);
      query.where(db.asignaciones.actividadId.equals(act.id));
      final rows = await query.get();
      final personal =
          rows.map((row) => row.readTable(db.funcionarios)).toList();

      Funcionario? jefe;
      try {
        final candidatosJefe = rows
            .where((r) => r.readTable(db.asignaciones).esJefeServicio == true);
        if (candidatosJefe.isNotEmpty) {
          jefe = candidatosJefe.first.readTable(db.funcionarios);
        } else if (act.jefeServicioId != null) {
          jefe = await (db.select(db.funcionarios)
                ..where((f) => f.id.equals(act.jefeServicioId!)))
              .getSingleOrNull();
        }
      } catch (e) {
        // Fallback silently
      }

      reporteItems.add(ReporteDataDTO(
          actividad: act,
          tipoNombre: tipo,
          funcionarios: personal,
          jefeServicio: jefe));
    }
    return {'config': config, 'items': reporteItems};
  }

  Future<Map<String, dynamic>> generarReporteMensualPernoctas(
      int year, int month) async {
    final inicioMes = DateTime(year, month, 1);
    final finMes = DateTime(year, month + 1, 0, 23, 59, 59);
    final config = await db.select(db.configSettings).getSingleOrNull();
    final actividades = await (db.select(db.actividades)
          ..where((a) =>
              a.esPernocta.equals(true) &
              a.fecha.isBiggerOrEqual(Variable(inicioMes)) &
              a.fecha.isSmallerOrEqual(Variable(finMes)))
          ..orderBy([(a) => OrderingTerm.asc(a.fecha)]))
        .get();

    List<ReporteDataDTO> reporteItems = [];

    for (var act in actividades) {
      String tipo = "Pernocta";
      if (act.tipoGuardiaId != null) {
        final t = await (db.select(db.tiposGuardia)
              ..where((tbl) => tbl.id.equals(act.tipoGuardiaId!)))
            .getSingleOrNull();
        if (t != null) tipo = t.nombre;
      }

      final query = db.select(db.asignaciones).join([
        innerJoin(db.funcionarios,
            db.funcionarios.id.equalsExp(db.asignaciones.funcionarioId))
      ]);
      query.where(db.asignaciones.actividadId.equals(act.id));
      final rows = await query.get();
      final personal =
          rows.map((row) => row.readTable(db.funcionarios)).toList();

      Funcionario? jefe;
      try {
        final candidatosJefe = rows
            .where((r) => r.readTable(db.asignaciones).esJefeServicio == true);
        if (candidatosJefe.isNotEmpty) {
          jefe = candidatosJefe.first.readTable(db.funcionarios);
        } else if (act.jefeServicioId != null) {
          jefe = await (db.select(db.funcionarios)
                ..where((f) => f.id.equals(act.jefeServicioId!)))
              .getSingleOrNull();
        }
      } catch (e) {}

      reporteItems.add(ReporteDataDTO(
          actividad: act,
          tipoNombre: tipo,
          funcionarios: personal,
          jefeServicio: jefe));
    }
    return {'config': config, 'items': reporteItems};
  }

  Future<PlanificacionReporteDTO?> prepararDatosReporteSemanal(
      DateTime inicioSemana) async {
    try {
      final finSemana = inicioSemana.add(const Duration(days: 6));
      return await _construirDTOGenerico(inicioSemana, finSemana, false);
    } catch (e) {
      debugPrint("Error al preparar reporte semanal: $e");
      return null;
    }
  }

  Future<PlanificacionReporteDTO?> prepararDatosReporteMensualPernocta(
      int year, int month) async {
    try {
      final inicioMes = DateTime(year, month, 1);
      final finMes = DateTime(year, month + 1, 0, 23, 59, 59);
      return await _construirDTOGenerico(inicioMes, finMes, true);
    } catch (e) {
      debugPrint("Error al preparar reporte mensual pernoctas: $e");
      return null;
    }
  }

  Future<PlanificacionReporteDTO> _construirDTOGenerico(
      DateTime inicioRango, DateTime finRango, bool esPernocta) async {
    final config = await db.select(db.configSettings).getSingleOrNull();
    if (config == null) throw Exception("Configuración no encontrada");

    final actividades = await (db.select(db.actividades)
          ..where((a) {
            final finReal = coalesce([a.fechaFin, a.fecha]);
            return a.fecha.isSmallerOrEqual(Variable(finRango)) &
                finReal.isBiggerOrEqual(Variable(inicioRango)) &
                (esPernocta ? a.esPernocta.equals(true) : const Constant(true));
          })
          ..orderBy([(a) => OrderingTerm.asc(a.fecha)]))
        .get();

    List<ActividadReporteDTO> listaActividadesDTO = [];

    for (var act in actividades) {
      String nombreAct = act.nombreActividad;
      if (act.tipoGuardiaId != null) {
        final t = await (db.select(db.tiposGuardia)
              ..where((tbl) => tbl.id.equals(act.tipoGuardiaId!)))
            .getSingleOrNull();
        if (t != null && nombreAct.isEmpty) nombreAct = t.nombre;
      }

      final queryAsignados = db.select(db.asignaciones).join([
        innerJoin(db.funcionarios,
            db.funcionarios.id.equalsExp(db.asignaciones.funcionarioId)),
        leftOuterJoin(
            db.rangos, db.rangos.id.equalsExp(db.funcionarios.rangoId)),
      ])
        ..where(db.asignaciones.actividadId.equals(act.id));

      final filasAsignados = await queryAsignados.get();
      Funcionario? jefeOriginal;
      List<FuncionarioReporteDTO> funcionariosDTO = [];

      for (var fila in filasAsignados) {
        final f = fila.readTable(db.funcionarios);
        final r = fila.readTableOrNull(db.rangos);
        final asig = fila.readTable(db.asignaciones);

        if (asig.esJefeServicio) jefeOriginal = f;
        funcionariosDTO.add(FuncionarioReporteDTO(
          nombreCompleto: "${f.nombres} ${f.apellidos}",
          cedula: f.cedula,
          rango: r?.nombre ?? f.rango ?? "S/R",
        ));
      }

      if (jefeOriginal == null && act.jefeServicioId != null) {
        jefeOriginal = await (db.select(db.funcionarios)
              ..where((f) => f.id.equals(act.jefeServicioId!)))
            .getSingleOrNull();
      }

      String jefeNombre = "No asignado";
      String jefeCedula = "N/A";
      if (jefeOriginal != null) {
        jefeNombre = "${jefeOriginal.nombres} ${jefeOriginal.apellidos}";
        jefeCedula = jefeOriginal.cedula;
      }

      listaActividadesDTO.add(ActividadReporteDTO(
        fecha: act.fecha,
        nombreActividad: nombreAct,
        lugar: act.lugar,
        jefeServicioNombre: jefeNombre,
        jefeServicioCedula: jefeCedula,
        funcionarios: funcionariosDTO,
      ));
    }

    return PlanificacionReporteDTO(
      fechaInicio: inicioRango,
      fechaFin: finRango,
      parqueNombre: config.parqueNombre ?? "PARQUE NO CONFIGURADO",
      sectorNombre: config.sectorNombre ?? "SECTOR NO CONFIGURADO",
      ciudad: config.ciudad ?? "N/A",
      municipio: config.municipio ?? "N/A",
      estado: config.estado ?? "N/A",
      jefeNombre: "${config.nombreJefe} ${config.apellidoJefe ?? ''}".trim(),
      jefeRango: config.rangoJefe,
      actividades: listaActividadesDTO,
    );
  }

  Future<List<ReporteDataDTO>> listarHistorial(
      {required bool esPernocta}) async {
    final actividades = await (db.select(db.actividades)
          ..where((a) => a.esPernocta.equals(esPernocta))
          ..orderBy([(a) => OrderingTerm.desc(a.fecha)]))
        .get();

    List<ReporteDataDTO> items = [];

    for (var act in actividades) {
      String tipo = "Actividad";
      if (act.tipoGuardiaId != null) {
        final t = await (db.select(db.tiposGuardia)
              ..where((tbl) => tbl.id.equals(act.tipoGuardiaId!)))
            .getSingleOrNull();
        if (t != null) tipo = t.nombre;
      }

      final query = db.select(db.asignaciones).join([
        innerJoin(db.funcionarios,
            db.funcionarios.id.equalsExp(db.asignaciones.funcionarioId))
      ]);
      query.where(db.asignaciones.actividadId.equals(act.id));
      final rows = await query.get();
      final personal =
          rows.map((row) => row.readTable(db.funcionarios)).toList();

      Funcionario? jefe;
      try {
        final candidatosJefe = rows
            .where((r) => r.readTable(db.asignaciones).esJefeServicio == true);
        if (candidatosJefe.isNotEmpty) {
          jefe = candidatosJefe.first.readTable(db.funcionarios);
        } else if (act.jefeServicioId != null) {
          jefe = await (db.select(db.funcionarios)
                ..where((f) => f.id.equals(act.jefeServicioId!)))
              .getSingleOrNull();
        }
      } catch (e) {}

      items.add(ReporteDataDTO(
          actividad: act,
          tipoNombre: tipo,
          funcionarios: personal,
          jefeServicio: jefe));
    }
    return items;
  }

  Future<List<IncidenciaDataDTO>> listarIncidencias() async {
    final query = db.select(db.incidencias).join([
      innerJoin(db.actividades,
          db.actividades.id.equalsExp(db.incidencias.actividadId)),
      innerJoin(db.funcionarios,
          db.funcionarios.id.equalsExp(db.incidencias.funcionarioInasistenteId))
    ])
      ..orderBy([OrderingTerm.desc(db.incidencias.fechaHoraRegistro)]);

    final rows = await query.get();

    return rows.map((row) {
      return IncidenciaDataDTO(
        incidencia: row.readTable(db.incidencias),
        actividad: row.readTable(db.actividades),
        inasistente: row.readTable(db.funcionarios),
      );
    }).toList();
  }

  Future<void> eliminarActividad(int actividadId) async {
    await db.transaction(() async {
      await _revertirSaldosEliminacion(actividadId);
      await (db.delete(db.asignaciones)
            ..where((t) => t.actividadId.equals(actividadId)))
          .go();
      await (db.delete(db.actividades)..where((t) => t.id.equals(actividadId)))
          .go();
    });
    notifyListeners();
  }

  Future<void> _revertirSaldosEliminacion(int actividadId) async {
    final asignaciones = await (db.select(db.asignaciones)
          ..where((t) => t.actividadId.equals(actividadId)))
        .get();
    for (var asign in asignaciones) {
      if (asign.esCompensada) {
        final f = await (db.select(db.funcionarios)
              ..where((t) => t.id.equals(asign.funcionarioId)))
            .getSingle();
        final nuevoSaldo =
            (f.saldoCompensacion - 1) < 0 ? 0 : (f.saldoCompensacion - 1);
        await (db.update(db.funcionarios)..where((t) => t.id.equals(f.id)))
            .write(FuncionariosCompanion(saldoCompensacion: Value(nuevoSaldo)));
      }
    }
  }

  String _getDayName(DateTime date) {
    const map = {
      1: 'LUN',
      2: 'MAR',
      3: 'MIER',
      4: 'JUE',
      5: 'VIE',
      6: 'SAB',
      7: 'DOM'
    };
    return map[date.weekday] ?? '';
  }

  // ===========================================================================
  // INTELIGENCIA DE ACTAS: EXTRACCIÓN MASIVA Y DINÁMICA DE TESTIGOS
  // ===========================================================================

  Future<void> registrarInasistenciaMasiva(
      int actividadId, List<int> inasistentesIds, String descripcion) async {
    await db.transaction(() async {
      for (int fId in inasistentesIds) {
        final existe = await (db.select(db.incidencias)
              ..where((t) =>
                  t.actividadId.equals(actividadId) &
                  t.funcionarioInasistenteId.equals(fId)))
            .getSingleOrNull();

        if (existe == null) {
          await db.into(db.incidencias).insert(
                IncidenciasCompanion.insert(
                  actividadId: actividadId,
                  funcionarioInasistenteId: fId,
                  fechaHoraRegistro: DateTime.now(),
                  descripcion: descripcion,
                  tipo: const Value('falta'),
                ),
              );
        }
      }
    });
    notifyListeners();
  }

  Future<Map<String, dynamic>> obtenerDatosActaCompleta(
      int incidenciaId) async {
    final incidencia = await (db.select(db.incidencias)
          ..where((t) => t.id.equals(incidenciaId)))
        .getSingle();
    final actividad = await (db.select(db.actividades)
          ..where((t) => t.id.equals(incidencia.actividadId)))
        .getSingle();
    final inasistente = await (db.select(db.funcionarios)
          ..where((t) => t.id.equals(incidencia.funcionarioInasistenteId)))
        .getSingle();
    final config = await db.select(db.configSettings).getSingleOrNull();

    final incidenciasDeLaGuardia = await (db.select(db.incidencias)
          ..where((t) => t.actividadId.equals(actividad.id)))
        .get();
    final inasistentesGlobalesIds =
        incidenciasDeLaGuardia.map((e) => e.funcionarioInasistenteId).toList();

    final queryAsignados = db.select(db.asignaciones).join([
      innerJoin(db.funcionarios,
          db.funcionarios.id.equalsExp(db.asignaciones.funcionarioId)),
      leftOuterJoin(db.rangos, db.rangos.id.equalsExp(db.funcionarios.rangoId)),
    ])
      ..where(db.asignaciones.actividadId.equals(actividad.id));

    final filasAsignados = await queryAsignados.get();

    List<Funcionario> presentes = [];
    Funcionario? jefeOriginal;

    for (var fila in filasAsignados) {
      final f = fila.readTable(db.funcionarios);
      final asig = fila.readTable(db.asignaciones);

      if (asig.esJefeServicio) jefeOriginal = f;

      if (!inasistentesGlobalesIds.contains(f.id)) {
        final r = fila.readTableOrNull(db.rangos);
        if (r != null) {
          presentes.add(f.copyWith(rango: Value(r.nombre)));
        } else {
          presentes.add(f);
        }
      }
    }

    if (jefeOriginal == null && actividad.jefeServicioId != null) {
      final qJefe = await (db.select(db.funcionarios)
            ..where((f) => f.id.equals(actividad.jefeServicioId!)))
          .getSingleOrNull();
      if (qJefe != null) {
        jefeOriginal = qJefe;
        if (!inasistentesGlobalesIds.contains(jefeOriginal.id) &&
            !presentes.any((p) => p.id == jefeOriginal!.id)) {
          presentes.insert(0, jefeOriginal);
        }
      }
    }

    Funcionario? jefeFirmante;
    if (jefeOriginal != null &&
        presentes.any((p) => p.id == jefeOriginal!.id)) {
      jefeFirmante = presentes.firstWhere((p) => p.id == jefeOriginal!.id);
    } else if (presentes.isNotEmpty) {
      jefeFirmante = presentes.first;
    }

    final posiblesTestigos =
        presentes.where((f) => f.id != jefeFirmante?.id).toList();

    Funcionario? t1, t2;
    if (incidencia.testigoUnoId != null) {
      t1 = await (db.select(db.funcionarios)
            ..where((t) => t.id.equals(incidencia.testigoUnoId!)))
          .getSingleOrNull();
    } else if (posiblesTestigos.isNotEmpty) {
      t1 = posiblesTestigos[0];
    }

    if (incidencia.testigoDosId != null) {
      t2 = await (db.select(db.funcionarios)
            ..where((t) => t.id.equals(incidencia.testigoDosId!)))
          .getSingleOrNull();
    } else if (posiblesTestigos.length > 1) {
      t2 = posiblesTestigos[1];
    }

    return {
      'incidencia': incidencia,
      'actividad': actividad,
      'inasistente': inasistente,
      'config': config,
      'testigo1': t1,
      'testigo2': t2,
      'jefeServicio': jefeFirmante,
    };
  }
}
