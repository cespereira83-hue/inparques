import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../../../data/local/app_database.dart';
import 'equity_algorithm.dart';

/// DTO auxiliar para transportar datos al PDF y a la UI de Planificación
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

/// DTO auxiliar para el listado de Actas/Incidencias
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
  final Map<DateTime, int> _memoriaCuposSemanales = {};

  PlanningController(this.db) {
    _algorithm = EquityAlgorithm(db);
  }

  EquityAlgorithm get algorithm => _algorithm;

  DateTime get focusedDay => _focusedDay;

  void setFocusedDay(DateTime date) {
    _focusedDay = date;
    notifyListeners();
  }

  // NUEVO: Método para avanzar el calendario al día siguiente tras guardar
  void avanzarDiaSiguiente() {
    _focusedDay = _focusedDay.add(const Duration(days: 1));
    notifyListeners();
  }

  int obtenerCupoDeSemana(DateTime fechaCualquiera) {
    final inicioSemana =
        fechaCualquiera.subtract(Duration(days: fechaCualquiera.weekday - 1));
    final key =
        DateTime(inicioSemana.year, inicioSemana.month, inicioSemana.day);
    return _memoriaCuposSemanales[key] ?? 4;
  }

  void guardarCupoDeSemana(DateTime fechaCualquiera, int cupo) {
    final inicioSemana =
        fechaCualquiera.subtract(Duration(days: fechaCualquiera.weekday - 1));
    final key =
        DateTime(inicioSemana.year, inicioSemana.month, inicioSemana.day);
    _memoriaCuposSemanales[key] = cupo;
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

  Future<List<Map<String, dynamic>>> obtenerPersonalConMetadata({
    DateTime? fecha,
    bool esPernocta = false,
    int? cupoOverride,
    int? actividadEditandoId,
  }) async {
    final targetDate = fecha ?? DateTime.now();

    try {
      final rawBase = await _algorithm.getAvailablePersonnel(
        targetDate: targetDate,
        dayName: _getDayName(targetDate),
        isOvernight: esPernocta,
      );

      final List<Map<String, dynamic>> personalBase =
          rawBase.map((e) => Map<String, dynamic>.from(e)).toList();

      if (actividadEditandoId != null) {
        final asignadosPrevios = await (db.select(db.asignaciones)
              ..where((a) => a.actividadId.equals(actividadEditandoId)))
            .get();

        for (var asignacion in asignadosPrevios) {
          final fId = asignacion.funcionarioId;
          final index = personalBase
              .indexWhere((p) => (p['funcionario'] as Funcionario).id == fId);

          if (index == -1) {
            final func = await (db.select(db.funcionarios)
                  ..where((f) => f.id.equals(fId)))
                .getSingleOrNull();
            if (func != null) {
              personalBase.add({
                'funcionario': func,
                'statusText': 'Ya asignado a esta guardia',
                'severity': 0,
              });
            }
          } else {
            personalBase[index]['severity'] = 0;
            personalBase[index]['statusText'] = 'Ya asignado a esta guardia';
          }
        }
      }

      if (esPernocta) {
        personalBase.sort((a, b) {
          final fA = a['funcionario'] as Funcionario;
          final fB = b['funcionario'] as Funcionario;
          if (fA.ultimaFechaPernocta == null && fB.ultimaFechaPernocta != null)
            return -1;
          if (fA.ultimaFechaPernocta != null && fB.ultimaFechaPernocta == null)
            return 1;
          if (fA.ultimaFechaPernocta == null && fB.ultimaFechaPernocta == null)
            return 0;
          return fA.ultimaFechaPernocta!.compareTo(fB.ultimaFechaPernocta!);
        });
        return personalBase;
      }

      final inicioSemana =
          targetDate.subtract(Duration(days: targetDate.weekday - 1));
      final finSemana = inicioSemana.add(const Duration(days: 6));

      final asignacionesSemana = await (db.select(db.asignaciones).join([
        innerJoin(db.actividades,
            db.actividades.id.equalsExp(db.asignaciones.actividadId))
      ])
            ..where(
                db.actividades.fecha.isBiggerOrEqual(Variable(inicioSemana)) &
                    db.actividades.fecha.isSmallerOrEqual(Variable(finSemana))))
          .get();

      List<Map<String, dynamic>> personalEnriquecido = [];
      final targetYMD =
          DateTime(targetDate.year, targetDate.month, targetDate.day);

      for (var item in personalBase) {
        final f = item['funcionario'] as Funcionario;
        int conteoSemana = 0;
        bool trabajaHoy = false;
        final bool esRescatado =
            (item['statusText'] == 'Ya asignado a esta guardia');

        for (var row in asignacionesSemana) {
          final asig = row.readTable(db.asignaciones);
          if (asig.funcionarioId == f.id) {
            final act = row.readTable(db.actividades);
            if (actividadEditandoId != null && act.id == actividadEditandoId) {
              continue;
            }
            conteoSemana++;
            final actDate =
                DateTime(act.fecha.year, act.fecha.month, act.fecha.day);
            if (actDate.isAtSameMomentAs(targetYMD)) trabajaHoy = true;
          }
        }

        final cupoMaximo = cupoOverride ?? f.diasLaboralesSemanales;
        final bool cupoLleno = conteoSemana >= cupoMaximo;

        Map<String, dynamic> newItem = Map.from(item);
        newItem['conteoSemana'] = conteoSemana;
        newItem['cupoMaximo'] = cupoMaximo;
        newItem['cupoLleno'] = cupoLleno;

        if (trabajaHoy && !esRescatado) {
          newItem['severity'] = 2;
          newItem['statusText'] = "YA ASIGNADO HOY EN OTRA GUARDIA";
        } else if (cupoLleno && !esRescatado) {
          newItem['severity'] = 2;
          newItem['statusText'] = "CUPO CUMPLIDO ($conteoSemana/$cupoMaximo)";
        } else {
          if (esRescatado) {
            newItem['severity'] = 0;
            newItem['statusText'] =
                "Ya asignado (Carga: $conteoSemana/$cupoMaximo)";
          } else {
            newItem['statusText'] =
                "${item['statusText'] ?? ''} • Carga: $conteoSemana/$cupoMaximo";
          }
        }
        personalEnriquecido.add(newItem);
      }

      return personalEnriquecido;
    } catch (e) {
      debugPrint('EXCEPCIÓN CRÍTICA en obtenerPersonalConMetadata: $e');
      return [];
    }
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
              .write(FuncionariosCompanion(
                  saldoCompensacion: Value(funcionario.saldoCompensacion + 1)));
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
      final DateTime? fechaBloqueoHasta = esPernocta
          ? fechaFin.add(Duration(days: diasDescansoGenerados))
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
            if (preferencias.contains(diaSemana)) generaCompensacion = true;
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
      _focusedDay = fechaInicio; // Mantenemos el foco en lo que se guardó
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
        final DateTime? fechaBloqueoHasta = esPernocta
            ? fechaFin.add(Duration(days: diasDescansoGenerados))
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
            if (preferencias.contains(diaSemana)) generaCompensacion = true;
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
        } else {
          if (act.jefeServicioId != null) {
            jefe = await (db.select(db.funcionarios)
                  ..where((f) => f.id.equals(act.jefeServicioId!)))
                .getSingleOrNull();
          }
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
          inasistente: row.readTable(db.funcionarios));
    }).toList();
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
    Funcionario? t1, t2;
    if (incidencia.testigoUnoId != null) {
      t1 = await (db.select(db.funcionarios)
            ..where((t) => t.id.equals(incidencia.testigoUnoId!)))
          .getSingleOrNull();
    }
    if (incidencia.testigoDosId != null) {
      t2 = await (db.select(db.funcionarios)
            ..where((t) => t.id.equals(incidencia.testigoDosId!)))
          .getSingleOrNull();
    }
    Funcionario? jefeServicio;
    if (actividad.jefeServicioId != null) {
      jefeServicio = await (db.select(db.funcionarios)
            ..where((t) => t.id.equals(actividad.jefeServicioId!)))
          .getSingleOrNull();
    }
    return {
      'incidencia': incidencia,
      'actividad': actividad,
      'inasistente': inasistente,
      'config': config,
      'testigo1': t1,
      'testigo2': t2,
      'jefeServicio': jefeServicio
    };
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
}
