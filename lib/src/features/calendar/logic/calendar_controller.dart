import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/local/app_database.dart';

class CalendarController extends ChangeNotifier {
  final AppDatabase _db;

  CalendarController(this._db);

  /// Registrar una nueva ausencia (Vacación, Reposo, etc.)
  Future<void> registrarAusencia({
    required int funcionarioId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String motivo,
    String tipo = 'vacaciones',
  }) async {
    await _db.into(_db.ausencias).insert(
          AusenciasCompanion.insert(
            funcionarioId: funcionarioId,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            motivo: motivo,
            tipo: drift.Value(tipo),
          ),
        );
    notifyListeners();
  }

  /// Obtener ausencias que colisionen con un rango de fechas.
  /// CORRECCIÓN DEFINITIVA: Drift usa "Bigger" en lugar de "Greater".
  /// Usamos isBiggerOrEqual e isSmallerOrEqual con drift.Variable.
  Future<List<Ausencia>> obtenerAusenciasEnRango(
      DateTime inicio, DateTime fin) {
    return (_db.select(_db.ausencias)
          ..where((t) =>
              t.fechaInicio.isSmallerOrEqual(drift.Variable(fin)) &
              t.fechaFin.isBiggerOrEqual(drift.Variable(inicio))))
        .get();
  }

  /// Eliminar un registro de ausencia por su ID.
  Future<void> eliminarAusencia(int id) async {
    await (_db.delete(_db.ausencias)..where((t) => t.id.equals(id))).go();
    notifyListeners();
  }
}
