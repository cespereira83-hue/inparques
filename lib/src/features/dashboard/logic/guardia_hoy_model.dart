import '../../../data/local/app_database.dart';

class GuardiaHoyModel {
  final Funcionario funcionario;
  final int actividadId;
  final String lugar;

  GuardiaHoyModel({
    required this.funcionario,
    required this.actividadId,
    required this.lugar,
  });
}

/// Clase contenedora para los KPIs del Dashboard
class DashboardStats {
  final int personalActivoHoy;
  final int guardiasMes;
  final int incidenciasRecientes;

  DashboardStats({
    required this.personalActivoHoy,
    required this.guardiasMes,
    required this.incidenciasRecientes,
  });
}
