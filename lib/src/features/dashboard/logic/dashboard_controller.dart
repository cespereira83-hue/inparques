import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import '../../../data/local/app_database.dart';
import 'guardia_hoy_model.dart';

class DashboardController extends ChangeNotifier {
  final AppDatabase db;

  DashboardController(this.db);

  // --- NUEVO: CÁLCULO DE MÉTRICAS (KPIs) ---
  Future<DashboardStats> obtenerMetricas() async {
    final now = DateTime.now();

    // 1. Personal Activo Hoy (Funcionarios únicos asignados a actividades de hoy)
    // Normalizamos a inicio del día para comparar fechas sin hora
    final inicioHoy = DateTime(now.year, now.month, now.day);
    final finHoy = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final asignacionesHoy = await (db.select(db.asignaciones).join([
      innerJoin(db.actividades,
          db.actividades.id.equalsExp(db.asignaciones.actividadId))
    ])
          ..where(db.actividades.fecha.isBiggerOrEqual(Variable(inicioHoy)) &
              db.actividades.fecha.isSmallerOrEqual(Variable(finHoy))))
        .get();

    // Usamos un Set para contar funcionarios únicos (por si uno tiene doble turno)
    final funcionariosUnicos = asignacionesHoy
        .map((row) => row.readTable(db.asignaciones).funcionarioId)
        .toSet()
        .length;

    // 2. Guardias del Mes (Total de actividades en el mes actual)
    final inicioMes = DateTime(now.year, now.month, 1);
    final finMes = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final queryGuardias = db.select(db.actividades)
      ..where((t) =>
          t.fecha.isBiggerOrEqual(Variable(inicioMes)) &
          t.fecha.isSmallerOrEqual(Variable(finMes)));

    final guardiasMes = (await queryGuardias.get()).length;

    // 3. Alertas / Incidencias Recientes (Últimos 7 días)
    final haceSieteDias = now.subtract(const Duration(days: 7));

    final queryIncidencias = db.select(db.incidencias)
      ..where(
          (t) => t.fechaHoraRegistro.isBiggerOrEqual(Variable(haceSieteDias)));

    final incidenciasCount = (await queryIncidencias.get()).length;

    return DashboardStats(
      personalActivoHoy: funcionariosUnicos,
      guardiasMes: guardiasMes,
      incidenciasRecientes: incidenciasCount,
    );
  }

  // --- MÉTODOS EXISTENTES (LEGACY/UTILITARIOS) ---

  Future<List<GuardiaHoyModel>> obtenerGuardiaHoy() async {
    final hoy = DateTime.now();
    final inicioHoy = DateTime(hoy.year, hoy.month, hoy.day);
    // Ajuste para tomar todo el día
    final finHoy = DateTime(hoy.year, hoy.month, hoy.day, 23, 59, 59);

    final query = db.select(db.asignaciones).join([
      innerJoin(db.actividades,
          db.actividades.id.equalsExp(db.asignaciones.actividadId)),
      innerJoin(db.funcionarios,
          db.funcionarios.id.equalsExp(db.asignaciones.funcionarioId)),
    ])
      ..where(db.actividades.fecha.isBiggerOrEqual(Variable(inicioHoy)) &
          db.actividades.fecha.isSmallerOrEqual(Variable(finHoy)));

    final result = await query.get();

    return result.map((row) {
      final funcionario = row.readTable(db.funcionarios);
      final actividad = row.readTable(db.actividades);

      return GuardiaHoyModel(
        funcionario: funcionario,
        actividadId: actividad.id,
        lugar: actividad.lugar,
      );
    }).toList();
  }

  Future<List<Ausencia>> obtenerAusenciasHoy() async {
    final fecha = DateTime.now();
    return await (db.select(db.ausencias)
          ..where((t) =>
              t.fechaInicio.isSmallerOrEqualValue(fecha) &
              t.fechaFin.isBiggerOrEqualValue(fecha)))
        .get();
  }

  void actualizarDashboard() {
    notifyListeners();
  }
}
