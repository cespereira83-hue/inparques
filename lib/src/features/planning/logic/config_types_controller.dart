import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../../../data/local/app_database.dart';

class ConfigTypesController extends ChangeNotifier {
  final AppDatabase db;
  List<TiposGuardiaData> _tipos = [];
  bool _isLoading = false;

  ConfigTypesController(this.db);

  List<TiposGuardiaData> get tipos => _tipos;
  bool get isLoading => _isLoading;

  /// Carga la lista de tipos desde la BD
  Future<void> cargarTipos() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Ordenamos alfabéticamente
      _tipos = await (db.select(
        db.tiposGuardia,
      )..orderBy([(t) => OrderingTerm.asc(t.nombre)])).get();
    } catch (e) {
      debugPrint("Error cargando tipos: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crea un nuevo tipo de guardia
  Future<bool> crearTipo(String nombre) async {
    try {
      await db
          .into(db.tiposGuardia)
          .insert(TiposGuardiaCompanion.insert(nombre: nombre.trim()));
      await cargarTipos(); // Recargar lista
      return true;
    } catch (e) {
      debugPrint("Error creando tipo: $e");
      return false; // Probablemente nombre duplicado (unique constraint)
    }
  }

  /// Edita el nombre de un tipo existente
  Future<bool> editarTipo(int id, String nuevoNombre) async {
    try {
      await (db.update(db.tiposGuardia)..where((t) => t.id.equals(id))).write(
        TiposGuardiaCompanion(nombre: Value(nuevoNombre.trim())),
      );
      await cargarTipos();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Activa o Desactiva un tipo (Soft Delete)
  Future<void> toggleEstado(int id, bool estadoActual) async {
    await (db.update(db.tiposGuardia)..where((t) => t.id.equals(id))).write(
      TiposGuardiaCompanion(activo: Value(!estadoActual)),
    );
    await cargarTipos();
  }
}
