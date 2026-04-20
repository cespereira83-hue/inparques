import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../../../data/local/app_database.dart';

class AuthController extends ChangeNotifier {
  final AppDatabase db;
  ConfigSetting? _config;
  bool _isAuthenticated = false;
  String _rolActual = 'Invitado';
  bool? _isSetupDone;

  AuthController(this.db);

  ConfigSetting? get config => _config;
  bool get isAuthenticated => _isAuthenticated;
  String get rolActual => _rolActual;
  bool? get isSetupDone => _isSetupDone;

  Future<void> checkInitialSetup() async {
    try {
      final result = await db.select(db.configSettings).get();
      if (result.isNotEmpty) {
        _config = result.first;
        _isSetupDone = true;
      } else {
        _isSetupDone = false;
      }
    } catch (e) {
      _isSetupDone = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveInitialConfig({
    required String parqueNombre,
    required String sectorNombre,
    required String ciudad,
    required String municipio,
    required String estado,
    required String jefeNombre,
    required String jefeApellido,
    required String jefeRango,
    required String usuario,
    required String password,
    required String preguntaSeguridad,
    required String respuestaSeguridad,
  }) async {
    await db.into(db.configSettings).insert(
          ConfigSettingsCompanion.insert(
            parqueNombre: Value(parqueNombre.trim()),
            sectorNombre: Value(sectorNombre.trim()),
            ciudad: Value(ciudad.trim()),
            municipio: Value(municipio.trim()),
            estado: Value(estado.trim()),
            nombreJefe: jefeNombre.trim(),
            apellidoJefe: Value(jefeApellido.trim()),
            rangoJefe: jefeRango.trim(),
            usuario: usuario.trim(),
            password: password.trim(),
            nombreInstitucion: const Value('INPARQUES'),
            preguntaSeguridad: Value(preguntaSeguridad.trim()),
            respuestaSeguridad: Value(respuestaSeguridad.trim().toLowerCase()),
          ),
        );
    await checkInitialSetup();
  }

  Future<bool> login(String usuario, String password) async {
    final inputUser = usuario.trim();
    final inputPass = password.trim();

    final configs = await db.select(db.configSettings).get();
    if (configs.isNotEmpty) {
      final config = configs.first;
      // BLINDAJE: Trim en ambos lados
      if (config.usuario.trim() == inputUser &&
          config.password.trim() == inputPass) {
        _isAuthenticated = true;
        _config = config;
        _rolActual = 'Administrador';
        notifyListeners();
        return true;
      }
    }

    final query = db.select(db.usuariosSistema)
      ..where((t) => t.usuario.equals(inputUser));
    final operadorResult = await query.getSingleOrNull();

    // BLINDAJE: Trim a la contraseña de la DB
    if (operadorResult != null && operadorResult.password.trim() == inputPass) {
      _isAuthenticated = true;
      if (configs.isNotEmpty) _config = configs.first;
      _rolActual = operadorResult.rol;
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<String?> registrarUsuario({
    required String usuario,
    required String password,
    required String pregunta,
    required String respuesta,
    required String claveAdmin,
  }) async {
    final configs = await db.select(db.configSettings).get();

    if (configs.isEmpty) {
      return "Error crítico: El sistema no posee un Administrador configurado.";
    }

    // BLINDAJE PRINCIPAL: Limpiamos espacios de la clave de DB y de la que ingresó el usuario
    if (configs.first.password.trim() != claveAdmin.trim()) {
      return "Contraseña maestra incorrecta";
    }

    final userTrim = usuario.trim();
    final passTrim = password.trim();

    if (configs.first.usuario.trim() == userTrim) {
      return "El nombre '$userTrim' está reservado para el Administrador.";
    }

    final existingUser = await (db.select(db.usuariosSistema)
          ..where((t) => t.usuario.equals(userTrim)))
        .getSingleOrNull();

    if (existingUser != null) {
      return "El usuario ya existe en la base de datos.";
    }

    try {
      await db.into(db.usuariosSistema).insert(
            UsuariosSistemaCompanion.insert(
              usuario: userTrim,
              password: passTrim,
              rol: const Value('Operador'),
              preguntaSeguridad: Value(pregunta.trim()),
              respuestaSeguridad: Value(respuesta.trim().toLowerCase()),
            ),
          );
      return null; // Null significa éxito
    } catch (e) {
      return "Error interno al escribir en la base de datos local.";
    }
  }

  Future<String?> obtenerPreguntaSeguridad(String usuarioBuscado) async {
    final userTrim = usuarioBuscado.trim();

    final configs = await db.select(db.configSettings).get();
    if (configs.isNotEmpty && configs.first.usuario.trim() == userTrim) {
      return configs.first.preguntaSeguridad;
    }

    final op = await (db.select(db.usuariosSistema)
          ..where((t) => t.usuario.equals(userTrim)))
        .getSingleOrNull();
    if (op != null) return op.preguntaSeguridad;

    return null;
  }

  Future<bool> recuperarAcceso({
    required String usuarioObjetivo,
    required String respuestaIngresada,
    required String nuevaClave,
  }) async {
    final userTrim = usuarioObjetivo.trim();
    final respTrim = respuestaIngresada.trim().toLowerCase();
    final passTrim = nuevaClave.trim();

    final configs = await db.select(db.configSettings).get();
    if (configs.isNotEmpty && configs.first.usuario.trim() == userTrim) {
      if (configs.first.respuestaSeguridad?.trim().toLowerCase() == respTrim) {
        await (db.update(db.configSettings)
              ..where((t) => t.id.equals(configs.first.id)))
            .write(ConfigSettingsCompanion(password: Value(passTrim)));
        await checkInitialSetup();
        return true;
      }
      return false;
    }

    final op = await (db.select(db.usuariosSistema)
          ..where((t) => t.usuario.equals(userTrim)))
        .getSingleOrNull();
    if (op != null) {
      if (op.respuestaSeguridad?.trim().toLowerCase() == respTrim) {
        await (db.update(db.usuariosSistema)..where((t) => t.id.equals(op.id)))
            .write(UsuariosSistemaCompanion(password: Value(passTrim)));
        return true;
      }
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _rolActual = 'Invitado';
    notifyListeners();
  }
}
