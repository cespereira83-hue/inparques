import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../../../data/local/app_database.dart';

class AuthController extends ChangeNotifier {
  final AppDatabase db;
  ConfigSetting? _config;
  bool _isAuthenticated = false;

  AuthController(this.db);

  ConfigSetting? get config => _config;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> checkInitialSetup() async {
    final result = await db.select(db.configSettings).get();
    if (result.isNotEmpty) {
      _config = result.first;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> saveInitialConfig({
    required String sectorNombre,
    required String municipio,
    required String jefeNombre,
    required String jefeApellido,
    required String jefeRango,
    required String usuario,
    required String password,
  }) async {
    await db.into(db.configSettings).insert(
          ConfigSettingsCompanion.insert(
            sectorNombre: Value(sectorNombre.trim()),
            municipio: Value(municipio.trim()),
            // CORRECCIÓN V10: Nombres de columnas actualizados
            nombreJefe: jefeNombre.trim(),
            apellidoJefe: Value(jefeApellido.trim()),
            rangoJefe: jefeRango.trim(),
            usuario: usuario.trim(),
            password: password.trim(),
            // Valores por defecto para nuevos campos obligatorios
            nombreInstitucion: const Value('INPARQUES'),
          ),
        );
    await checkInitialSetup();
  }

  Future<bool> login(String usuario, String password) async {
    final configs = await db.select(db.configSettings).get();

    if (configs.isEmpty) {
      debugPrint("LOGIN ERROR: No existe configuración en base de datos.");
      return false;
    }

    final config = configs.first;
    final inputUser = usuario.trim();
    final inputPass = password.trim();

    final success = config.usuario == inputUser && config.password == inputPass;

    if (success) {
      _isAuthenticated = true;
      _config = config;
      notifyListeners();
    } else {
      debugPrint("LOGIN FALLIDO: Credenciales incorrectas");
    }

    return success;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
