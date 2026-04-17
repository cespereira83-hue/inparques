This file is a merged representation of a subset of the codebase, containing specifically included files and files not matching ignore patterns, combined into a single document by Repomix.

# File Summary

## Purpose
This file contains a packed representation of a subset of the repository's contents that is considered the most important context.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.

## File Format
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  a. A header with the file path (## File: path/to/file)
  b. The full contents of the file in a code block

## Usage Guidelines
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.

## Notes
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Only files matching these patterns are included: lib/**, pubspec.yaml
- Files matching these patterns are excluded: **/*.g.dart, **/*.freezed.dart, lib/generated_plugin_registrant.dart
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Files are sorted by Git change count (files with more changes are at the bottom)

# Directory Structure
```
lib/
  src/
    data/
      local/
        app_database.dart
    features/
      auth/
        logic/
          auth_controller.dart
        presentation/
          screens/
            initial_setup_screen.dart
            login_screen.dart
      calendar/
        logic/
          calendar_controller.dart
        presentation/
          screens/
            vacation_setup_screen.dart
      config/
        logic/
          backup_controller.dart
        presentation/
          screens/
            backup_screen.dart
            edit_config_screen.dart
            ubicaciones_screen.dart
      dashboard/
        logic/
          dashboard_controller.dart
          guardia_hoy_model.dart
        presentation/
          screens/
            dashboard_screen.dart
      incidents/
        logic/
          acta_generator.dart
          incident_generator.dart
          incidents_controller.dart
        presentation/
          screens/
            report_incident_screen.dart
      personal/
        logic/
          personal_controller.dart
        presentation/
          screens/
            funcionario_edit_screen.dart
            funcionario_profile_screen.dart
            funcionario_registration_screen.dart
            personal_list_screen.dart
      planning/
        logic/
          config_types_controller.dart
          equity_algorithm.dart
          planning_controller.dart
        presentation/
          screens/
            actividad_form_screen.dart
            config_types_screen.dart
            create_activity_screen.dart
            planning_history_screen.dart
            planning_screen.dart
      reports/
        logic/
          pdf_generator_service.dart
          weekly_report_generator.dart
        presentation/
          screens/
            report_config_screen.dart
  main.dart
pubspec.yaml
```

# Files

## File: lib/src/data/local/app_database.dart
```dart
import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// --- TABLAS DE CONFIGURACIÓN Y MAESTROS ---

class ConfigSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  // CAMBIO V10: Campos agregados y renombrados para compatibilidad con Reportes
  TextColumn get nombreInstitucion =>
      text().withDefault(const Constant('INPARQUES'))();
  TextColumn get sectorNombre => text().nullable()();
  TextColumn get municipio => text().nullable()();
  TextColumn get estado => text().nullable()();

  // Renombrado de columnas (antes jefeNombre, etc.) para coincidir con lógica
  TextColumn get nombreJefe => text()();
  TextColumn get apellidoJefe => text().nullable()();
  TextColumn get rangoJefe => text()();

  TextColumn get jefeCargo =>
      text().withDefault(const Constant('Jefe de Sector'))();
  TextColumn get usuario => text()();
  TextColumn get password => text()();
}

class Rangos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().unique()();
  TextColumn get descripcion => text().nullable()();
  IntColumn get prioridad => integer().withDefault(const Constant(99))();
}

class TiposGuardia extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().unique()();
  TextColumn get descripcion => text().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
}

class Ubicaciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().unique()();
  TextColumn get descripcion => text().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
}

// --- TABLAS DE PERSONAL ---

class Funcionarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombres => text()();
  TextColumn get apellidos => text()();
  TextColumn get cedula => text().unique().withLength(min: 6, max: 12)();

  // CAMBIO V9: Campos ahora opcionales (nullable)
  TextColumn get rango => text().nullable()();
  IntColumn get rangoId => integer().nullable().references(Rangos, #id)();
  DateTimeColumn get fechaNacimiento => dateTime().nullable()();
  DateTimeColumn get fechaIngreso => dateTime().nullable()();

  TextColumn get telefono => text().nullable()();
  IntColumn get diasLaboralesSemanales =>
      integer().withDefault(const Constant(4))();
  TextColumn get diasLibresPreferidos => text().nullable()();
  IntColumn get saldoCompensacion => integer().withDefault(const Constant(0))();
  BoolColumn get estaActivo => boolean().withDefault(const Constant(true))();
  TextColumn get fotoPath => text().nullable()();
  DateTimeColumn get ultimaFechaPernocta => dateTime().nullable()();
}

class EstudiosAcademicos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get funcionarioId => integer().references(Funcionarios, #id)();
  TextColumn get gradoInstruccion => text()();
  TextColumn get tituloObtenido => text()();
  TextColumn get rutaPdfTitulo => text().nullable()();
}

class CursosCertificados extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get funcionarioId => integer().references(Funcionarios, #id)();
  TextColumn get nombreCertificado => text()();
  TextColumn get rutaPdfCertificado => text().nullable()();
}

class Familiares extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get funcionarioId => integer().references(Funcionarios, #id)();
  TextColumn get nombres => text()();
  TextColumn get apellidos => text()();
  TextColumn get cedula => text()();
  IntColumn get edad => integer()();
  TextColumn get telefono => text().nullable()();
  TextColumn get parentesco => text().withDefault(const Constant('Cónyuge'))();
}

class Hijos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get funcionarioId => integer().references(Funcionarios, #id)();
  TextColumn get nombres => text()();
  TextColumn get apellidos => text()();
  IntColumn get edad => integer()();
}

// --- TABLAS OPERATIVAS ---

class PlanificacionesSemanales extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get fechaInicio => dateTime()();
  DateTimeColumn get fechaFin => dateTime()();
  TextColumn get codigo => text()();
  BoolColumn get cerrada => boolean().withDefault(const Constant(false))();
}

class Actividades extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planificacionId =>
      integer().nullable().references(PlanificacionesSemanales, #id)();
  IntColumn get tipoGuardiaId =>
      integer().nullable().references(TiposGuardia, #id)();
  TextColumn get nombreActividad => text()();
  DateTimeColumn get fecha => dateTime()();
  DateTimeColumn get fechaFin => dateTime().nullable()();
  TextColumn get lugar => text()();
  TextColumn get categoria => text().withDefault(const Constant('Normal'))();
  IntColumn get jefeServicioId =>
      integer().nullable().references(Funcionarios, #id)();
  BoolColumn get esPernocta => boolean().withDefault(const Constant(false))();
  IntColumn get diasDescansoGenerados =>
      integer().withDefault(const Constant(0))();
}

class Asignaciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get funcionarioId => integer().references(Funcionarios, #id)();
  IntColumn get actividadId => integer().references(Actividades, #id)();
  DateTimeColumn get fechaAsignacion =>
      dateTime().withDefault(Constant(DateTime.now()))();
  DateTimeColumn get fechaBloqueoHasta => dateTime().nullable()();
  BoolColumn get esCompensada => boolean().withDefault(const Constant(false))();
  BoolColumn get esJefeServicio =>
      boolean().withDefault(const Constant(false))();
}

class Ausencias extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get funcionarioId => integer().references(Funcionarios, #id)();
  DateTimeColumn get fechaInicio => dateTime()();
  DateTimeColumn get fechaFin => dateTime()();
  TextColumn get motivo => text()();
  TextColumn get tipo => text().withDefault(const Constant('vacaciones'))();
}

class Incidencias extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get actividadId => integer().references(Actividades, #id)();
  IntColumn get funcionarioInasistenteId =>
      integer().references(Funcionarios, #id)();
  DateTimeColumn get fechaHoraRegistro => dateTime()();
  TextColumn get descripcion => text()();
  TextColumn get tipo => text().withDefault(const Constant('falta'))();
  IntColumn get testigoUnoId =>
      integer().nullable().references(Funcionarios, #id)();
  IntColumn get testigoDosId =>
      integer().nullable().references(Funcionarios, #id)();
  TextColumn get observaciones => text().nullable()();
}

@DriftDatabase(
  tables: [
    ConfigSettings,
    Rangos,
    TiposGuardia,
    Ubicaciones,
    PlanificacionesSemanales,
    Funcionarios,
    EstudiosAcademicos,
    CursosCertificados,
    Familiares,
    Hijos,
    Actividades,
    Asignaciones,
    Ausencias,
    Incidencias,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // VERSIÓN 10: Sincronización para Reportes
  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedInitialData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(funcionarios, funcionarios.saldoCompensacion);
          await m.addColumn(asignaciones, asignaciones.esCompensada);
        }
        if (from < 3) {
          await m.addColumn(actividades, actividades.fechaFin);
        }
        if (from < 4) {
          await m.createTable(tiposGuardia);
          await m.createTable(planificacionesSemanales);
          await m.addColumn(actividades, actividades.planificacionId);
          await m.addColumn(actividades, actividades.tipoGuardiaId);
          await m.addColumn(actividades, actividades.categoria);
        }
        if (from < 5) {
          await m.addColumn(configSettings, configSettings.jefeCargo);
        }
        if (from < 6) {
          await m.createTable(rangos);
          await m.addColumn(funcionarios, funcionarios.fotoPath);
          await m.addColumn(funcionarios, funcionarios.rangoId);
          await _seedRangos();
        }
        if (from < 7) {
          await m.createTable(ubicaciones);
          await m.addColumn(funcionarios, funcionarios.ultimaFechaPernocta);
          await m.addColumn(actividades, actividades.esPernocta);
          await m.addColumn(actividades, actividades.diasDescansoGenerados);
          await m.addColumn(asignaciones, asignaciones.esJefeServicio);
          await into(ubicaciones).insert(
              const UbicacionesCompanion(nombre: Value('Sede Administrativa')));
        }
        if (from < 8) {
          await m.addColumn(incidencias, incidencias.testigoUnoId);
          await m.addColumn(incidencias, incidencias.testigoDosId);
          await m.addColumn(incidencias, incidencias.observaciones);
        }
        // V9: Flexibilización (implícita)

        if (from < 10) {
          // Migración para los campos de Reporte
          await m.addColumn(configSettings, configSettings.nombreInstitucion);
          await m.addColumn(configSettings, configSettings.estado);

          // Renombrado de columnas usando SQL directo de SQLite porque Drift
          // lo maneja mejor así para renames simples sin perder datos.
          // NOTA: Si es una base de datos nueva o con poca data, esto ajusta la estructura.
          await m.renameColumn(
              configSettings, 'jefe_nombre', configSettings.nombreJefe);
          await m.renameColumn(
              configSettings, 'jefe_apellido', configSettings.apellidoJefe);
          await m.renameColumn(
              configSettings, 'jefe_rango', configSettings.rangoJefe);
        }
      },
    );
  }

  Future<void> _seedInitialData() async {
    await _seedRangos();
    await into(tiposGuardia).insert(
        const TiposGuardiaCompanion(nombre: Value('Recorrido de Vigilancia')));
    await into(tiposGuardia).insert(
        const TiposGuardiaCompanion(nombre: Value('Guardia Preventiva')));
    await into(tiposGuardia).insert(const TiposGuardiaCompanion(
        nombre: Value('Inparques va a la Escuela')));
    await into(ubicaciones).insert(
        const UbicacionesCompanion(nombre: Value('Sede Administrativa')));
    await into(configSettings).insert(
      ConfigSettingsCompanion.insert(
        sectorNombre: const Value('Configuración Inicial'),
        nombreJefe: 'Administrador',
        rangoJefe: 'GP/.',
        jefeCargo: const Value('Jefe de Sector'),
        usuario: 'admin',
        password: 'admin123',
      ),
    );
  }

  Future<void> _seedRangos() async {
    final rangosIniciales = ['GP/.', 'GP/ T.', 'GP/ A.', 'GP/ S.'];
    for (var r in rangosIniciales) {
      await into(rangos)
          .insertOnConflictUpdate(RangosCompanion(nombre: Value(r)));
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
```

## File: lib/src/features/auth/logic/auth_controller.dart
```dart
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
```

## File: lib/src/features/auth/presentation/screens/initial_setup_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../data/local/app_database.dart';

class InitialSetupScreen extends StatefulWidget {
  final AppDatabase db; // Recibe la DB desde el main.dart
  const InitialSetupScreen({super.key, required this.db});

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _sectorController = TextEditingController();
  final _municipioController = TextEditingController();
  final _jefeNombreController = TextEditingController();
  final _jefeApellidoController = TextEditingController();
  final _jefeRangoController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _claveController = TextEditingController();

  bool _isSaving = false;

  Future<void> _saveSetup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // CORRECCIÓN V10: Uso de nuevos nombres de columna
      await widget.db.into(widget.db.configSettings).insert(
            ConfigSettingsCompanion.insert(
              sectorNombre: Value(_sectorController.text),
              municipio: Value(_municipioController.text),
              nombreJefe: _jefeNombreController.text, // Antes jefeNombre
              apellidoJefe:
                  Value(_jefeApellidoController.text), // Antes jefeApellido
              rangoJefe: _jefeRangoController.text, // Antes jefeRango
              usuario: _usuarioController.text,
              password: _claveController.text,
              nombreInstitucion: const Value('INPARQUES'),
            ),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Configuración guardada exitosamente")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración Inicial")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bienvenido. Configure los datos del sector y su cuenta de acceso.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle("Datos del Sector"),
              _buildTextField(
                  _sectorController, "Nombre del Sector", Icons.map),
              _buildTextField(
                  _municipioController, "Municipio", Icons.location_city),
              const SizedBox(height: 20),
              _buildSectionTitle("Datos del Jefe"),
              _buildTextField(_jefeNombreController, "Nombre", Icons.person),
              _buildTextField(
                  _jefeApellidoController, "Apellido", Icons.person_outline),
              _buildTextField(_jefeRangoController, "Rango (Ej. Sargento)",
                  Icons.military_tech),
              const SizedBox(height: 20),
              _buildSectionTitle("Seguridad de Acceso"),
              _buildTextField(_usuarioController, "Usuario Administrador",
                  Icons.admin_panel_settings),
              _buildTextField(_claveController, "Clave de Acceso", Icons.lock,
                  isPassword: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveSetup,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("FINALIZAR Y COMENZAR"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
      ),
    );
  }
}
```

## File: lib/src/features/auth/presentation/screens/login_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioController = TextEditingController();
  final _claveController = TextEditingController();
  bool _isLoggingIn = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _usuarioController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final usuario = _usuarioController.text.trim();
    final password = _claveController.text.trim();

    if (usuario.isEmpty || password.isEmpty) {
      _mostrarSnackBar("Por favor, ingrese sus credenciales");
      return;
    }

    setState(() => _isLoggingIn = true);

    try {
      final authController = context.read<AuthController>();
      final exito = await authController.login(usuario, password);

      if (!mounted) return;

      if (exito) {
        // CORRECCIÓN CRÍTICA:
        // Antes redirigía a '/' (Login), creando un bucle.
        // Ahora redirige a '/dashboard' (La pantalla principal).
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        _mostrarSnackBar("Usuario o contraseña incorrectos");
      }
    } catch (e) {
      _mostrarSnackBar("Error al conectar con el servicio de autenticación");
    } finally {
      if (mounted) setState(() => _isLoggingIn = false);
    }
  }

  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                "Sistema Inparques",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _usuarioController,
                decoration: InputDecoration(
                  labelText: "Usuario",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (_) => _handleLogin(),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _claveController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (_) => _handleLogin(),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoggingIn ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoggingIn
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("INICIAR SESIÓN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## File: lib/src/features/calendar/logic/calendar_controller.dart
```dart
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
```

## File: lib/src/features/calendar/presentation/screens/vacation_setup_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inparques/src/data/local/app_database.dart';
import 'package:inparques/src/features/calendar/logic/calendar_controller.dart';

class VacationSetupScreen extends StatefulWidget {
  const VacationSetupScreen({super.key});

  @override
  State<VacationSetupScreen> createState() => _VacationSetupScreenState();
}

class _VacationSetupScreenState extends State<VacationSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _motivoController = TextEditingController();
  int? _funcionarioId;
  DateTimeRange? _rangoFechas;
  String _tipoAusencia = 'vacaciones';
  bool _isSaving = false;

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _guardarAusencia() async {
    if (_funcionarioId == null || _rangoFechas == null) return;

    setState(() => _isSaving = true);
    final controller = context.read<CalendarController>();

    try {
      await controller.registrarAusencia(
        funcionarioId: _funcionarioId!,
        fechaInicio: _rangoFechas!.start,
        fechaFin: _rangoFechas!.end,
        motivo: _motivoController.text.isEmpty
            ? "Sin descripción"
            : _motivoController.text,
        tipo: _tipoAusencia,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Ausencia registrada con éxito"),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error al registrar: $e"),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Ausencias"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Text("Seleccione al Funcionario",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Funcionario>>(
                      future: (db.select(db.funcionarios)
                            ..where((t) => t.estaActivo.equals(true)))
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const LinearProgressIndicator();
                        }

                        return DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person)),
                          initialValue: _funcionarioId,
                          hint: const Text("Seleccionar Funcionario"),
                          items: snapshot.data!
                              .map((f) => DropdownMenuItem(
                                    value: f.id,
                                    child: Text("${f.nombres} ${f.apellidos}"),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() => _funcionarioId = val);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text("Tipo de Ausencia",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                            value: 'vacaciones',
                            label: Text('Vacaciones'),
                            icon: Icon(Icons.beach_access)),
                        ButtonSegment(
                            value: 'reposo',
                            label: Text('Reposo'),
                            icon: Icon(Icons.medical_services)),
                        ButtonSegment(
                            value: 'permiso',
                            label: Text('Permiso'),
                            icon: Icon(Icons.assignment_ind)),
                      ],
                      selected: {_tipoAusencia},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() => _tipoAusencia = newSelection.first);
                      },
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      title: const Text("Periodo de Ausencia"),
                      subtitle: Text(_rangoFechas == null
                          ? "Tocar para seleccionar calendario"
                          : "${_rangoFechas!.start.day}/${_rangoFechas!.start.month} al ${_rangoFechas!.end.day}/${_rangoFechas!.end.month}"),
                      trailing: const Icon(Icons.calendar_month,
                          color: Colors.orange),
                      onTap: () async {
                        final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                            builder: (context, child) {
                              return Theme(
                                  data: ThemeData.light().copyWith(
                                      colorScheme: const ColorScheme.light(
                                          primary: Colors.orange)),
                                  child: child!);
                            });
                        if (picked != null) {
                          setState(() => _rangoFechas = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _motivoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          labelText: "Observaciones / Motivo",
                          border: OutlineInputBorder(),
                          hintText:
                              "Ej: Vacaciones anuales correspondientes al periodo 2024..."),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed:
                            _rangoFechas == null || _funcionarioId == null
                                ? null
                                : _guardarAusencia,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white),
                        icon: const Icon(Icons.save),
                        label: const Text("REGISTRAR AUSENCIA",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
```

## File: lib/src/features/config/logic/backup_controller.dart
```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../../data/local/app_database.dart';

class BackupController extends ChangeNotifier {
  final AppDatabase db;
  bool _isLoading = false;

  BackupController(this.db);

  bool get isLoading => _isLoading;

  // --- GENERAR RESPALDO (EXPORTAR) ---
  Future<void> crearRespaldo(BuildContext context) async {
    _setLoading(true);
    try {
      // 1. Obtener directorio raíz de la app
      final appDir = await getApplicationDocumentsDirectory();

      // 2. Preparar el codificador ZIP
      final encoder = ZipFileEncoder();
      final fecha = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final zipPath = p.join(appDir.path, 'INPARQUES_BACKUP_$fecha.zip');

      encoder.create(zipPath);

      // 3. Agregar Base de Datos
      final dbFile = File(p.join(appDir.path, 'db.sqlite'));
      if (await dbFile.exists()) {
        await encoder.addFile(dbFile, 'db.sqlite');
      }

      // 4. Agregar Archivos Adjuntos (Fotos, PDFs)
      final files = appDir.listSync(recursive: true);
      for (var entity in files) {
        if (entity is File) {
          final filename = p.basename(entity.path);

          if (entity.path == zipPath) continue;
          if (filename == 'db.sqlite') continue;
          if (filename.contains('db.sqlite-wal')) continue;
          if (filename.contains('db.sqlite-shm')) continue;

          final relativePath = p.relative(entity.path, from: appDir.path);
          await encoder.addFile(entity, relativePath);
        }
      }

      encoder.close();

      // 5. Entregar al Usuario
      if (Platform.isAndroid || Platform.isIOS) {
        // CORRECCIÓN: Silenciamos la advertencia de deprecación
        // Share.shareXFiles es el método correcto en share_plus v9+,
        // pero el linter puede confundirse con versiones antiguas de 'share'.
        // ignore: deprecated_member_use
        await Share.shareXFiles([XFile(zipPath)],
            text: 'Respaldo Inparques $fecha');

        if (!context.mounted) return;
        _showMsg(context, "Respaldo compartido exitosamente", isError: false);
      } else {
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Guardar Respaldo',
          fileName: 'INPARQUES_BACKUP_$fecha.zip',
        );

        if (outputFile != null) {
          await File(zipPath).copy(outputFile);

          if (!context.mounted) return;
          _showMsg(context, "Respaldo guardado en PC", isError: false);
        }
      }

      final tempZip = File(zipPath);
      if (await tempZip.exists()) await tempZip.delete();
    } catch (e) {
      if (!context.mounted) return;
      _showMsg(context, "Error al crear respaldo: $e", isError: true);
    } finally {
      _setLoading(false);
    }
  }

  // --- RESTAURAR RESPALDO (IMPORTAR) ---
  Future<void> restaurarRespaldo(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result == null) return;

      if (!context.mounted) return;
      bool confirm = await _showConfirmDialog(context);
      if (!confirm) return;

      _setLoading(true);

      final File zipFile = File(result.files.single.path!);
      final appDir = await getApplicationDocumentsDirectory();

      await db.close();

      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File(p.join(appDir.path, filename))
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        }
      }

      _setLoading(false);

      if (!context.mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text("Restauración Completa"),
          content: const Text("La base de datos ha sido reemplazada.\n\n"
              "La aplicación debe cerrarse para aplicar los cambios. "
              "Por favor, ábrala nuevamente."),
          actions: [
            TextButton(
              onPressed: () => exit(0),
              child: const Text("CERRAR APLICACIÓN"),
            ),
          ],
        ),
      );
    } catch (e) {
      _setLoading(false);
      if (context.mounted) {
        _showMsg(context, "Error crítico al restaurar: $e", isError: true);
      }
    }
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _showMsg(BuildContext context, String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<bool> _showConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("⚠️ ¡ADVERTENCIA DE SEGURIDAD!"),
            content: const Text(
                "Está a punto de reemplazar TODA la información actual con el respaldo seleccionado.\n\n"
                "Esta acción es IRREVERSIBLE y borrará los datos actuales.\n\n"
                "¿Está seguro de continuar?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text("CANCELAR")),
              TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("SOBREESCRIBIR TODO")),
            ],
          ),
        ) ??
        false;
  }
}
```

## File: lib/src/features/config/presentation/screens/backup_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/local/app_database.dart';
import '../../logic/backup_controller.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BackupController(context.read<AppDatabase>()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Respaldo y Restauración")),
        body: Consumer<BackupController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                        "Procesando archivos grandes...\nNo cierre la aplicación.",
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.cloud_sync_outlined,
                      size: 80, color: Colors.blueGrey),
                  const SizedBox(height: 16),
                  const Text(
                    "Gestión de Seguridad de Datos",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Genere copias de seguridad periódicas para proteger la información del sistema ante fallos del equipo.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  _BackupCard(
                    title: "Crear Copia de Seguridad",
                    subtitle:
                        "Genera un archivo .ZIP con la base de datos y todas las fotos/documentos.",
                    icon: Icons.save_alt,
                    color: Colors.green,
                    onTap: () => controller.crearRespaldo(context),
                  ),
                  const SizedBox(height: 20),
                  _BackupCard(
                    title: "Restaurar desde Respaldo",
                    subtitle:
                        "Importa un archivo .ZIP. ¡CUIDADO! Esto borrará los datos actuales.",
                    icon: Icons.restore_page,
                    color: Colors.orange,
                    onTap: () => controller.restaurarRespaldo(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Nota: Al restaurar, la aplicación se cerrará automáticamente para aplicar los cambios.",
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BackupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BackupCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // FIX: withOpacity -> withValues (Flutter 3.27+)
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
```

## File: lib/src/features/config/presentation/screens/edit_config_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../data/local/app_database.dart';
import '../../../auth/logic/auth_controller.dart'; // Importar AuthController

class EditConfigScreen extends StatefulWidget {
  const EditConfigScreen({super.key});

  @override
  State<EditConfigScreen> createState() => _EditConfigScreenState();
}

class _EditConfigScreenState extends State<EditConfigScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _sectorController = TextEditingController();
  final _municipioController = TextEditingController();
  final _jefeNombreController = TextEditingController();
  final _jefeApellidoController = TextEditingController();
  final _jefeRangoController = TextEditingController();
  final _jefeCargoController = TextEditingController();

  bool _isLoading = true;
  int? _configId;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  @override
  void dispose() {
    _sectorController.dispose();
    _municipioController.dispose();
    _jefeNombreController.dispose();
    _jefeApellidoController.dispose();
    _jefeRangoController.dispose();
    _jefeCargoController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentData() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final config =
        await (db.select(db.configSettings)..limit(1)).getSingleOrNull();

    if (config != null) {
      setState(() {
        _configId = config.id;
        _sectorController.text = config.sectorNombre ?? '';
        _municipioController.text = config.municipio ?? '';
        _jefeNombreController.text = config.nombreJefe;
        _jefeApellidoController.text = config.apellidoJefe ?? '';
        _jefeRangoController.text = config.rangoJefe;
        _jefeCargoController.text = config.jefeCargo;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    if (_configId == null) return;

    setState(() => _isLoading = true);
    final db = Provider.of<AppDatabase>(context, listen: false);

    final updatedConfig = ConfigSettingsCompanion(
      sectorNombre: drift.Value(_sectorController.text),
      municipio: drift.Value(_municipioController.text),
      nombreJefe: drift.Value(_jefeNombreController.text),
      apellidoJefe: drift.Value(_jefeApellidoController.text),
      rangoJefe: drift.Value(_jefeRangoController.text),
      jefeCargo: drift.Value(_jefeCargoController.text),
    );

    try {
      await (db.update(db.configSettings)
            ..where((t) => t.id.equals(_configId!)))
          .write(updatedConfig);

      // FIX DASHBOARD: Recargar configuración en memoria
      if (mounted) {
        await context
            .read<AuthController>()
            .checkInitialSetup(); // Forzar recarga

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Datos actualizados correctamente'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos del Sector'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Información del Lugar',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    const Divider(),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _sectorController,
                      decoration: const InputDecoration(
                          labelText: 'Nombre del Sector / Parque',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.park, color: Colors.green)),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _municipioController,
                      decoration: const InputDecoration(
                          labelText: 'Municipio / Estado',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.map, color: Colors.green)),
                    ),
                    const SizedBox(height: 30),
                    const Text('Información del Jefe de Sector',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _jefeNombreController,
                            decoration: const InputDecoration(
                                labelText: 'Nombres',
                                border: OutlineInputBorder()),
                            validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _jefeApellidoController,
                            decoration: const InputDecoration(
                                labelText: 'Apellidos',
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _jefeRangoController,
                            decoration: const InputDecoration(
                              labelText: 'Rango',
                              hintText: 'Ej: S/M',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.star, color: Colors.green),
                            ),
                            validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _jefeCargoController,
                            decoration: const InputDecoration(
                              labelText: 'Cargo',
                              hintText: 'Ej: Jefe de Sector',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.work, color: Colors.green),
                            ),
                            validator: (v) => v!.isEmpty ? 'Requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: _saveData,
                        icon: const Icon(Icons.save),
                        label: const Text('GUARDAR CAMBIOS',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
```

## File: lib/src/features/config/presentation/screens/ubicaciones_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../data/local/app_database.dart';

class UbicacionesScreen extends StatefulWidget {
  const UbicacionesScreen({super.key});

  @override
  State<UbicacionesScreen> createState() => _UbicacionesScreenState();
}

class _UbicacionesScreenState extends State<UbicacionesScreen> {
  final _textController = TextEditingController();

  void _agregarUbicacion() async {
    if (_textController.text.isEmpty) return;
    final db = context.read<AppDatabase>();

    await db.into(db.ubicaciones).insert(
          UbicacionesCompanion(
            nombre: drift.Value(_textController.text),
            activo: const drift.Value(true),
          ),
        );
    _textController.clear();
    setState(() {}); // Recarga la lista
  }

  void _eliminar(Ubicacione u) async {
    final db = context.read<AppDatabase>();
    await (db.delete(db.ubicaciones)..where((t) => t.id.equals(u.id))).go();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Puestos/Ubicaciones")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: "Nuevo Puesto (Ej: Puesto La Silla)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _agregarUbicacion,
                )
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<Ubicacione>>(
              future: db.select(db.ubicaciones).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final list = snapshot.data!;
                if (list.isEmpty) {
                  return const Center(child: Text("Sin puestos registrados"));
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      leading: const Icon(Icons.place, color: Colors.indigo),
                      title: Text(item.nombre),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminar(item),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## File: lib/src/features/dashboard/logic/dashboard_controller.dart
```dart
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
```

## File: lib/src/features/dashboard/logic/guardia_hoy_model.dart
```dart
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
```

## File: lib/src/features/dashboard/presentation/screens/dashboard_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/logic/auth_controller.dart';
import '../../../personal/presentation/screens/personal_list_screen.dart';
import '../../../config/presentation/screens/edit_config_screen.dart';
import '../../../planning/presentation/screens/planning_history_screen.dart';
// Importamos controlador y modelo
import '../../logic/dashboard_controller.dart';
import '../../logic/guardia_hoy_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Para refrescar al volver de otras pantallas
  void _refreshStats() {
    setState(() {});
  }

  void _confirmarCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar Sesión"),
        content: const Text("¿Está seguro que desea salir del sistema?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: () {
              context.read<AuthController>().logout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Salir"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final dashController = context.read<DashboardController>();
    final config = auth.config;

    final rango = config?.rangoJefe ?? "";
    final nombre = "${config?.nombreJefe ?? ''} ${config?.apellidoJefe ?? ''}";
    final cargo = config?.jefeCargo ?? "Jefe de Sector";
    final datosFuncionario =
        "$rango $nombre, $cargo.".trim().replaceAll('  ', ' ');

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Sistema Inparques"),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Actualizar",
            onPressed: _refreshStats,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar Sesión",
            onPressed: () => _confirmarCerrarSesion(context),
          ),
        ],
      ),
      drawer: _buildDrawer(context, config, datosFuncionario),

      // SOLUCIÓN RESPONSIVE: LayoutBuilder detecta el tamaño de la ventana
      body: LayoutBuilder(builder: (context, constraints) {
        // Lógica de Breakpoints (Puntos de quiebre)
        // Si el ancho es mayor a 900px (Desktop), usamos hasta 4 columnas
        // Si es mayor a 600px (Tablet), 3 columnas
        // Si es menor (Celular), 2 columnas
        int columnas = 2;
        double anchoMaximo = double.infinity;

        if (constraints.maxWidth > 900) {
          columnas = 4;
          anchoMaximo =
              1000; // En PC limitamos el ancho para que no se estire infinito
        } else if (constraints.maxWidth > 600) {
          columnas = 3;
          anchoMaximo = 800;
        }

        return Center(
          // 1. Centramos todo el contenido en pantalla grande
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: anchoMaximo), // 2. Ponemos límite
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECCIÓN 1: ESTADÍSTICAS EN TIEMPO REAL ---
                  FutureBuilder<DashboardStats>(
                    future: dashController.obtenerMetricas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: LinearProgressIndicator()),
                        );
                      }

                      final stats = snapshot.data ??
                          DashboardStats(
                              personalActivoHoy: 0,
                              guardiasMes: 0,
                              incidenciasRecientes: 0);

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Resumen Operativo",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 10),
                            // En móvil usamos Row, pero si es muy estrecho podría necesitar ajuste
                            // Por ahora Row funciona bien para 3 stats
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    label: "Fuerza Hoy",
                                    value: stats.personalActivoHoy.toString(),
                                    icon: Icons.shield,
                                    color: Colors.blue.shade700,
                                    bgColor: Colors.blue.shade50,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _StatCard(
                                    label: "Guardias Mes",
                                    value: stats.guardiasMes.toString(),
                                    icon: Icons.calendar_today,
                                    color: Colors.orange.shade800,
                                    bgColor: Colors.orange.shade50,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _StatCard(
                                    label: "Novedades",
                                    value:
                                        stats.incidenciasRecientes.toString(),
                                    icon: Icons.warning_amber_rounded,
                                    color: stats.incidenciasRecientes > 0
                                        ? Colors.red.shade700
                                        : Colors.green.shade700,
                                    bgColor: stats.incidenciasRecientes > 0
                                        ? Colors.red.shade50
                                        : Colors.green.shade50,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  // --- SECCIÓN 2: MENÚ DE ACCESO RÁPIDO ---
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Accesos Directos",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 15),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: columnas, // 3. Columnas dinámicas
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.3,
                          children: [
                            _MenuTile(
                              title: "Personal",
                              icon: Icons.people,
                              color: Colors.green,
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const PersonalListScreen()));
                                _refreshStats();
                              },
                            ),
                            _MenuTile(
                              title: "Planificar",
                              icon: Icons.calendar_month,
                              color: Colors.blue,
                              onTap: () async {
                                await Navigator.pushNamed(context, '/planning');
                                _refreshStats();
                              },
                            ),
                            _MenuTile(
                              title: "Historial",
                              icon: Icons.history_edu,
                              color: Colors.teal,
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const PlanningHistoryScreen()));
                                _refreshStats();
                              },
                            ),
                            _MenuTile(
                              title: "Inasistencias",
                              icon: Icons.gavel,
                              color: Colors.red,
                              onTap: () async {
                                await Navigator.pushNamed(
                                    context, '/report_incident');
                                _refreshStats();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDrawer(
      BuildContext context, dynamic config, String datosFuncionario) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                image: AssetImage('assets/images/pattern.png'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.park, size: 40, color: Colors.green),
                ),
                const SizedBox(height: 15),
                Text(
                  config?.sectorNombre ?? "Nombre del Parque",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  config?.municipio ?? "Municipio / Estado",
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                ),
                const Divider(color: Colors.white24, height: 20),
                Row(
                  children: [
                    const Icon(Icons.person_pin,
                        color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        datosFuncionario,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text("Gestión de Personal"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PersonalListScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text("Planificación de Guardias"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/planning');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.teal),
                  title: const Text("Historial de Actividades"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PlanningHistoryScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.gavel, color: Colors.brown),
                  title: const Text("Legal e Incidencias"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/report_incident');
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: Text("CONFIGURACIÓN",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.edit_location_alt, color: Colors.green),
                  title: const Text("Datos del Sector"),
                  subtitle: const Text("Editar parque y responsable"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const EditConfigScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_applications,
                      color: Colors.blueGrey),
                  title: const Text("Catálogo de Guardias"),
                  subtitle: const Text("Tipos de actividades"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/config_types');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cloud_sync, color: Colors.orange),
                  title: const Text("Respaldo y Restauración"),
                  subtitle: const Text("Backup de Base de Datos"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/backup');
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Aplicación Elaborada Por GP/ César Pereira\n(Parque Nacional Gral. Juan Pablo Peñaloza...)",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  height: 1.2),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text("Cerrar Sesión",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              _confirmarCerrarSesion(context);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3)),
        ],
        border: Border.all(color: bgColor, width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
            maxLines: 1, // Evita overflow en pantallas pequeñas
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _MenuTile(
      {required this.title,
      required this.icon,
      required this.onTap,
      this.color = Colors.green});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
```

## File: lib/src/features/incidents/logic/acta_generator.dart
```dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

// CORRECCIÓN: Ruta ajustada para salir de 'features' y entrar a 'data' (hermana de 'core')
import '../../../data/local/app_database.dart';

class ActaGenerator {
  Future<Uint8List> generate(dynamic data) async {
    final pdf = pw.Document();

    final fontRegular = pw.Font.courier();
    final fontBold = pw.Font.courierBold();
    final fontItalic = pw.Font.courierOblique();

    final map = _normalizarDatos(data);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        build: (pw.Context context) {
          return [
            _buildHeader(map, fontBold),
            pw.SizedBox(height: 20),
            _buildTitle(map, fontBold),
            pw.SizedBox(height: 30),
            _buildBodyLegal(map, fontRegular, fontBold),
            pw.SizedBox(height: 20),
            if (map['observaciones'] != null &&
                map['observaciones'].toString().isNotEmpty)
              _buildObservaciones(map['observaciones'], fontItalic),
            pw.SizedBox(height: 50),
            _buildSignatures(map, fontRegular, fontBold),
            pw.Spacer(),
            _buildFooter(fontRegular),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Map<String, dynamic> _normalizarDatos(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    try {
      return {
        'config': (data as dynamic).config,
        'actividad': (data as dynamic).actividad,
        'incidencia': (data as dynamic).incidencia,
        'jefeServicio': (data as dynamic).jefeServicio,
        'testigo1': (data as dynamic).testigo1,
        'testigo2': (data as dynamic).testigo2,
        'inasistente': (data as dynamic).inasistente,
        'observaciones': (data as dynamic).incidencia.observaciones,
      };
    } catch (e) {
      return {};
    }
  }

  pw.Widget _buildHeader(Map<String, dynamic> map, pw.Font font) {
    final config = map['config'] as ConfigSetting?;

    final sector = config?.sectorNombre?.toUpperCase() ?? "SECTOR NO DEFINIDO";
    final estado = config?.estado?.toUpperCase() ?? "ESTADO";

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text("REPÚBLICA BOLIVARIANA DE VENEZUELA",
            style: pw.TextStyle(font: font, fontSize: 9)),
        pw.Text("MINISTERIO DEL PODER POPULAR PARA EL ECOSOCIALISMO",
            style: pw.TextStyle(font: font, fontSize: 9)),
        pw.Text("INSTITUTO NACIONAL DE PARQUES",
            style: pw.TextStyle(font: font, fontSize: 9)),
        pw.Text("CUERPO CIVIL DE GUARDAPARQUES",
            style: pw.TextStyle(font: font, fontSize: 9)),
        pw.SizedBox(height: 4),
        pw.Text(sector,
            style: pw.TextStyle(
                font: font,
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                decoration: pw.TextDecoration.underline)),
        pw.Text(estado, style: pw.TextStyle(font: font, fontSize: 8)),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildTitle(Map<String, dynamic> map, pw.Font font) {
    final incidencia = map['incidencia'] as Incidencia?;
    final numero = incidencia?.id.toString().padLeft(4, '0') ?? "0000";
    final anio = DateTime.now().year;

    return pw.Container(
        width: double.infinity,
        alignment: pw.Alignment.centerRight,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text("ACTA ADMINISTRATIVA DE NOVEDADES",
                style: pw.TextStyle(
                    font: font, fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Text("N° ACTA: $numero-$anio",
                style: pw.TextStyle(
                    font: font, fontSize: 10, color: PdfColors.red900)),
          ],
        ));
  }

  pw.Widget _buildBodyLegal(
      Map<String, dynamic> map, pw.Font regular, pw.Font bold) {
    final incidencia = map['incidencia'] as Incidencia?;
    final actividad = map['actividad'] as Actividade?;
    final inasistente = map['inasistente'] as Funcionario?;

    if (incidencia == null || actividad == null || inasistente == null) {
      return pw.Text("ERROR: Datos incompletos para generar el acta.");
    }

    final fechaAct = actividad.fecha;
    final dia = fechaAct.day;
    final mes = _nombreMes(fechaAct.month);
    final anio = fechaAct.year;

    final nombreFunc =
        "${inasistente.nombres} ${inasistente.apellidos}".toUpperCase();
    final cedulaFunc = inasistente.cedula;
    final rangoFunc = inasistente.rango ?? "Funcionario";

    final lugar = actividad.lugar;
    final tipoGuardia = map['tipoNombre'] ?? "Servicio Ordinario";
    final motivo = incidencia.descripcion;

    final texto = [
      pw.TextSpan(text: "En la localidad de "),
      pw.TextSpan(
          text: lugar.toUpperCase(),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: ", a los "),
      pw.TextSpan(
          text: "$dia", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: " días del mes de "),
      pw.TextSpan(
          text: mes.toUpperCase(),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: " del año "),
      pw.TextSpan(
          text: "$anio", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(
          text:
              ", quien suscribe, actuando en conformidad con las atribuciones conferidas por la Ley, procedo a dejar constancia formal de la siguiente novedad:\n\n"),
      pw.TextSpan(text: "Que el ciudadano(a) "),
      pw.TextSpan(
          text: nombreFunc,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: ", titular de la Cédula de Identidad N° "),
      pw.TextSpan(
          text: "V-$cedulaFunc",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: ", ostentando el rango de "),
      pw.TextSpan(text: rangoFunc.toUpperCase()),
      pw.TextSpan(text: ", "),
      pw.TextSpan(
          text: "NO SE PRESENTÓ",
          style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
      pw.TextSpan(
          text:
              " a cumplir con sus deberes asignados correspondientes a la actividad denominada "),
      pw.TextSpan(
          text: "\"${actividad.nombreActividad}\"",
          style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
      pw.TextSpan(
          text:
              " ($tipoGuardia), la cual estaba pautada para dar inicio en la fecha señalada.\n\n"),
      pw.TextSpan(text: "Dicha ausencia se registra bajo la descripción: "),
      pw.TextSpan(
          text: motivo.toUpperCase(),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.TextSpan(text: "."),
    ];

    return pw.RichText(
      text: pw.TextSpan(
          children: texto,
          style: pw.TextStyle(font: regular, fontSize: 11, lineSpacing: 6)),
      textAlign: pw.TextAlign.justify,
    );
  }

  pw.Widget _buildObservaciones(String obs, pw.Font italic) {
    return pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            color: PdfColors.grey100),
        width: double.infinity,
        child: pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text("OBSERVACIONES ADICIONALES:",
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text(obs, style: pw.TextStyle(font: italic, fontSize: 10)),
        ]));
  }

  pw.Widget _buildSignatures(
      Map<String, dynamic> map, pw.Font regular, pw.Font bold) {
    final List<pw.Widget> firmas = [];
    final config = map['config'] as ConfigSetting?;

    final jefeServicio = map['jefeServicio'] as Funcionario?;
    final testigo1 = map['testigo1'] as Funcionario?;
    final testigo2 = map['testigo2'] as Funcionario?;

    bool hayTestigo1 = testigo1 != null;
    bool hayTestigo2 = testigo2 != null;

    if (!hayTestigo1 && !hayTestigo2) {
      if (config != null) {
        firmas.add(_signatureLine(
            config.jefeCargo,
            "${config.nombreJefe} ${config.apellidoJefe ?? ''}",
            config.rangoJefe,
            "C.I. NO REGISTRADA",
            regular,
            bold));
      }
    } else {
      if (jefeServicio != null) {
        firmas.add(_signatureLine(
            "JEFE DE SERVICIOS",
            "${jefeServicio.nombres} ${jefeServicio.apellidos}",
            jefeServicio.rango ?? 'S/R',
            "C.I. ${jefeServicio.cedula}",
            regular,
            bold));
      }

      if (hayTestigo1) {
        firmas.add(_signatureLine(
            "TESTIGO 1",
            "${testigo1.nombres} ${testigo1.apellidos}",
            testigo1.rango ?? 'S/R',
            "C.I. ${testigo1.cedula}",
            regular,
            bold));
      }

      if (hayTestigo2) {
        firmas.add(_signatureLine(
            "TESTIGO 2",
            "${testigo2.nombres} ${testigo2.apellidos}",
            testigo2.rango ?? 'S/R',
            "C.I. ${testigo2.cedula}",
            regular,
            bold));
      }
    }

    return pw.Wrap(
      spacing: 20,
      runSpacing: 30,
      alignment: pw.WrapAlignment.center,
      children: firmas,
    );
  }

  pw.Widget _signatureLine(String cargo, String nombre, String rango,
      String cedula, pw.Font reg, pw.Font bold) {
    return pw.Container(
      width: 180,
      child: pw.Column(
        children: [
          pw.Container(width: 140, height: 1, color: PdfColors.black),
          pw.SizedBox(height: 5),
          pw.Text(nombre.toUpperCase(),
              style: pw.TextStyle(font: bold, fontSize: 9),
              textAlign: pw.TextAlign.center),
          pw.Text(cedula, style: pw.TextStyle(font: reg, fontSize: 8)),
          pw.Text("$rango - $cargo",
              style: pw.TextStyle(font: reg, fontSize: 8),
              textAlign: pw.TextAlign.center),
          pw.SizedBox(height: 15),
          pw.Container(
              width: 50,
              height: 70,
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300, width: 1)),
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text("HUELLA",
                        style: const pw.TextStyle(
                            fontSize: 5, color: PdfColors.grey600)),
                    pw.SizedBox(height: 2),
                  ])),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Font font) {
    final fechaGen = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Documento generado electrónicamente - Sistema Inparques",
                style: pw.TextStyle(
                    font: font, fontSize: 7, color: PdfColors.grey700)),
            pw.Text(fechaGen,
                style: pw.TextStyle(
                    font: font, fontSize: 7, color: PdfColors.grey700)),
          ],
        )
      ],
    );
  }

  String _nombreMes(int mes) {
    const meses = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ];
    if (mes < 1 || mes > 12) return "Mes Desconocido";
    return meses[mes - 1];
  }
}
```

## File: lib/src/features/incidents/logic/incident_generator.dart
```dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../../data/local/app_database.dart';

class IncidentGenerator {
  static Future<void> generarActaInasistencia({
    required ConfigSetting config,
    required Funcionario inasistente,
    required String motivo,
    required DateTime fechaFalta,
    required List<Funcionario> testigos,
    required Funcionario? jefeServicio,
  }) async {
    final pdf = pw.Document();
    final dateStr = DateFormat('dd/MM/yyyy').format(fechaFalta);
    final hourStr = DateFormat('hh:mm a').format(fechaFalta);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("REPÚBLICA BOLIVARIANA DE VENEZUELA",
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          "MINISTERIO DEL PODER POPULAR PARA EL ECOSOCIALISMO",
                          style: const pw.TextStyle(fontSize: 9)),
                      pw.Text("INSTITUTO NACIONAL DE PARQUES (INPARQUES)",
                          style: pw.TextStyle(
                              fontSize: 9, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          "SECTOR: ${config.sectorNombre?.toUpperCase() ?? 'NO DEFINIDO'}",
                          style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                  pw.Text("ACTA N°: ${fechaFalta.millisecondsSinceEpoch}",
                      style: const pw.TextStyle(color: PdfColors.grey700)),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Center(
                child: pw.Text("ACTA DE INASISTENCIA LABORAL",
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline)),
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                "En la fecha $dateStr, siendo las $hourStr, se deja constancia formal de la inasistencia del ciudadano(a) "
                "${inasistente.nombres.toUpperCase()} ${inasistente.apellidos.toUpperCase()}, titular de la cédula de identidad "
                "V-${inasistente.cedula}, quien desempeña el cargo de ${inasistente.rango}. Motivo informado: $motivo.",
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(fontSize: 12, lineSpacing: 1.5),
              ),
              pw.Spacer(),
              _buildFirmasCascada(jefeServicio, testigos, config),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Acta_Inasistencia_${inasistente.cedula}.pdf',
    );
  }

  static pw.Widget _buildFirmasCascada(Funcionario? jefeServicio,
      List<Funcionario> testigos, ConfigSetting config) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            // Firma de Autoridad
            if (jefeServicio != null)
              _buildFirmaIndividual(
                  "${jefeServicio.nombres} ${jefeServicio.apellidos}",
                  jefeServicio.cedula,
                  "JEFE DE SERVICIO")
            else
              // CORRECCIÓN: nombreJefe, rangoJefe (Sin null check excesivo si drift lo garantiza)
              _buildFirmaIndividual(
                  config.nombreJefe, "ADMIN", "${config.rangoJefe} (SISTEMA)"),

            if (testigos.isNotEmpty)
              _buildFirmaIndividual(
                  "${testigos[0].nombres} ${testigos[0].apellidos}",
                  testigos[0].cedula,
                  "TESTIGO 1"),
          ],
        ),
        if (testigos.length >= 2) ...[
          pw.SizedBox(height: 40),
          pw.Center(
            child: _buildFirmaIndividual(
                "${testigos[1].nombres} ${testigos[1].apellidos}",
                testigos[1].cedula,
                "TESTIGO 2"),
          ),
        ]
      ],
    );
  }

  static pw.Widget _buildFirmaIndividual(
      String nombre, String cedula, String cargo) {
    return pw.Column(
      children: [
        pw.Container(
            width: 180,
            decoration: const pw.BoxDecoration(
                border: pw.Border(top: pw.BorderSide(width: 1)))),
        pw.Text(nombre.toUpperCase(),
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        pw.Text("V-$cedula", style: const pw.TextStyle(fontSize: 9)),
        pw.Text(cargo, style: const pw.TextStyle(fontSize: 8)),
      ],
    );
  }
}
```

## File: lib/src/features/incidents/logic/incidents_controller.dart
```dart
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
```

## File: lib/src/features/incidents/presentation/screens/report_incident_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart'; // Para visualizar PDF
import '../../../../data/local/app_database.dart';
import '../../logic/incidents_controller.dart';
import '../../logic/acta_generator.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _observacionesController = TextEditingController();

  bool _isLoading = false;

  // --- ESTADO DE SELECCIÓN ---
  List<Actividade> _actividadesPasadas = [];
  List<Funcionario> _participantes = [];

  int? _selectedActividadId;
  int? _selectedInasistenteId;
  int? _selectedTestigo1Id;
  int? _selectedTestigo2Id;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarActividades();
    });
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  // --- CARGA DE DATOS ---

  Future<void> _cargarActividades() async {
    setState(() => _isLoading = true);
    try {
      final ctrl = context.read<IncidentsController>();
      final lista = await ctrl.obtenerActividadesPasadas();
      setState(() {
        _actividadesPasadas = lista;
      });
    } catch (e) {
      _showError("Error cargando actividades: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cargarParticipantes(int actividadId) async {
    setState(() => _isLoading = true);
    try {
      final ctrl = context.read<IncidentsController>();
      final lista = await ctrl.obtenerParticipantes(actividadId);
      setState(() {
        _participantes = lista;
        // Reset selecciones al cambiar actividad
        _selectedInasistenteId = null;
        _selectedTestigo1Id = null;
        _selectedTestigo2Id = null;
      });
    } catch (e) {
      _showError("Error cargando personal: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- ACCIONES ---

  Future<void> _generarActa() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedInasistenteId == null) {
      _showError("Debe seleccionar al funcionario inasistente.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final ctrl = context.read<IncidentsController>();

      // 1. Guardar en Base de Datos (Genera ID de incidencia y Redacción Automática)
      final incidenciaId = await ctrl.registrarInasistencia(
        actividadId: _selectedActividadId!,
        funcionarioId: _selectedInasistenteId!,
        testigo1Id: _selectedTestigo1Id,
        testigo2Id: _selectedTestigo2Id,
        observaciones: _observacionesController.text,
      );

      // 2. Preparar Datos Completos (DTO)
      final actaData = await ctrl.prepararDatosActa(incidenciaId);

      // 3. Generar PDF Vectorizado
      final pdfBytes = await ActaGenerator().generate(actaData);

      // 4. Mostrar Vista Previa
      // FIX: Uso correcto de string interpolation y mounted check
      await Printing.layoutPdf(
        onLayout: (format) async => pdfBytes,
        name: 'Acta_Inasistencia_$incidenciaId.pdf',
      );

      if (mounted) {
        Navigator.pop(context); // Volver tras generar solo si sigue montado
      }
    } catch (e) {
      if (mounted) {
        _showError("Error crítico generando acta: $e");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  // --- FILTROS DE CASCADA PARA DROPDOWNS ---

  List<Funcionario> get _listaInasistentes => _participantes;

  List<Funcionario> get _listaTestigos1 {
    if (_selectedInasistenteId == null) return [];
    return _participantes.where((f) => f.id != _selectedInasistenteId).toList();
  }

  List<Funcionario> get _listaTestigos2 {
    if (_selectedInasistenteId == null) return [];
    return _participantes.where((f) {
      return f.id != _selectedInasistenteId && f.id != _selectedTestigo1Id;
    }).toList();
  }

  // --- UI BUILD ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control de Inasistencias"),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: _isLoading && _actividadesPasadas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "PASO 1: Selección de Actividad",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    // FIX: initialValue en vez de value
                    initialValue: _selectedActividadId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Actividades Pasadas",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.history),
                    ),
                    items: _actividadesPasadas.map((a) {
                      final fecha = DateFormat('dd/MM/yyyy').format(a.fecha);
                      return DropdownMenuItem(
                        value: a.id,
                        child: Text("$fecha - ${a.nombreActividad}",
                            overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedActividadId = val);
                        _cargarParticipantes(val);
                      }
                    },
                    validator: (v) => v == null ? "Requerido" : null,
                  ),
                  if (_selectedActividadId != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      "PASO 2: Datos de la Falta",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),

                    // SELECCIÓN DEL INASISTENTE
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Funcionario Ausente (Inasistente):",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            // FIX: initialValue
                            initialValue: _selectedInasistenteId,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            items: _listaInasistentes.map((f) {
                              return DropdownMenuItem(
                                value: f.id,
                                child: Text(
                                    "${f.rango} ${f.nombres} ${f.apellidos}"),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedInasistenteId = val;
                                // Reset testigos si hay conflicto
                                // FIX: Llaves en ifs
                                if (_selectedTestigo1Id == val) {
                                  _selectedTestigo1Id = null;
                                }
                                if (_selectedTestigo2Id == val) {
                                  _selectedTestigo2Id = null;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      "PASO 3: Testigos (Para firma del Acta)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            // FIX: initialValue
                            initialValue: _selectedTestigo1Id,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: "Testigo 1 (Opcional)",
                              border: OutlineInputBorder(),
                            ),
                            items: _listaTestigos1.map((f) {
                              return DropdownMenuItem(
                                value: f.id,
                                child: Text("${f.nombres} ${f.apellidos}",
                                    overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedTestigo1Id = val;
                                // FIX: Llaves en if
                                if (_selectedTestigo2Id == val) {
                                  _selectedTestigo2Id = null;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            // FIX: initialValue
                            initialValue: _selectedTestigo2Id,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: "Testigo 2 (Opcional)",
                              border: OutlineInputBorder(),
                            ),
                            items: _listaTestigos2.map((f) {
                              return DropdownMenuItem(
                                value: f.id,
                                child: Text("${f.nombres} ${f.apellidos}",
                                    overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => _selectedTestigo2Id = val),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _observacionesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Observaciones Adicionales (Opcional)",
                        border: OutlineInputBorder(),
                        hintText:
                            "Ej: Presentó justificativo médico posterior...",
                      ),
                    ),

                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade800,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isLoading ? null : _generarActa,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            : const Icon(Icons.gavel),
                        label: const Text("GENERAR ACTA ADMINISTRATIVA"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
```

## File: lib/src/features/personal/logic/personal_controller.dart
```dart
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/local/app_database.dart';

class PersonalController extends ChangeNotifier {
  final AppDatabase _db;

  PersonalController(this._db);

  // ==========================================================
  // 1. LECTURA (READ)
  // ==========================================================

  // Listar todos los funcionarios activos
  Future<List<Funcionario>> listarPersonal() {
    return (_db.select(_db.funcionarios)
          ..where((t) => t.estaActivo.equals(true)))
        .get();
  }

  // Obtener expediente completo (Funcionario + Relaciones)
  Future<Map<String, dynamic>> obtenerExpedienteCompleto(int id) async {
    final funcionario = await (_db.select(_db.funcionarios)
          ..where((t) => t.id.equals(id)))
        .getSingle();

    final estudios = await (_db.select(_db.estudiosAcademicos)
          ..where((t) => t.funcionarioId.equals(id)))
        .get();

    final cursos = await (_db.select(_db.cursosCertificados)
          ..where((t) => t.funcionarioId.equals(id)))
        .get();

    final familiares = await (_db.select(_db.familiares)
          ..where((t) => t.funcionarioId.equals(id)))
        .get();

    final hijos = await (_db.select(_db.hijos)
          ..where((t) => t.funcionarioId.equals(id)))
        .get();

    return {
      'funcionario': funcionario,
      'estudios': estudios,
      'cursos': cursos,
      'familiares': familiares,
      'hijos': hijos,
    };
  }

  // ==========================================================
  // 2. CREACIÓN (CREATE)
  // ==========================================================

  Future<void> registrarFuncionarioCompleto({
    required String nombres,
    required String apellidos,
    required String cedula,
    // CAMBIO: Ahora son opcionales (nullable)
    String? rango,
    int? rangoId,
    DateTime? fechaNacimiento,
    DateTime? fechaIngreso,
    String? telefono,
    String? diasLibresPreferidos,
    String? fotoPath,
    required List<Map<String, dynamic>> estudios,
    required List<dynamic> cursos,
    required List<dynamic> familiares,
    required List<dynamic> hijos,
  }) async {
    await _db.transaction(() async {
      // 1. Insertar Funcionario
      final funcionarioId = await _db.into(_db.funcionarios).insert(
            FuncionariosCompanion(
              nombres: drift.Value(nombres),
              apellidos: drift.Value(apellidos),
              cedula: drift.Value(cedula),
              rango: drift.Value(rango),
              rangoId: drift.Value(rangoId),
              fechaNacimiento: drift.Value(fechaNacimiento),
              fechaIngreso: drift.Value(fechaIngreso),
              telefono: drift.Value(telefono),
              diasLibresPreferidos: drift.Value(diasLibresPreferidos),
              fotoPath: drift.Value(fotoPath),
              estaActivo: const drift.Value(true),
            ),
          );

      // 2. Insertar Relaciones (Lógica privada para reutilizar código)
      await _insertarRelaciones(
          funcionarioId, estudios, cursos, familiares, hijos);
    });
    notifyListeners();
  }

  // ==========================================================
  // 3. ACTUALIZACIÓN (UPDATE) - IMPLEMENTACIÓN ROBUSTA
  // ==========================================================

  Future<void> actualizarFuncionarioCompleto({
    required int id,
    required String nombres,
    required String apellidos,
    required String cedula,
    // CAMBIO: Ahora son opcionales (nullable)
    String? rango,
    int? rangoId,
    DateTime? fechaNacimiento,
    DateTime? fechaIngreso,
    String? telefono,
    int? diasLaboralesSemanales,
    String? diasLibresPreferidos,
    String? fotoPath,
    required List<Map<String, dynamic>> estudios,
    required List<Map<String, dynamic>> cursos,
    required List<Map<String, dynamic>> familiares,
    required List<Map<String, dynamic>> hijos,
  }) async {
    await _db.transaction(() async {
      // 1. Actualizar Datos Básicos
      await (_db.update(_db.funcionarios)..where((t) => t.id.equals(id))).write(
        FuncionariosCompanion(
          nombres: drift.Value(nombres),
          apellidos: drift.Value(apellidos),
          cedula: drift.Value(cedula),
          rango: drift.Value(rango),
          rangoId: drift.Value(rangoId),
          fechaNacimiento: drift.Value(fechaNacimiento),
          fechaIngreso: drift.Value(fechaIngreso),
          telefono: drift.Value(telefono),
          diasLaboralesSemanales: drift.Value(diasLaboralesSemanales ?? 4),
          diasLibresPreferidos: drift.Value(diasLibresPreferidos),
          fotoPath: drift.Value(fotoPath),
        ),
      );

      // 2. ESTRATEGIA DELETE & REPLACE
      await (_db.delete(_db.estudiosAcademicos)
            ..where((t) => t.funcionarioId.equals(id)))
          .go();
      await (_db.delete(_db.cursosCertificados)
            ..where((t) => t.funcionarioId.equals(id)))
          .go();
      await (_db.delete(_db.familiares)
            ..where((t) => t.funcionarioId.equals(id)))
          .go();
      await (_db.delete(_db.hijos)..where((t) => t.funcionarioId.equals(id)))
          .go();

      // 3. Insertamos los nuevos registros
      await _insertarRelaciones(id, estudios, cursos, familiares, hijos);
    });
    notifyListeners();
  }

  // ==========================================================
  // LÓGICA PRIVADA DE INSERCIÓN (DRY)
  // ==========================================================

  Future<void> _insertarRelaciones(
    int funcionarioId,
    List<dynamic> estudios,
    List<dynamic> cursos,
    List<dynamic> familiares,
    List<dynamic> hijos,
  ) async {
    // A. Estudios
    for (var item in estudios) {
      if (item['titulo'] != null && item['titulo'].toString().isNotEmpty) {
        await _db.into(_db.estudiosAcademicos).insert(
              EstudiosAcademicosCompanion(
                funcionarioId: drift.Value(funcionarioId),
                gradoInstruccion: const drift.Value("N/A"),
                tituloObtenido: drift.Value(item['titulo']),
                rutaPdfTitulo: drift.Value(item['path']),
              ),
            );
      }
    }

    // B. Cursos
    for (var item in cursos) {
      if (item['nombre'] != null && item['nombre'].toString().isNotEmpty) {
        await _db.into(_db.cursosCertificados).insert(
              CursosCertificadosCompanion(
                funcionarioId: drift.Value(funcionarioId),
                nombreCertificado: drift.Value(item['nombre']),
                rutaPdfCertificado: drift.Value(item['path']),
              ),
            );
      }
    }

    // C. Familiares
    for (var item in familiares) {
      if (item['nombres'] != null && item['nombres'].toString().isNotEmpty) {
        await _db.into(_db.familiares).insert(
              FamiliaresCompanion(
                funcionarioId: drift.Value(funcionarioId),
                nombres: drift.Value(item['nombres']),
                apellidos: drift.Value(item['apellidos'] ?? ''),
                cedula: drift.Value(item['cedula'] ?? 'S/C'),
                edad: drift.Value(int.tryParse(item['edad'].toString()) ?? 0),
                parentesco: drift.Value(item['parentesco'] ?? 'Familiar'),
                telefono: drift.Value(item['telefono']),
              ),
            );
      }
    }

    // D. Hijos
    for (var item in hijos) {
      if (item['nombres'] != null && item['nombres'].toString().isNotEmpty) {
        await _db.into(_db.hijos).insert(
              HijosCompanion(
                funcionarioId: drift.Value(funcionarioId),
                nombres: drift.Value(item['nombres']),
                apellidos: drift.Value(item['apellidos'] ?? ''),
                edad: drift.Value(int.tryParse(item['edad'].toString()) ?? 0),
              ),
            );
      }
    }
  }

  // ==========================================================
  // 4. BORRADO (DELETE)
  // ==========================================================

  Future<void> desactivarFuncionario(int id) async {
    await (_db.update(_db.funcionarios)..where((t) => t.id.equals(id))).write(
      const FuncionariosCompanion(estaActivo: drift.Value(false)),
    );
    notifyListeners();
  }

  Future<void> abrirDocumento(String? path) async {
    if (path == null || path.isEmpty) return;
    debugPrint("INTENTO DE ABRIR DOCUMENTO: $path");
  }
}
```

## File: lib/src/features/personal/presentation/screens/funcionario_edit_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../data/local/app_database.dart';
import '../../logic/personal_controller.dart';

class FuncionarioEditScreen extends StatefulWidget {
  final Map<String, dynamic> dataInicial;

  const FuncionarioEditScreen({super.key, required this.dataInicial});

  @override
  State<FuncionarioEditScreen> createState() => _FuncionarioEditScreenState();
}

class _FuncionarioEditScreenState extends State<FuncionarioEditScreen> {
  late PersonalController _controller;
  final _formKey = GlobalKey<FormState>();

  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _telefonoController = TextEditingController();

  String? _rangoSeleccionado;

  // CAMBIO: Ahora son nulables
  DateTime? _fechaNacimiento;
  DateTime? _fechaIngreso;

  List<Map<String, dynamic>> _estudios = [];
  List<Map<String, dynamic>> _cursos = [];
  List<Map<String, dynamic>> _familiares = [];
  List<Map<String, dynamic>> _hijos = [];

  @override
  void initState() {
    super.initState();
    _controller = context.read<PersonalController>();
    _cargarDatos();
  }

  void _cargarDatos() {
    final f = widget.dataInicial['funcionario'] as Funcionario;
    _nombresController.text = f.nombres;
    _apellidosController.text = f.apellidos;
    _cedulaController.text = f.cedula;
    _telefonoController.text = f.telefono ?? '';

    // Manejo de nulos en la carga
    _rangoSeleccionado = f.rango ?? 'GP/.';
    _fechaNacimiento = f.fechaNacimiento;
    _fechaIngreso = f.fechaIngreso;

    // 1. Estudios
    _estudios = (widget.dataInicial['estudios'] as List<EstudiosAcademico>)
        .map((e) => {
              'grado': e.gradoInstruccion,
              'titulo': e.tituloObtenido,
              'path': e.rutaPdfTitulo
            })
        .toList();

    // 2. Cursos
    _cursos = (widget.dataInicial['cursos'] as List<CursosCertificado>)
        .map((c) =>
            {'nombre': c.nombreCertificado, 'path': c.rutaPdfCertificado})
        .toList();

    // 3. Familiares
    _familiares = (widget.dataInicial['familiares'] as List<Familiare>)
        .map((fam) => {
              'nombres': fam.nombres,
              'apellidos': fam.apellidos,
              'cedula': fam.cedula,
              'edad': fam.edad.toString(),
              'parentesco': fam.parentesco,
              'telefono': fam.telefono
            })
        .toList();

    // 4. Hijos
    _hijos = (widget.dataInicial['hijos'] as List<Hijo>)
        .map((h) => {
              'nombres': h.nombres,
              'apellidos': h.apellidos,
              'edad': h.edad.toString()
            })
        .toList();
  }

  Future<void> _seleccionarArchivo(Map<String, dynamic> item) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        item['path'] = result.files.single.path;
      });
    }
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      try {
        final f = widget.dataInicial['funcionario'] as Funcionario;
        await _controller.actualizarFuncionarioCompleto(
          id: f.id,
          nombres: _nombresController.text,
          apellidos: _apellidosController.text,
          cedula: _cedulaController.text,
          rango: _rangoSeleccionado,
          rangoId: f.rangoId,
          fechaNacimiento: _fechaNacimiento,
          fechaIngreso: _fechaIngreso,
          telefono: _telefonoController.text,
          diasLaboralesSemanales: f.diasLaboralesSemanales,
          diasLibresPreferidos: f.diasLibresPreferidos,
          fotoPath: f.fotoPath,
          estudios: _estudios,
          cursos: _cursos,
          familiares: _familiares,
          hijos: _hijos,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Expediente actualizado exitosamente"),
            backgroundColor: Colors.green));
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error al guardar: $e"),
            backgroundColor: Colors.red));
      }
    }
  }

  // --- WIDGETS DE UI ---

  // Widget para seleccionar fecha que soporta nulos
  Widget _buildDatePicker(
      String label, DateTime? fecha, Function(DateTime) onSelect) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: fecha ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) onSelect(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          fecha != null
              ? DateFormat('dd/MM/yyyy').format(fecha)
              : 'Sin definir',
          style: TextStyle(color: fecha != null ? Colors.black : Colors.grey),
        ),
      ),
    );
  }

  Widget _buildFileStatus(Map<String, dynamic> item) {
    bool hasFile = item['path'] != null;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(hasFile ? Icons.picture_as_pdf : Icons.picture_as_pdf_outlined,
              color: hasFile ? Colors.red : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
              child: Text(hasFile ? "Documento Adjunto" : "Sin Documento",
                  style: const TextStyle(fontSize: 12))),
          if (hasFile)
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue),
              onPressed: () => _controller.abrirDocumento(item['path']),
              tooltip: "Ver",
            ),
          TextButton(
            onPressed: () => _seleccionarArchivo(item),
            child: Text(hasFile ? "Cambiar" : "Subir"),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactField(Map<String, dynamic> item, String key, String label,
      {bool isNumber = false}) {
    return TextFormField(
      initialValue: item[key],
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: const OutlineInputBorder(),
      ),
      style: const TextStyle(fontSize: 13),
      onChanged: (v) => item[key] = v,
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
          IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: onAdd),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Expediente"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: _guardarCambios,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text("GUARDAR", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text("DATOS BÁSICOS",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green)),
            const Divider(),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                        controller: _nombresController,
                        decoration: const InputDecoration(
                            labelText: "Nombres",
                            border: OutlineInputBorder()))),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                        controller: _apellidosController,
                        decoration: const InputDecoration(
                            labelText: "Apellidos",
                            border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                        controller: _cedulaController,
                        decoration: const InputDecoration(
                            labelText: "Cédula",
                            border: OutlineInputBorder()))),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                        controller: _telefonoController,
                        decoration: const InputDecoration(
                            labelText: "Teléfono",
                            border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),

            // CAMBIO: Selectores de fecha ajustados para nulos
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker("Fecha Nacimiento", _fechaNacimiento,
                      (d) => setState(() => _fechaNacimiento = d)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDatePicker("Fecha Ingreso", _fechaIngreso,
                      (d) => setState(() => _fechaIngreso = d)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // FORMACIÓN
            _buildSectionHeader(
                "ESTUDIOS",
                () => setState(
                    () => _estudios.add({'titulo': '', 'path': null}))),
            ..._estudios.map((item) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: item['titulo'],
                          decoration: const InputDecoration(
                              labelText: "Título Obtenido"),
                          onChanged: (v) => item['titulo'] = v,
                        ),
                        _buildFileStatus(item),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: const Text("Eliminar",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () =>
                                setState(() => _estudios.remove(item)),
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            _buildSectionHeader(
                "CURSOS",
                () =>
                    setState(() => _cursos.add({'nombre': '', 'path': null}))),
            ..._cursos.map((item) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: item['nombre'],
                          decoration: const InputDecoration(
                              labelText: "Nombre del Curso"),
                          onChanged: (v) => item['nombre'] = v,
                        ),
                        _buildFileStatus(item),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: const Text("Eliminar",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () =>
                                setState(() => _cursos.remove(item)),
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            // FAMILIARES
            _buildSectionHeader(
                "CARGA FAMILIAR",
                () => setState(() => _familiares.add({
                      'nombres': '',
                      'apellidos': '',
                      'cedula': '',
                      'edad': '',
                      'parentesco': 'Cónyuge'
                    }))),
            ..._familiares.map((item) => Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(
                              child: _buildCompactField(
                                  item, 'nombres', "Nombres")),
                          const SizedBox(width: 5),
                          Expanded(
                              child: _buildCompactField(
                                  item, 'apellidos', "Apellidos")),
                        ]),
                        const SizedBox(height: 5),
                        Row(children: [
                          Expanded(
                              child:
                                  _buildCompactField(item, 'cedula', "Cédula")),
                          const SizedBox(width: 5),
                          Expanded(
                              child: _buildCompactField(item, 'edad', "Edad",
                                  isNumber: true)),
                        ]),
                        const SizedBox(height: 5),
                        _buildCompactField(
                            item, 'parentesco', "Parentesco (Ej: Esposa)"),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: const Text("Eliminar",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () =>
                                setState(() => _familiares.remove(item)),
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            // HIJOS
            _buildSectionHeader(
                "HIJOS",
                () => setState(() =>
                    _hijos.add({'nombres': '', 'apellidos': '', 'edad': ''}))),
            ..._hijos.map((item) => Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(
                              child: _buildCompactField(
                                  item, 'nombres', "Nombres")),
                          const SizedBox(width: 5),
                          Expanded(
                              child: _buildCompactField(
                                  item, 'apellidos', "Apellidos")),
                        ]),
                        const SizedBox(height: 5),
                        Row(children: [
                          Expanded(
                              child: _buildCompactField(item, 'edad', "Edad",
                                  isNumber: true)),
                          const Spacer(),
                          TextButton(
                            child: const Text("Eliminar",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () =>
                                setState(() => _hijos.remove(item)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
```

## File: lib/src/features/personal/presentation/screens/funcionario_profile_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/personal_controller.dart';
import '../../../../data/local/app_database.dart';

class FuncionarioProfileScreen extends StatefulWidget {
  final int funcionarioId;

  const FuncionarioProfileScreen({super.key, required this.funcionarioId});

  @override
  State<FuncionarioProfileScreen> createState() =>
      _FuncionarioProfileScreenState();
}

class _FuncionarioProfileScreenState extends State<FuncionarioProfileScreen> {
  late Future<Map<String, dynamic>> _expedienteFuture;

  @override
  void initState() {
    super.initState();
    _cargarExpediente();
  }

  void _cargarExpediente() {
    _expedienteFuture = context
        .read<PersonalController>()
        .obtenerExpedienteCompleto(widget.funcionarioId);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<PersonalController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil del Funcionario"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _expedienteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error al cargar el expediente"));
          }

          final data = snapshot.data!;
          final Funcionario f = data['funcionario'];
          final List<EstudiosAcademico> estudios = data['estudios'];
          final List<CursosCertificado> cursos = data['cursos'];

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildHeader(f),
              const SizedBox(height: 24),
              _buildSectionTitle("Formación Académica"),
              if (estudios.isEmpty)
                const Text("No registra títulos cargados",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ...estudios.map((e) => _buildDocTile(
                    title: e.tituloObtenido,
                    subtitle: e.gradoInstruccion,
                    path: e.rutaPdfTitulo,
                    onOpen: () => controller.abrirDocumento(e.rutaPdfTitulo),
                  )),
              const SizedBox(height: 24),
              _buildSectionTitle("Cursos y Certificaciones"),
              if (cursos.isEmpty)
                const Text("No registra certificados cargados",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ...cursos.map((c) => _buildDocTile(
                    title: c.nombreCertificado,
                    subtitle: "Certificado de Formación",
                    path: c.rutaPdfCertificado,
                    onOpen: () =>
                        controller.abrirDocumento(c.rutaPdfCertificado),
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(Funcionario f) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green.shade100,
              child: const Icon(Icons.person, size: 50, color: Colors.green),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${f.nombres} ${f.apellidos}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("C.I: ${f.cedula}",
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // FIX: Manejo de nulo en visualización de Rango
                    child: Text(f.rango ?? "Sin Rango",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget _buildDocTile(
      {required String title,
      required String subtitle,
      String? path,
      required VoidCallback onOpen}) {
    final bool hasFile = path != null && path.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.picture_as_pdf,
            color: hasFile ? Colors.red : Colors.grey),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: hasFile
            ? IconButton(
                icon: const Icon(Icons.open_in_new, color: Colors.blue),
                onPressed: onOpen,
                tooltip: "Ver Documento",
              )
            : const Icon(Icons.help_outline, color: Colors.grey),
      ),
    );
  }
}
```

## File: lib/src/features/personal/presentation/screens/funcionario_registration_screen.dart
```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/local/app_database.dart';
import '../../logic/personal_controller.dart';

class FuncionarioRegistrationScreen extends StatefulWidget {
  const FuncionarioRegistrationScreen({super.key});

  @override
  State<FuncionarioRegistrationScreen> createState() =>
      _FuncionarioRegistrationScreenState();
}

class _FuncionarioRegistrationScreenState
    extends State<FuncionarioRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _telefonoController = TextEditingController();

  List<Rango> _listaRangosDb = [];
  Rango? _rangoSeleccionadoObj;

  DateTime? _fechaNacimiento;
  DateTime? _fechaIngreso;

  File? _fotoPerfil;
  bool _isSaving = false;
  bool _isLoadingRangos = true;

  final Map<String, bool> _diasPreferencia = {
    'LUN': false,
    'MAR': false,
    'MIER': false,
    'JUE': false,
    'VIE': false,
    'SAB': false,
    'DOM': false,
  };

  final List<Map<String, dynamic>> _estudios = [];
  final List<Map<String, dynamic>> _cursos = [];
  final List<Map<String, dynamic>> _familiares = [];
  final List<Map<String, dynamic>> _hijos = [];

  @override
  void initState() {
    super.initState();
    _cargarRangosDesdeDb();
  }

  Future<void> _cargarRangosDesdeDb() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final List<Rango> rangos = await db.select(db.rangos).get();

    if (mounted) {
      setState(() {
        _listaRangosDb = rangos;
        _isLoadingRangos = false;
      });
    }
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _cedulaController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar Foto'),
              onTap: () async {
                Navigator.pop(ctx);
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null && mounted) {
                  setState(() => _fotoPerfil = File(pickedFile.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () async {
                Navigator.pop(ctx);
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null && mounted) {
                  setState(() => _fotoPerfil = File(pickedFile.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _adjuntarArchivo(Map<String, dynamic> item) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null && mounted) {
      setState(() => item['path'] = result.files.single.path);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final controller = context.read<PersonalController>();

    final diasLibresString = _diasPreferencia.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .join(',');

    try {
      await controller.registrarFuncionarioCompleto(
        nombres: _nombresController.text.trim(),
        apellidos: _apellidosController.text.trim(),
        cedula: _cedulaController.text.trim(),
        rango: _rangoSeleccionadoObj?.nombre,
        rangoId: _rangoSeleccionadoObj?.id,
        fechaNacimiento: _fechaNacimiento,
        fechaIngreso: _fechaIngreso,
        telefono: _telefonoController.text.trim(),
        diasLibresPreferidos: diasLibresString,
        fotoPath: _fotoPerfil?.path,
        estudios: _estudios,
        cursos: _cursos,
        familiares: _familiares,
        hijos: _hijos,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Registrado correctamente"),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Funcionario")),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _seleccionarFoto,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _fotoPerfil != null
                            ? FileImage(_fotoPerfil!)
                            : null,
                        child: _fotoPerfil == null
                            ? const Icon(Icons.add_a_photo,
                                size: 40, color: Colors.grey)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSection("Datos Personales"),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                              controller: _nombresController,
                              decoration: const InputDecoration(
                                  labelText: "Nombres *",
                                  border: OutlineInputBorder()),
                              validator: (v) =>
                                  v!.isEmpty ? "Requerido" : null)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextFormField(
                              controller: _apellidosController,
                              decoration: const InputDecoration(
                                  labelText: "Apellidos *",
                                  border: OutlineInputBorder()),
                              validator: (v) =>
                                  v!.isEmpty ? "Requerido" : null)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: _cedulaController,
                      decoration: const InputDecoration(
                          labelText: "Cédula *",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge)),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? "Requerido" : null),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: _telefonoController,
                      decoration: const InputDecoration(
                          labelText: "Teléfono (Opcional)",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone)),
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 20),
                  _buildSection("Información Laboral (Opcional)"),
                  if (_isLoadingRangos)
                    const LinearProgressIndicator()
                  else
                    DropdownButtonFormField<Rango>(
                      initialValue: _rangoSeleccionadoObj,
                      decoration: const InputDecoration(
                          labelText: "Rango / Jerarquía",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.security)),
                      items: _listaRangosDb
                          .map((r) => DropdownMenuItem(
                              value: r,
                              child: Text(r.nombre,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _rangoSeleccionadoObj = val),
                    ),
                  const SizedBox(height: 15),
                  const Text("Días solicitados libres/estudios:",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Wrap(
                    spacing: 5,
                    children: _diasPreferencia.keys
                        .map((dia) => ChoiceChip(
                              label: Text(dia),
                              selected: _diasPreferencia[dia]!,
                              onSelected: (val) =>
                                  setState(() => _diasPreferencia[dia] = val),
                              selectedColor: Colors.green[200],
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader(
                      "Títulos Académicos",
                      () => setState(
                          () => _estudios.add({'titulo': '', 'path': null}))),
                  ..._estudios.map((item) => _buildSimpleItemCard(
                      item, "Título Obtenido", Icons.school)),
                  const SizedBox(height: 10),
                  _buildSectionHeader(
                      "Cursos y Certificados",
                      () => setState(
                          () => _cursos.add({'nombre': '', 'path': null}))),
                  ..._cursos.map((item) => _buildSimpleItemCard(
                      item, "Nombre del Curso", Icons.workspace_premium)),
                  const SizedBox(height: 20),
                  _buildSectionHeader(
                      "Carga Familiar (Esposa/Padres)",
                      () => setState(() => _familiares.add({
                            'nombres': '',
                            'apellidos': '',
                            'cedula': '',
                            'edad': '',
                            'parentesco': 'Cónyuge',
                            'telefono': ''
                          }))),
                  ..._familiares.map(
                    (item) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: Colors.blue[50],
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Row(children: [
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'nombres', "Nombres")),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'apellidos', "Apellidos"))
                              ]),
                              const SizedBox(height: 5),
                              Row(children: [
                                Expanded(
                                    flex: 2,
                                    child: _buildCompactField(
                                        item, 'cedula', "Cédula")),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'edad', "Edad",
                                        isNumber: true))
                              ]),
                              const SizedBox(height: 5),
                              Row(children: [
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'parentesco', "Parentesco")),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'telefono', "Teléfono",
                                        isNumber: true))
                              ]),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red, size: 16),
                                      label: const Text("Eliminar",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 12)),
                                      onPressed: () => setState(
                                          () => _familiares.remove(item)))),
                            ]))),
                  ),
                  const SizedBox(height: 10),
                  _buildSectionHeader(
                      "Hijos",
                      () => setState(() => _hijos
                          .add({'nombres': '', 'apellidos': '', 'edad': ''}))),
                  ..._hijos.map(
                    (item) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: Colors.orange[50],
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Row(children: [
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'nombres', "Nombres")),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'apellidos', "Apellidos"))
                              ]),
                              const SizedBox(height: 5),
                              Row(children: [
                                Expanded(
                                    child: _buildCompactField(
                                        item, 'edad', "Edad",
                                        isNumber: true)),
                                const Spacer(),
                                IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red, size: 20),
                                    onPressed: () =>
                                        setState(() => _hijos.remove(item)))
                              ])
                            ]))),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                      height: 50,
                      child: FilledButton.icon(
                          onPressed: _guardar,
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.green),
                          icon: const Icon(Icons.save),
                          label: const Text("GUARDAR REGISTRO"))),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(String title) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)));

  Widget _buildSectionHeader(String title, VoidCallback onAdd) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green)),
        IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.green),
            onPressed: onAdd,
            tooltip: "Agregar")
      ]);

  Widget _buildSimpleItemCard(
      Map<String, dynamic> item, String hint, IconData icon) {
    final keyName = item.containsKey('titulo') ? 'titulo' : 'nombre';
    return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
            leading: Icon(icon, color: Colors.grey),
            title: TextFormField(
                initialValue: item[keyName],
                decoration:
                    InputDecoration(hintText: hint, border: InputBorder.none),
                onChanged: (v) => item[keyName] = v),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  icon: Icon(Icons.upload_file,
                      color: item['path'] != null ? Colors.red : Colors.grey),
                  onPressed: () => _adjuntarArchivo(item),
                  tooltip: "Adjuntar PDF"),
              IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () => setState(() => keyName == 'titulo'
                      ? _estudios.remove(item)
                      : _cursos.remove(item)))
            ])));
  }

  Widget _buildCompactField(Map<String, dynamic> item, String key, String label,
          {bool isNumber = false}) =>
      TextFormField(
          initialValue: item[key],
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
              labelText: label,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: const OutlineInputBorder()),
          style: const TextStyle(fontSize: 13),
          onChanged: (v) => item[key] = v);
}
```

## File: lib/src/features/personal/presentation/screens/personal_list_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/personal_controller.dart';
import '../../../../data/local/app_database.dart';
import 'funcionario_registration_screen.dart';
import 'funcionario_profile_screen.dart';
import 'funcionario_edit_screen.dart';

class PersonalListScreen extends StatefulWidget {
  const PersonalListScreen({super.key});

  @override
  State<PersonalListScreen> createState() => _PersonalListScreenState();
}

class _PersonalListScreenState extends State<PersonalListScreen> {
  void _irARegistro() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (context) => const FuncionarioRegistrationScreen()),
    );
    if (result == true && mounted) {
      setState(() {});
    }
  }

  void _editar(PersonalController controller, int id) async {
    final data = await controller.obtenerExpedienteCompleto(id);
    if (!mounted) return;

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (context) => FuncionarioEditScreen(dataInicial: data)),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  void _confirmarBorrado(PersonalController controller, Funcionario f) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar Registro"),
        content: Text("¿Dar de baja a ${f.nombres}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCELAR"),
          ),
          TextButton(
            onPressed: () async {
              // Realizamos la operación lógica
              await controller.desactivarFuncionario(f.id);

              // CORRECCIÓN QUIRÚRGICA:
              // Primero verificamos si el contexto del DIÁLOGO (ctx) sigue montado
              if (!ctx.mounted) return;
              Navigator.pop(ctx);

              // Luego verificamos si el Widget principal sigue montado para refrescar la lista
              if (mounted) {
                setState(() {});
              }
            },
            child: const Text("BORRAR", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PersonalController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Personal")),
      body: FutureBuilder<List<Funcionario>>(
        future: controller.listarPersonal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data ?? [];

          if (lista.isEmpty) {
            return const Center(child: Text("No hay personal registrado"));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final f = lista[i];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text("${f.nombres} ${f.apellidos}"),
                subtitle: Text("C.I: ${f.cedula}"),
                trailing: PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'edit') _editar(controller, f.id);
                    if (val == 'del') _confirmarBorrado(controller, f);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text("Editar")),
                    const PopupMenuItem(
                        value: 'del', child: Text("Dar de baja")),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        FuncionarioProfileScreen(funcionarioId: f.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irARegistro,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
```

## File: lib/src/features/planning/logic/config_types_controller.dart
```dart
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
```

## File: lib/src/features/planning/logic/equity_algorithm.dart
```dart
import 'package:drift/drift.dart';
import '../../../data/local/app_database.dart';

class EquityAlgorithm {
  final AppDatabase db;
  EquityAlgorithm(this.db);

  /// Algoritmo Maestro de Disponibilidad (Soporte Multi-Día)
  /// [isOvernight]: Si es true, activa la lógica de rotación cíclica (D2).
  Future<List<Map<String, dynamic>>> getAvailablePersonnel({
    required DateTime targetDate,
    required String dayName,
    bool isOvernight = false,
  }) async {
    // 1. Obtener UNIVERSO (Solo activos)
    final allPersonnel = await (db.select(
      db.funcionarios,
    )..where((t) => t.estaActivo.equals(true)))
        .get();

    // 2. Clasificación de AUSENCIAS (Vacaciones, Reposos)
    final ausencias = await (db.select(db.ausencias)
          ..where(
            (t) =>
                t.fechaInicio.isSmallerOrEqual(Variable(targetDate)) &
                t.fechaFin.isBiggerOrEqual(Variable(targetDate)),
          ))
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
    // CORRECCIÓN V5: Implementación de JOIN para validación temporal bidireccional.
    // Un bloqueo de descanso solo aplica si:
    // A) El periodo de descanso aun no ha expirado hoy (Límite > TargetDate).
    // B) La guardia que lo generó YA OCURRIÓ (Fin Guardia <= TargetDate).
    // Esto evita que guardias FUTURAS bloqueen fechas PASADAS (Bloqueo Retroactivo).

    final queryBloqueos = db.select(db.asignaciones).join([
      innerJoin(db.actividades,
          db.actividades.id.equalsExp(db.asignaciones.actividadId))
    ]);

    queryBloqueos.where(
        // Condición A: El descanso sigue activo
        db.asignaciones.fechaBloqueoHasta.isBiggerThan(Variable(targetDate)) &
            // Condición B: El origen NO es futuro (usamos coalesce para seguridad)
            coalesce([db.actividades.fechaFin, db.actividades.fecha])
                .isSmallerOrEqual(Variable(targetDate)));

    final bloqueos = await queryBloqueos.get();

    final idsEnDescanso = bloqueos
        .map((row) => row.readTable(db.asignaciones).funcionarioId)
        .toSet();

    // 4. YA ASIGNADO HOY (Bloqueo Físico por Actividad en curso)
    final startOfDay = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    final endOfDay = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      23,
      59,
      59,
    );

    final actividadesActivas = await (db.select(db.actividades)
          ..where((a) {
            // CORRECCIÓN: Usamos coalesce de SQL para manejar nulos
            // Si fechaFin es NULL, toma a.fecha (asume 1 día)
            final finReal = coalesce([a.fechaFin, a.fecha]);

            // La lógica es: La actividad se solapa con HOY si:
            // (Inicio <= FinDia) Y (Fin >= InicioDia)
            return a.fecha.isSmallerOrEqual(Variable(endOfDay)) &
                finReal.isBiggerOrEqual(Variable(startOfDay));
          }))
        .get();

    final idsActividadesActivas = actividadesActivas.map((a) => a.id).toList();

    Set<int> idsOcupadosHoy = {};
    if (idsActividadesActivas.isNotEmpty) {
      final ocupados = await (db.select(
        db.asignaciones,
      )..where((a) => a.actividadId.isIn(idsActividadesActivas)))
          .get();
      idsOcupadosHoy = ocupados.map((o) => o.funcionarioId).toSet();
    }

    // 5. Carga Semanal (Solo relevante para D1, pero se calcula siempre para info)
    final inicioSemana = targetDate.subtract(const Duration(days: 7));
    final asignacionesRecientes = await (db.select(db.asignaciones)
          ..where(
            (t) => t.fechaAsignacion.isBiggerOrEqual(Variable(inicioSemana)),
          ))
        .get();
    final Map<int, int> cargaLaboral = {};
    for (var a in asignacionesRecientes) {
      cargaLaboral[a.funcionarioId] = (cargaLaboral[a.funcionarioId] ?? 0) + 1;
    }

    List<Map<String, dynamic>> availableList = [];

    // 6. PROCESAMIENTO
    for (var f in allPersonnel) {
      // Filtros de exclusión absolutos
      if (idsReposoMedico.contains(f.id)) continue;
      if (idsOcupadosHoy.contains(f.id)) continue;

      int severity = 0;
      String statusText = "Disponible";

      // Filtros de severidad (Estado visual)
      if (idsVacaciones.contains(f.id)) {
        severity = 2; // Rojo
        statusText = "VACACIONES";
      } else if (idsEnDescanso.contains(f.id)) {
        severity = 2; // Rojo
        statusText = "POST-GUARDIA";
      } else {
        // Validación de preferencias (Solo afecta D1 usualmente)
        final preferencias = f.diasLibresPreferidos ?? '';
        if (preferencias.contains(dayName)) {
          severity = 1; // Amarillo
          statusText = "ESTUDIO/PREFERENCIA";
        }
      }

      availableList.add({
        'funcionario': f,
        'cargaSemanal': cargaLaboral[f.id] ?? 0,
        'saldo': f.saldoCompensacion,
        'severity': severity,
        'statusText': statusText,
        // Agregamos fecha última pernocta para el sort D2
        'ultimaPernocta': f.ultimaFechaPernocta,
      });
    }

    // 7. ORDENAMIENTO INTELIGENTE (El Núcleo del Módulo D)
    availableList.sort((a, b) {
      // Regla 0: Disponibilidad (Rojos al final siempre)
      final int sevA = a['severity'];
      final int sevB = b['severity'];
      if (sevA != sevB) return sevA.compareTo(sevB); // Menor severidad primero

      if (isOvernight) {
        // --- LÓGICA D2: ROTACIÓN CÍCLICA ---
        // Prioridad: Quien NUNCA ha hecho pernocta (null) va primero.
        // Luego: Quien tiene la fecha más antigua va primero.
        final DateTime? dateA = a['ultimaPernocta'];
        final DateTime? dateB = b['ultimaPernocta'];

        if (dateA == null && dateB == null) {
          // Si ninguno ha hecho, desempate por carga semanal (el que menos ha trabajado)
          return (a['cargaSemanal'] as int).compareTo(b['cargaSemanal'] as int);
        }
        if (dateA == null) return -1; // A es prioritario
        if (dateB == null) return 1; // B es prioritario

        // Ordenar por fecha: La fecha más vieja (menor) va primero
        return dateA.compareTo(dateB);
      } else {
        // --- LÓGICA D1: EQUIDAD SEMANAL ---
        // Prioridad: Quien tenga menos carga esta semana.
        final int cargaA = a['cargaSemanal'];
        final int cargaB = b['cargaSemanal'];
        if (cargaA != cargaB) return cargaA.compareTo(cargaB);

        // Desempate: Saldo de compensación (quien tenga más días a favor, descansa más, so prioridad baja?)
        // Normalmente queremos asignar al que tiene saldo 0 o negativo primero.
        // Aquí ordenamos: Mayor saldo -> Al final.
        return (b['saldo'] as int).compareTo(a['saldo'] as int);
      }
    });

    return availableList;
  }
}
```

## File: lib/src/features/planning/logic/planning_controller.dart
```dart
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

  // --- MEMORIA DEL CALENDARIO ---
  DateTime _focusedDay = DateTime.now();

  PlanningController(this.db) {
    _algorithm = EquityAlgorithm(db);
  }

  EquityAlgorithm get algorithm => _algorithm;

  // --- GETTERS Y SETTERS DE MEMORIA ---
  DateTime get focusedDay => _focusedDay;

  void setFocusedDay(DateTime date) {
    _focusedDay = date;
    notifyListeners();
  }

  // ==========================================================
  // 1. MÉTODOS DE CONSULTA (READ)
  // ==========================================================

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
  }) async {
    final targetDate = fecha ?? DateTime.now();

    final List<Map<String, dynamic>> personalBase =
        await _algorithm.getAvailablePersonnel(
      targetDate: targetDate,
      dayName: _getDayName(targetDate),
      isOvernight: esPernocta,
    );

    if (esPernocta) {
      personalBase.sort((a, b) {
        final fA = a['funcionario'] as Funcionario;
        final fB = b['funcionario'] as Funcionario;

        if (fA.ultimaFechaPernocta == null && fB.ultimaFechaPernocta != null) {
          return -1;
        }
        if (fA.ultimaFechaPernocta != null && fB.ultimaFechaPernocta == null) {
          return 1;
        }
        if (fA.ultimaFechaPernocta == null && fB.ultimaFechaPernocta == null) {
          return 0;
        }
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
          ..where(db.actividades.fecha.isBiggerOrEqual(Variable(inicioSemana)) &
              db.actividades.fecha.isSmallerOrEqual(Variable(finSemana))))
        .get();

    List<Map<String, dynamic>> personalEnriquecido = [];
    final targetYMD =
        DateTime(targetDate.year, targetDate.month, targetDate.day);

    for (var item in personalBase) {
      final f = item['funcionario'] as Funcionario;

      int conteoSemana = 0;
      bool trabajaHoy = false;

      for (var row in asignacionesSemana) {
        if (row.readTable(db.asignaciones).funcionarioId == f.id) {
          conteoSemana++;
          final act = row.readTable(db.actividades);
          final actDate =
              DateTime(act.fecha.year, act.fecha.month, act.fecha.day);

          if (actDate.isAtSameMomentAs(targetYMD)) {
            trabajaHoy = true;
          }
        }
      }

      final cupoMaximo = cupoOverride ?? f.diasLaboralesSemanales;
      final bool cupoLleno = conteoSemana >= cupoMaximo;

      Map<String, dynamic> newItem = Map.from(item);
      newItem['conteoSemana'] = conteoSemana;
      newItem['cupoMaximo'] = cupoMaximo;
      newItem['cupoLleno'] = cupoLleno;

      if (trabajaHoy) {
        newItem['severity'] = 2;
        newItem['statusText'] = "YA ASIGNADO HOY";
      } else if (cupoLleno) {
        newItem['severity'] = 2;
        newItem['statusText'] = "CUPO CUMPLIDO ($conteoSemana/$cupoMaximo)";
      } else {
        newItem['statusText'] =
            "${item['statusText']} • Carga: $conteoSemana/$cupoMaximo";
      }

      personalEnriquecido.add(newItem);
    }

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

  // --- MÉTODOS DE EDICIÓN ---
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
          orElse: () => rows.first // Fallback para evitar crash
          );
      // Validamos si realmente encontramos uno con el flag, si no usamos el fallback
      if (jefeRow.readTable(db.asignaciones).esJefeServicio) {
        jefe = jefeRow.readTable(db.funcionarios);
      } else if (act.jefeServicioId != null) {
        // Si no hay flag, buscamos por ID guardado en actividad
        jefe = await (db.select(db.funcionarios)
              ..where((f) => f.id.equals(act.jefeServicioId!)))
            .getSingleOrNull();
      }
    } catch (e) {
      // Fallback final
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

  // ==========================================================
  // 2. MÉTODOS DE ESCRITURA (WRITE) - CON ACTUALIZACIÓN DE MEMORIA
  // ==========================================================

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
        final funcionario = await (db.select(
          db.funcionarios,
        )..where((t) => t.id.equals(fId)))
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
          await (db.update(
            db.funcionarios,
          )..where((t) => t.id.equals(fId)))
              .write(
            FuncionariosCompanion(
              saldoCompensacion: Value(funcionario.saldoCompensacion + 1),
            ),
          );
        }
      }
    });

    // Actualizamos memoria a la fecha de la actividad
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
        // FIX: Se explicita planificacionId como null si no se usa
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
              saldoCompensacion: Value(funcionario.saldoCompensacion + 1),
            );
            needsUpdate = true;
          }

          if (esPernocta) {
            updateCompanion = updateCompanion.copyWith(
              ultimaFechaPernocta: Value(fechaFin),
            );
            needsUpdate = true;
          }

          if (needsUpdate) {
            await (db.update(db.funcionarios)..where((t) => t.id.equals(fId)))
                .write(updateCompanion);
          }
        }
      });

      // MEMORIA: Fijamos el foco en la fecha de la guardia creada
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
        // 1. Revertir saldos
        await _revertirSaldosEliminacion(actividadIdOriginal);

        // 2. Limpiar viejo
        await (db.delete(db.asignaciones)
              ..where((t) => t.actividadId.equals(actividadIdOriginal)))
            .go();
        await (db.delete(db.actividades)
              ..where((t) => t.id.equals(actividadIdOriginal)))
            .go();

        // 3. Insertar nuevo
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

      // MEMORIA: Foco en la fecha editada
      _focusedDay = fechaInicio;
      notifyListeners();
    } catch (e) {
      debugPrint("ERROR CRÍTICO EN EDICIÓN: $e");
      rethrow;
    }
  }

  // ==========================================================
  // 3. REPORTES Y LEGADO
  // ==========================================================

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
      // 1. RECUPERACIÓN ROBUSTA DEL TIPO DE GUARDIA (CATÁLOGO)
      String tipo = "[SIN TIPO]";
      if (act.tipoGuardiaId != null) {
        final t = await (db.select(db.tiposGuardia)
              ..where((tbl) => tbl.id.equals(act.tipoGuardiaId!)))
            .getSingleOrNull();
        if (t != null) {
          tipo = t.nombre;
        } else {
          print(
              "DEBUG REPORT: ID Tipo ${act.tipoGuardiaId} no encontrado en BD.");
        }
      } else {
        print("DEBUG REPORT: Actividad ${act.id} tiene tipoGuardiaId NULL.");
      }

      // 2. RECUPERACIÓN DEL PERSONAL Y JEFE
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
        // Buscamos primero por el flag en Asignaciones
        final candidatosJefe = rows
            .where((r) => r.readTable(db.asignaciones).esJefeServicio == true);

        if (candidatosJefe.isNotEmpty) {
          jefe = candidatosJefe.first.readTable(db.funcionarios);
        } else {
          // Si no hay flag, buscamos por el ID guardado en la tabla Actividades
          if (act.jefeServicioId != null) {
            jefe = await (db.select(db.funcionarios)
                  ..where((f) => f.id.equals(act.jefeServicioId!)))
                .getSingleOrNull();
          }
        }
      } catch (e) {
        print("DEBUG REPORT ERROR JEFE: $e");
      }

      reporteItems.add(ReporteDataDTO(
        actividad: act,
        tipoNombre: tipo,
        funcionarios: personal,
        jefeServicio: jefe,
      ));
    }

    return {
      'config': config,
      'items': reporteItems,
    };
  }

  Future<List<ReporteDataDTO>> listarHistorial(
      {required bool esPernocta}) async {
    final actividades = await (db.select(db.actividades)
          ..where((a) => a.esPernocta.equals(esPernocta))
          ..orderBy([(a) => OrderingTerm.desc(a.fecha)]))
        .get();

    List<ReporteDataDTO> items = [];

    for (var act in actividades) {
      // Búsqueda robusta del tipo también para el historial
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
      } catch (e) {
        // Silencio en UI
      }

      items.add(ReporteDataDTO(
        actividad: act,
        tipoNombre: tipo,
        funcionarios: personal,
        jefeServicio: jefe,
      ));
    }

    return items;
  }

  // --- LISTAR INCIDENCIAS ---
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

  // --- OBTENER DATOS PARA ACTA ---
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

    // Obtener testigos si existen
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

    // Buscamos el jefe de servicio de la actividad
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
      'jefeServicio': jefeServicio,
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
      7: 'DOM',
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
      } catch (e) {
        // Silencio en UI
      }

      reporteItems.add(ReporteDataDTO(
        actividad: act,
        tipoNombre: tipo,
        funcionarios: personal,
        jefeServicio: jefe,
      ));
    }

    return {
      'config': config,
      'items': reporteItems,
    };
  }
}
```

## File: lib/src/features/planning/presentation/screens/actividad_form_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../data/local/app_database.dart';
import '../../logic/planning_controller.dart';
import '../../../dashboard/logic/dashboard_controller.dart';

class ActividadFormScreen extends StatefulWidget {
  const ActividadFormScreen({super.key});

  @override
  State<ActividadFormScreen> createState() => _ActividadFormScreenState();
}

class _ActividadFormScreenState extends State<ActividadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  final List<String> _puestos = [
    'Puesto de Control Loma del Viento',
    'Puesto de Control Estribo de Hierro',
    'Puesto de Control Los Venados',
    'Puesto de Control Galipán',
    'Sede Administrativa',
  ];

  String? _puestoSeleccionado;
  DateTime _fechaInicio = DateTime.now();

  bool _esPernocta = false;
  int _duracionDias = 7;
  int _factorCompensacion = 2;

  List<Map<String, dynamic>> _personalData = [];
  final List<int> _seleccionadosIds = [];
  bool _cargandoPersonal = true;

  @override
  void initState() {
    super.initState();
    _puestoSeleccionado = _puestos.first;
    WidgetsBinding.instance.addPostFrameCallback((_) => _obtenerDisponibles());
  }

  DateTime get _fechaFinGuardia {
    if (!_esPernocta) return _fechaInicio;
    return _fechaInicio.add(Duration(days: _duracionDias - 1));
  }

  DateTime? get _fechaDesbloqueo {
    if (!_esPernocta) return null;
    final diasLibres = _duracionDias * _factorCompensacion;
    return _fechaFinGuardia.add(Duration(days: diasLibres));
  }

  Future<void> _obtenerDisponibles() async {
    setState(() => _cargandoPersonal = true);

    final data = await context
        .read<PlanningController>()
        .obtenerPersonalConMetadata(fecha: _fechaInicio);

    if (mounted) {
      setState(() {
        _personalData = data;
        _cargandoPersonal = false;
        _seleccionadosIds.removeWhere(
          (id) => !data.any((d) => (d['funcionario'] as Funcionario).id == id),
        );
      });
    }
  }

  Future<void> _procesarGuardado() async {
    if (!_formKey.currentState!.validate() || _seleccionadosIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione al menos un funcionario")),
      );
      return;
    }

    try {
      final db = context.read<AppDatabase>();
      final planning = context.read<PlanningController>();

      final idActividad = await db.into(db.actividades).insert(
            ActividadesCompanion.insert(
              nombreActividad: _nombreController.text,
              categoria: drift.Value(_esPernocta ? 'Pernocta' : 'Normal'),
              fecha: _fechaInicio,
              fechaFin: drift.Value(_fechaFinGuardia),
              lugar: _puestoSeleccionado ?? 'No especificado',
            ),
          );

      await planning.asignarGuardia(
        actividadId: idActividad,
        funcionariosIds: _seleccionadosIds,
        fechaActividad: _fechaInicio,
        fechaBloqueoHasta: _fechaDesbloqueo,
      );

      if (!mounted) return;
      context.read<DashboardController>().actualizarDashboard();
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text("Programar Actividad")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                  labelText: "Nombre Actividad", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Requerido" : null,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _puestoSeleccionado,
              items: _puestos
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) => setState(() => _puestoSeleccionado = val),
              decoration: const InputDecoration(
                  labelText: "Puesto", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("Fecha de Inicio"),
              subtitle: Text(dateFormat.format(_fechaInicio)),
              trailing: const Icon(Icons.calendar_today),
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onTap: () async {
                final pick = await showDatePicker(
                  context: context,
                  initialDate: _fechaInicio,
                  firstDate: DateTime.now().subtract(const Duration(days: 1)),
                  lastDate: DateTime(2030),
                );
                if (pick != null) {
                  setState(() => _fechaInicio = pick);
                  _obtenerDisponibles();
                }
              },
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              color: _esPernocta ? Colors.green[50] : Colors.grey[50],
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: _esPernocta ? Colors.green : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text("¿Es Guardia de Pernocta?"),
                      value: _esPernocta,
                      activeThumbColor: Colors.green,
                      onChanged: (val) => setState(() => _esPernocta = val),
                    ),
                    if (_esPernocta) ...[
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<int>(
                              value: _duracionDias,
                              isExpanded: true,
                              items: List.generate(30, (i) => i + 1)
                                  .map((d) => DropdownMenuItem(
                                      value: d, child: Text("$d días")))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _duracionDias = v!),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton<int>(
                              value: _factorCompensacion,
                              isExpanded: true,
                              items: [1, 2, 3]
                                  .map((f) => DropdownMenuItem(
                                      value: f, child: Text("x$f Libres")))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _factorCompensacion = v!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Personal Disponible:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            if (_cargandoPersonal)
              const Center(child: CircularProgressIndicator())
            else if (_personalData.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Nadie disponible.", textAlign: TextAlign.center))
            else
              // CORRECCIÓN: Eliminadas las llaves {} que creaban un Set
              ..._personalData.map((data) {
                final f = data['funcionario'] as Funcionario;
                final severity = data['severity'] as int;
                final saldo = data['saldo'] as int;
                Color textColor = severity == 2
                    ? Colors.red
                    : (severity == 1 ? Colors.orange : Colors.black);

                return Card(
                  child: CheckboxListTile(
                    title: Text(
                        "${f.nombres} ${f.apellidos} ${saldo > 0 ? '(+$saldo)' : ''}",
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.bold)),
                    subtitle:
                        Text("${f.rango} • Carga: ${data['cargaSemanal']}"),
                    value: _seleccionadosIds.contains(f.id),
                    onChanged: (bool? val) {
                      setState(() {
                        if (val == true) {
                          _seleccionadosIds.add(f.id);
                        } else {
                          _seleccionadosIds.remove(f.id);
                        }
                      });
                    },
                  ),
                );
              }),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _procesarGuardado,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green),
              child: const Text("REGISTRAR ACTIVIDAD"),
            ),
          ],
        ),
      ),
    );
  }
}
```

## File: lib/src/features/planning/presentation/screens/config_types_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/config_types_controller.dart';
import '../../../../data/local/app_database.dart';

class ConfigTypesScreen extends StatefulWidget {
  const ConfigTypesScreen({super.key});

  @override
  State<ConfigTypesScreen> createState() => _ConfigTypesScreenState();
}

class _ConfigTypesScreenState extends State<ConfigTypesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfigTypesController>().cargarTipos();
    });
  }

  void _mostrarDialogo({TiposGuardiaData? tipoExistente}) {
    final controller = TextEditingController(text: tipoExistente?.nombre ?? '');
    final esEdicion = tipoExistente != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(esEdicion ? "Editar Tipo" : "Nuevo Tipo de Guardia"),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: "Nombre de la Guardia",
            hintText: "Ej: Recorrido Nocturno",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) {
                return;
              }

              final logic = context.read<ConfigTypesController>();
              bool exito;

              if (esEdicion) {
                exito = await logic.editarTipo(
                  tipoExistente.id,
                  controller.text,
                );
              } else {
                exito = await logic.crearTipo(controller.text);
              }

              if (context.mounted) {
                Navigator.pop(context);
                if (!exito) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Error: El nombre ya existe o es inválido"),
                    ),
                  );
                }
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ConfigTypesController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Catálogo de Guardias")),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.tipos.isEmpty
              ? const Center(
                  child: Text("No hay tipos definidos. Agregue uno."))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.tipos.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final tipo = controller.tipos[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            tipo.activo ? Colors.green[100] : Colors.grey[200],
                        child: Icon(
                          Icons.local_police,
                          color: tipo.activo ? Colors.green[800] : Colors.grey,
                        ),
                      ),
                      title: Text(
                        tipo.nombre,
                        style: TextStyle(
                          decoration:
                              tipo.activo ? null : TextDecoration.lineThrough,
                          color: tipo.activo ? Colors.black : Colors.grey,
                        ),
                      ),
                      subtitle: Text(tipo.activo ? "Activo" : "Deshabilitado"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _mostrarDialogo(tipoExistente: tipo),
                          ),
                          Switch(
                            value: tipo.activo,
                            activeThumbColor: Colors.green,
                            onChanged: (val) {
                              controller.toggleEstado(tipo.id, tipo.activo);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogo(),
        label: const Text("Nuevo Tipo"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}
```

## File: lib/src/features/planning/presentation/screens/create_activity_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../data/local/app_database.dart';
import '../../logic/planning_controller.dart';
import '../../../dashboard/logic/dashboard_controller.dart';
import '../../../config/presentation/screens/ubicaciones_screen.dart';

class CreateActivityScreen extends StatefulWidget {
  final int?
      actividadId; // Si es null -> MODO CREAR. Si tiene valor -> MODO EDITAR.

  const CreateActivityScreen({super.key, this.actividadId});

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreActividadController = TextEditingController();
  final _lugarTextoController = TextEditingController();

  final _cupoSemanalController = TextEditingController(text: "4");
  final _factorDescansoController = TextEditingController(text: "2");

  bool _esPernocta = false;
  bool _isLoading = true;
  bool _isEditing = false; // Flag local

  // Fechas (Ordinaria)
  late DateTime _fechaActual;
  late DateTime _inicioSemana;
  Set<DateTime> _diasConGuardia = {};

  // Fechas (Pernocta)
  DateTime _fechaInicio = DateTime.now();
  DateTime _fechaFin = DateTime.now();

  int? _selectedUbicacionId;

  List<TiposGuardiaData> _tiposGuardia = [];
  List<Ubicacione> _ubicaciones = [];
  int? _selectedTipoGuardiaId;

  List<Map<String, dynamic>> _personalConMetadata = [];
  final Set<int> _seleccionadosIds = {};
  int? _jefeServicioId;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.actividadId != null;

    final now = DateTime.now();
    _inicioSemana = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    _fechaActual = _inicioSemana;
    _fechaInicio = now;
    _fechaFin = now.add(const Duration(days: 3));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatosIniciales();
    });
  }

  @override
  void dispose() {
    _nombreActividadController.dispose();
    _lugarTextoController.dispose();
    _cupoSemanalController.dispose();
    _factorDescansoController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatosIniciales() async {
    setState(() => _isLoading = true);
    try {
      final controller = context.read<PlanningController>();

      // 1. Cargar catálogos básicos
      _tiposGuardia = await controller.obtenerTiposGuardia();
      await _recargarUbicaciones();
      if (_tiposGuardia.isNotEmpty) {
        _selectedTipoGuardiaId = _tiposGuardia.first.id;
      }

      // 2. Si estamos EDITANDO, cargar datos de la actividad
      if (_isEditing) {
        await _cargarDatosEdicion(widget.actividadId!);
      }

      // 3. Cargar estado del personal y calendario
      if (!_esPernocta) {
        // Ajustar calendario a la fecha de la actividad si es ordinaria
        _inicioSemana =
            _fechaActual.subtract(Duration(days: _fechaActual.weekday - 1));
        await _actualizarEstadoSemanal();
      }

      await _refrescarPersonal();
    } catch (e) {
      debugPrint("Error cargando datos: $e");
      if (mounted) _showError("Error al cargar datos: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _cargarDatosEdicion(int id) async {
    final controller = context.read<PlanningController>();
    final detalle = await controller.obtenerActividadPorId(id);

    if (detalle != null) {
      final act = detalle.actividad;

      _nombreActividadController.text = act.nombreActividad;
      _lugarTextoController.text = act.lugar;
      _esPernocta = act.esPernocta;

      // Tipos y Ubicaciones
      if (_tiposGuardia.any((t) => t.id == act.tipoGuardiaId)) {
        _selectedTipoGuardiaId = act.tipoGuardiaId;
      }

      // Intentar machear ubicación por nombre si es pernocta
      if (_esPernocta) {
        try {
          final ubi = _ubicaciones.firstWhere((u) => u.nombre == act.lugar);
          _selectedUbicacionId = ubi.id;
        } catch (_) {
          // Si no encuentra, queda el texto manual
        }
        _fechaInicio = act.fecha;
        _fechaFin = act.fechaFin ?? act.fecha;

        if (act.diasDescansoGenerados > 0) {
          final diasGuardia = _fechaFin.difference(_fechaInicio).inDays;
          if (diasGuardia > 0) {
            final factor = (act.diasDescansoGenerados / diasGuardia).round();
            _factorDescansoController.text = factor.toString();
          }
        }
      } else {
        _fechaActual = act.fecha;
      }

      // Personal
      _seleccionadosIds.clear();
      for (var f in detalle.funcionarios) {
        _seleccionadosIds.add(f.id);
      }
      if (detalle.jefeServicio != null) {
        _jefeServicioId = detalle.jefeServicio!.id;
      } else if (act.jefeServicioId != null) {
        _jefeServicioId = act.jefeServicioId;
        _seleccionadosIds
            .add(act.jefeServicioId!); // Asegurar que jefe esté seleccionado
      }
    }
  }

  Future<void> _recargarUbicaciones() async {
    final controller = context.read<PlanningController>();
    final ubi = await controller.obtenerUbicaciones();
    setState(() => _ubicaciones = ubi);
  }

  Future<void> _actualizarEstadoSemanal() async {
    final controller = context.read<PlanningController>();
    final dias = await controller.obtenerDiasConGuardiaEnSemana(_inicioSemana);
    setState(() {
      _diasConGuardia = dias;
    });
  }

  Future<void> _refrescarPersonal() async {
    final controller = context.read<PlanningController>();
    int? cupoOverride = int.tryParse(_cupoSemanalController.text);
    final fechaConsulta = _esPernocta ? _fechaInicio : _fechaActual;

    final lista = await controller.obtenerPersonalConMetadata(
      fecha: fechaConsulta,
      esPernocta: _esPernocta,
      cupoOverride: cupoOverride,
    );

    if (mounted) {
      setState(() {
        _personalConMetadata = lista;
      });
    }
  }

  // CALENDARIO ORDINARIO
  void _cambiarSemanaBase() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => const _TacticalCalendarDialog(),
    );

    if (picked != null) {
      setState(() {
        _inicioSemana = picked.subtract(Duration(days: picked.weekday - 1));
        _fechaActual = _inicioSemana;
      });
      await _actualizarEstadoSemanal();
      await _refrescarPersonal();
    }
  }

  // CALENDARIO DE RANGO (PERNOCTA)
  void _seleccionarRangoPernocta() async {
    final DateTimeRange? picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) => _TacticalRangeCalendarDialog(
        initialDate: _fechaInicio,
      ),
    );

    if (picked != null) {
      setState(() {
        _fechaInicio = picked.start;
        _fechaFin = picked.end;
      });
      _refrescarPersonal();
    }
  }

  void _seleccionarDiaSemana(int diaIndex) async {
    final nuevaFecha = _inicioSemana.add(Duration(days: diaIndex));
    setState(() {
      _fechaActual = nuevaFecha;
    });
    await _refrescarPersonal();
  }

  void _toggleMode(bool isOvernight) {
    if (_isEditing) {
      _showError("No se puede cambiar el tipo de guardia al editar.");
      return;
    }
    setState(() {
      _esPernocta = isOvernight;
      if (isOvernight) {
        _fechaInicio = DateTime.now();
        _fechaFin = DateTime.now().add(const Duration(days: 3));
      } else {
        _fechaActual = _inicioSemana;
      }
    });
    _refrescarPersonal();
  }

  void _toggleSeleccion(int id) {
    setState(() {
      if (_seleccionadosIds.contains(id)) {
        _seleccionadosIds.remove(id);
        if (_jefeServicioId == id) {
          _jefeServicioId = null;
        }
      } else {
        _seleccionadosIds.add(id);
        if (_seleccionadosIds.length == 1) {
          _jefeServicioId = id;
        }
      }
    });
  }

  void _setJefe(int id) {
    if (!_seleccionadosIds.contains(id)) return;
    setState(() {
      _jefeServicioId = id;
    });
  }

  String get _textoCalculoBloqueo {
    if (!_esPernocta) return "Sin bloqueo obligatorio.";

    final noches = _fechaFin.difference(_fechaInicio).inDays;
    final factor = int.tryParse(_factorDescansoController.text) ?? 2;
    final diasDescanso = noches * factor;
    final fechaDesbloqueo = _fechaFin.add(Duration(days: diasDescanso));

    return "Duración: $noches Noches.\nGenera $diasDescanso días libres.\nDesbloqueo: ${DateFormat('dd/MM').format(fechaDesbloqueo)}";
  }

  // --- GUARDADO ---

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_seleccionadosIds.isEmpty) {
      _showError("Seleccione personal.");
      return;
    }
    if (_jefeServicioId == null) {
      _showError("Designe un Jefe.");
      return;
    }
    if (_esPernocta && _selectedUbicacionId == null) {
      _showError("Seleccione un Puesto/Ubicación.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final planning = context.read<PlanningController>();
      final dash = context.read<DashboardController>();

      String lugarFinal = _lugarTextoController.text;
      if (_esPernocta && _selectedUbicacionId != null) {
        final ubi =
            _ubicaciones.firstWhere((u) => u.id == _selectedUbicacionId);
        lugarFinal = ubi.nombre;
      }

      DateTime fInicio;
      DateTime fFin;
      int diasGen = 0;

      if (_esPernocta) {
        fInicio = _fechaInicio;
        fFin = _fechaFin;
        final noches = fFin.difference(fInicio).inDays;
        final factor = int.tryParse(_factorDescansoController.text) ?? 2;
        diasGen = noches * factor;
      } else {
        fInicio = _fechaActual;
        fFin = _fechaActual;
      }

      if (_isEditing) {
        // MODO EDICIÓN
        await planning.editarActividad(
          actividadIdOriginal: widget.actividadId!,
          nombre: _nombreActividadController.text,
          tipoGuardiaId: _selectedTipoGuardiaId ?? 1,
          fechaInicio: fInicio,
          fechaFin: fFin,
          lugar: lugarFinal,
          funcionariosIds: _seleccionadosIds.toList(),
          jefeServicioId: _jefeServicioId!,
          esPernocta: _esPernocta,
          diasDescansoGenerados: diasGen,
        );
      } else {
        // MODO CREACIÓN
        await planning.guardarActividadCompleta(
          nombre: _nombreActividadController.text,
          tipoGuardiaId: _selectedTipoGuardiaId ?? 1,
          fechaInicio: fInicio,
          fechaFin: fFin,
          lugar: lugarFinal,
          funcionariosIds: _seleccionadosIds.toList(),
          jefeServicioId: _jefeServicioId!,
          esPernocta: _esPernocta,
          diasDescansoGenerados: diasGen,
        );
      }

      dash.actualizarDashboard();

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                _isEditing ? "✅ Actividad Actualizada" : "✅ Guardado Exitoso"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Volver al historial
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError("Error: $e");
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  String _getDayLabel(int weekday) {
    const d = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    return d[weekday - 1];
  }

  // --- WIDGETS ---

  Widget _buildWeekNavigator() {
    final DateFormat formatter = DateFormat('dd MMM');
    final String labelSemana = "Semana del ${formatter.format(_inicioSemana)}";

    return Column(
      children: [
        InkWell(
          onTap: _cambiarSemanaBase,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month, color: Colors.indigo),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    labelSemana,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final diaFecha = _inicioSemana.add(Duration(days: index));
              final diaFechaNorm =
                  DateTime(diaFecha.year, diaFecha.month, diaFecha.day);

              final bool isSelected = _fechaActual.day == diaFecha.day;
              final bool isPlanned =
                  _diasConGuardia.any((d) => d.isAtSameMomentAs(diaFechaNorm));

              return GestureDetector(
                onTap: () => _seleccionarDiaSemana(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.indigo
                            : (isPlanned
                                ? Colors.green.shade100
                                : Colors.grey.shade200),
                        shape: BoxShape.circle,
                        border: isPlanned
                            ? Border.all(color: Colors.green, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: isPlanned && !isSelected
                            ? const Icon(Icons.check,
                                size: 20, color: Colors.green)
                            : Text(
                                _getDayLabel(index + 1),
                                style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${diaFecha.day}",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing
            ? "Editar Actividad"
            : (_esPernocta ? "Planificar Pernocta" : "Guardia Ordinaria")),
        actions: [
          if (_esPernocta)
            IconButton(
              icon: const Icon(Icons.settings_input_component),
              tooltip: "Gestionar Puestos",
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const UbicacionesScreen()));
                _recargarUbicaciones();
              },
            )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        IgnorePointer(
                          ignoring: _isEditing,
                          child: Opacity(
                            opacity: _isEditing ? 0.6 : 1.0,
                            child: SegmentedButton<bool>(
                              segments: const [
                                ButtonSegment(
                                  value: false,
                                  label: Text("Ordinaria"),
                                  icon: Icon(Icons.shield_outlined),
                                ),
                                ButtonSegment(
                                  value: true,
                                  label: Text("Pernocta"),
                                  icon: Icon(Icons.night_shelter_outlined),
                                ),
                              ],
                              selected: {_esPernocta},
                              onSelectionChanged: (Set<bool> newSelection) {
                                _toggleMode(newSelection.first);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (_esPernocta) ...[
                          // RANGO TÁCTICO
                          InkWell(
                            onTap: _seleccionarRangoPernocta,
                            child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: "Periodo de Pernocta",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.date_range,
                                      color: Colors.indigo),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${DateFormat('dd/MM').format(_fechaInicio)} al ${DateFormat('dd/MM').format(_fechaFin)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(Icons.edit,
                                        size: 16, color: Colors.grey)
                                  ],
                                )),
                          ),

                          const SizedBox(height: 10),

                          Row(children: [
                            Expanded(
                              flex: 3,
                              child:
                                  // ignore: deprecated_member_use
                                  DropdownButtonFormField<int>(
                                isExpanded: true,
                                value: _selectedUbicacionId,
                                decoration: const InputDecoration(
                                  labelText: "Puesto / Ubicación",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.map),
                                ),
                                items: _ubicaciones.map((u) {
                                  return DropdownMenuItem(
                                      value: u.id,
                                      child: Text(
                                        u.nombre,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ));
                                }).toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedUbicacionId = val),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: _factorDescansoController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    labelText: "Factor",
                                    border: OutlineInputBorder(),
                                    hintText: "x2",
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ))
                          ]),

                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.indigo.shade100)),
                            child: Row(
                              children: [
                                const Icon(Icons.info, color: Colors.indigo),
                                const SizedBox(width: 10),
                                Expanded(child: Text(_textoCalculoBloqueo)),
                              ],
                            ),
                          ),
                        ] else ...[
                          // MODO ORDINARIO
                          _buildWeekNavigator(),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: _cupoSemanalController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: "Cupo",
                                      border: OutlineInputBorder()),
                                  onChanged: (_) => _refrescarPersonal(),
                                )),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 3,
                                child:
                                    // ignore: deprecated_member_use
                                    DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  value: _selectedTipoGuardiaId,
                                  items: _tiposGuardia
                                      .map((t) => DropdownMenuItem(
                                          value: t.id,
                                          child: Text(
                                            t.nombre,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )))
                                      .toList(),
                                  onChanged: (v) => setState(
                                      () => _selectedTipoGuardiaId = v),
                                  decoration: const InputDecoration(
                                      labelText: "Actividad",
                                      border: OutlineInputBorder()),
                                ))
                          ]),
                          const SizedBox(height: 10),
                          TextFormField(
                              controller: _nombreActividadController,
                              decoration: const InputDecoration(
                                  labelText: "Detalle",
                                  border: OutlineInputBorder())),
                          const SizedBox(height: 10),
                          TextFormField(
                              controller: _lugarTextoController,
                              decoration: const InputDecoration(
                                  labelText: "Lugar",
                                  border: OutlineInputBorder())),
                        ],
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Equipo (${_seleccionadosIds.length})",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            if (_jefeServicioId == null &&
                                _seleccionadosIds.isNotEmpty)
                              const Flexible(
                                child: Text(
                                  "¡Designe un Líder! ★",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        const Divider(),
                        if (_personalConMetadata.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(
                                child: Text("No hay personal disponible")),
                          ),
                        ..._personalConMetadata.map((meta) {
                          final f = meta['funcionario'] as Funcionario;
                          final severity = meta['severity'] as int;
                          final statusText = meta['statusText'] as String;
                          final ultimaPernocta =
                              meta['ultimaPernocta'] as DateTime?;

                          final isSelected = _seleccionadosIds.contains(f.id);
                          final isLeader = _jefeServicioId == f.id;

                          Color cardColor = Colors.white;
                          if (severity == 2) cardColor = Colors.red.shade50;
                          if (severity == 1) cardColor = Colors.amber.shade50;
                          if (isSelected) cardColor = Colors.green.shade50;

                          String subtitulo = f.rango ?? 'S/R';
                          if (_esPernocta) {
                            if (ultimaPernocta == null) {
                              subtitulo += " • Nunca (PRIORIDAD)";
                            } else {
                              final dias = DateTime.now()
                                  .difference(ultimaPernocta)
                                  .inDays;
                              if (dias < 30) {
                                subtitulo += " • Hace $dias días";
                              } else {
                                final meses = (dias / 30).floor();
                                subtitulo += " • Hace $meses meses";
                              }
                            }
                          } else {
                            subtitulo += " • $statusText";
                          }

                          return Card(
                            color: cardColor,
                            elevation: isSelected ? 2 : 0,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                  color: isSelected
                                      ? Colors.green
                                      : Colors.transparent,
                                  width: 1.5),
                            ),
                            child: InkWell(
                              onTap: severity == 2
                                  ? null
                                  : () => _toggleSeleccion(f.id),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: isSelected
                                          ? Colors.green
                                          : Colors.grey.shade300,
                                      foregroundColor: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      child: Text(f.nombres.isNotEmpty
                                          ? f.nombres[0]
                                          : "?"),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${f.nombres} ${f.apellidos}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: severity == 2
                                                  ? Colors.grey
                                                  : Colors.black,
                                              decoration: severity == 2
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            subtitulo,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: severity == 2
                                                  ? Colors.red
                                                  : Colors.grey.shade700,
                                              fontWeight: severity == 2
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      IconButton(
                                        icon: Icon(
                                          isLeader
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: isLeader
                                              ? Colors.orange
                                              : Colors.grey,
                                          size: 28,
                                        ),
                                        onPressed: () => _setJefe(f.id),
                                        tooltip: "Líder",
                                      ),
                                    if (severity == 2)
                                      const Icon(Icons.lock,
                                          color: Colors.red, size: 20)
                                    else
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        )
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isEditing
                              ? Colors.orange.shade700
                              : (_esPernocta ? Colors.indigo : Colors.green),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _guardar,
                        child: Text(_isEditing
                            ? "ACTUALIZAR ACTIVIDAD"
                            : (_esPernocta
                                ? "CONFIRMAR PERNOCTA"
                                : "GUARDAR TURNO DEL ${_getDayLabel(_fechaActual.weekday)}")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _TacticalCalendarDialog extends StatefulWidget {
  const _TacticalCalendarDialog();

  @override
  State<_TacticalCalendarDialog> createState() =>
      _TacticalCalendarDialogState();
}

class _TacticalCalendarDialogState extends State<_TacticalCalendarDialog> {
  DateTime _currentMonth = DateTime.now();
  Set<int> _occupiedDays = {};

  @override
  void initState() {
    super.initState();
    _loadOccupation();
  }

  void _loadOccupation() async {
    final controller = context.read<PlanningController>();
    final days = await controller.obtenerDiasOcupadosEnMes(
        _currentMonth.year, _currentMonth.month);
    if (mounted) {
      setState(() => _occupiedDays = days);
    }
  }

  void _changeMonth(int increment) {
    setState(() {
      _currentMonth =
          DateTime(_currentMonth.year, _currentMonth.month + increment);
    });
    _loadOccupation();
  }

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('MMMM yyyy').format(_currentMonth).toUpperCase();
    final daysInMonth =
        DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstDayOffset =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday - 1;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _changeMonth(-1)),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _changeMonth(1)),
        ],
      ),
      content: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['L', 'M', 'M', 'J', 'V', 'S', 'D']
                  .map((d) => Text(d,
                      style: const TextStyle(fontWeight: FontWeight.bold)))
                  .toList(),
            ),
            const Divider(),
            Expanded(
              child: GridView.builder(
                itemCount: daysInMonth + firstDayOffset,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7),
                itemBuilder: (ctx, index) {
                  if (index < firstDayOffset) return const SizedBox();
                  final day = index - firstDayOffset + 1;
                  final hasGuard = _occupiedDays.contains(day);

                  return InkWell(
                    onTap: () {
                      final selectedDate = DateTime(
                          _currentMonth.year, _currentMonth.month, day);
                      Navigator.pop(context, selectedDate);
                    },
                    child: Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: hasGuard
                              ? Colors.green.shade100
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border:
                              hasGuard ? Border.all(color: Colors.green) : null,
                        ),
                        child: Center(
                          child: Text(
                            "$day",
                            style: TextStyle(
                                color:
                                    hasGuard ? Colors.green[800] : Colors.black,
                                fontWeight: hasGuard
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green))),
                const SizedBox(width: 5),
                const Text("Con Guardia", style: TextStyle(fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _TacticalRangeCalendarDialog extends StatefulWidget {
  final DateTime initialDate;
  const _TacticalRangeCalendarDialog({required this.initialDate});

  @override
  State<_TacticalRangeCalendarDialog> createState() =>
      _TacticalRangeCalendarDialogState();
}

class _TacticalRangeCalendarDialogState
    extends State<_TacticalRangeCalendarDialog> {
  late DateTime _currentMonth;
  List<DateTimeRange> _occupiedRanges = [];

  // Selección actual
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialDate;
    _loadOccupation();
  }

  void _loadOccupation() async {
    final controller = context.read<PlanningController>();
    final ranges = await controller.obtenerPernoctasDelMes(
        _currentMonth.year, _currentMonth.month);
    if (mounted) {
      setState(() => _occupiedRanges = ranges);
    }
  }

  void _changeMonth(int increment) {
    setState(() {
      _currentMonth =
          DateTime(_currentMonth.year, _currentMonth.month + increment);
    });
    _loadOccupation();
  }

  void _onDayTap(DateTime date) {
    if (_startDate == null || (_startDate != null && _endDate != null)) {
      // Nueva selección
      setState(() {
        _startDate = date;
        _endDate = null;
      });
    } else {
      // Cerrar rango
      if (date.isBefore(_startDate!)) {
        setState(() => _startDate = date);
      } else {
        setState(() => _endDate = date);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('MMMM yyyy').format(_currentMonth).toUpperCase();
    final daysInMonth =
        DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstDayOffset =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday - 1;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _changeMonth(-1)),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _changeMonth(1)),
        ],
      ),
      content: SizedBox(
        width: 300,
        height: 350,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['L', 'M', 'M', 'J', 'V', 'S', 'D']
                  .map((d) => Text(d,
                      style: const TextStyle(fontWeight: FontWeight.bold)))
                  .toList(),
            ),
            const Divider(),
            Expanded(
              child: GridView.builder(
                itemCount: daysInMonth + firstDayOffset,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7),
                itemBuilder: (ctx, index) {
                  if (index < firstDayOffset) return const SizedBox();
                  final day = index - firstDayOffset + 1;
                  final date =
                      DateTime(_currentMonth.year, _currentMonth.month, day);

                  // Lógica de Pintado
                  bool isOccupied = false;
                  for (var r in _occupiedRanges) {
                    // Normalizamos fechas para comparación
                    final start =
                        DateTime(r.start.year, r.start.month, r.start.day);
                    final end = DateTime(r.end.year, r.end.month, r.end.day);

                    if (!date.isBefore(start) && !date.isAfter(end)) {
                      isOccupied = true;
                      break;
                    }
                  }

                  bool isSelected = false;
                  if (_startDate != null) {
                    if (_endDate == null) {
                      isSelected = date.isAtSameMomentAs(_startDate!);
                    } else {
                      isSelected = !date.isBefore(_startDate!) &&
                          !date.isAfter(_endDate!);
                    }
                  }

                  return InkWell(
                    onTap: () => _onDayTap(date),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.indigo
                              : (isOccupied ? Colors.amber.shade200 : null),
                          borderRadius: BorderRadius.circular(4),
                          border: (isSelected || isOccupied)
                              ? null
                              : Border.all(color: Colors.grey.shade200)),
                      child: Center(
                          child: Text("$day",
                              style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: (isSelected || isOccupied)
                                      ? FontWeight.bold
                                      : FontWeight.normal))),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        FilledButton(
            onPressed: (_startDate != null && _endDate != null)
                ? () => Navigator.pop(
                    context, DateTimeRange(start: _startDate!, end: _endDate!))
                : null,
            child: const Text("Confirmar"))
      ],
    );
  }
}
```

## File: lib/src/features/planning/presentation/screens/planning_history_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart'; // NECESARIO PARA IMPRIMIR
import 'package:pdf/pdf.dart';
import 'package:collection/collection.dart'; // Para groupBy

// Importaciones de Lógica y Datos
import '../../logic/planning_controller.dart';
import '../../../../data/local/app_database.dart';
import '../../../reports/logic/pdf_generator_service.dart';

// CORRECCIÓN DE RUTA: Importamos el generador desde el módulo 'incidents'
import '../../../incidents/logic/acta_generator.dart';

import 'create_activity_screen.dart'; // Para editar actividades

class PlanningHistoryScreen extends StatelessWidget {
  const PlanningHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 3 PESTAÑAS: Ordinarias, Pernoctas, Actas
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Gestión de Actividades"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calendar_view_week), text: "Ordinarias"),
              Tab(icon: Icon(Icons.calendar_month), text: "Pernoctas"),
              Tab(icon: Icon(Icons.gavel), text: "Libro de Actas"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: "Ayuda",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        "Usa los botones de impresora en cada grupo para generar reportes."),
                  ),
                );
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            _OrdinariasTab(),
            _PernoctasTab(),
            _IncidenciasTab(),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TAB 1: ORDINARIAS (Agrupado por SEMANA)
// ============================================================================

class _OrdinariasTab extends StatefulWidget {
  const _OrdinariasTab();

  @override
  State<_OrdinariasTab> createState() => _OrdinariasTabState();
}

class _OrdinariasTabState extends State<_OrdinariasTab> {
  // Función para obtener el lunes de la semana de una fecha
  DateTime _getMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  Future<void> _imprimirSemana(BuildContext context, DateTime lunes) async {
    // 1. Selector de Fecha con corrección de idioma
    final picked = await showDatePicker(
      context: context,
      initialDate: lunes,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      helpText: "CONFIRMAR LUNES DE INICIO",
      // CORRECCIÓN IDIOMA: Forzamos Español
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32), // Verde Inparques
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null || !mounted) return;

    // 2. Generación del PDF
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final controller = context.read<PlanningController>();
      final pdfService = PdfGeneratorService();

      final dataPaquete = await controller.generarPaqueteReporte(picked);
      final config = dataPaquete['config'] as ConfigSetting?;
      final items = dataPaquete['items'] as List<ReporteDataDTO>;

      final bytes = await pdfService.generateWeeklyReport(
        config: config,
        items: items,
        inicioSemana: picked,
      );

      if (mounted) {
        Navigator.pop(context); // Cerrar loading
        await Printing.layoutPdf(
          onLayout: (_) async => bytes,
          name: 'Rol_Semanal_${DateFormat('dd_MM').format(picked)}.pdf',
          format: PdfPageFormat.a4.landscape,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PlanningController>();

    return FutureBuilder<List<ReporteDataDTO>>(
      future: controller.listarHistorial(esPernocta: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay guardias ordinarias."));
        }

        final items = snapshot.data!;

        // AGRUPAR POR SEMANA (Lunes)
        final agrupado = groupBy(items, (item) {
          final lunes = _getMonday(item.actividad.fecha);
          return DateTime(lunes.year, lunes.month, lunes.day);
        });

        // Ordenar las semanas (más reciente primero)
        final semanasOrdenadas = agrupado.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: semanasOrdenadas.length,
          itemBuilder: (context, index) {
            final lunes = semanasOrdenadas[index];
            final domingo = lunes.add(const Duration(days: 6));
            final actividadesDeSemana = agrupado[lunes]!;

            final tituloSemana =
                "Semana del ${DateFormat('d MMM').format(lunes)} al ${DateFormat('d MMM yyyy').format(domingo)}";

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                initiallyExpanded: index == 0,
                shape: Border.all(color: Colors.transparent),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.date_range, color: Colors.blue),
                ),
                title: Text(
                  tituloSemana,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("${actividadesDeSemana.length} actividades"),
                trailing: IconButton(
                  icon: const Icon(Icons.print, color: Colors.grey),
                  tooltip: "Imprimir Rol Semanal",
                  onPressed: () => _imprimirSemana(context, lunes),
                ),
                children: actividadesDeSemana.map((dto) {
                  return _ActividadTile(
                    dto: dto,
                    color: Colors.blue.shade50,
                    iconColor: Colors.blue,
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================================
// TAB 2: PERNOCTAS (Agrupado por MES)
// ============================================================================

class _PernoctasTab extends StatefulWidget {
  const _PernoctasTab();

  @override
  State<_PernoctasTab> createState() => _PernoctasTabState();
}

class _PernoctasTabState extends State<_PernoctasTab> {
  Future<void> _imprimirMes(BuildContext context, DateTime mesDate) async {
    // 1. Selector de Mes con corrección de idioma
    final picked = await showDatePicker(
      context: context,
      initialDate: mesDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      helpText: "CONFIRMAR MES",
      // CORRECCIÓN IDIOMA: Forzamos Español
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null || !mounted) return;

    // 2. Generación PDF
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final controller = context.read<PlanningController>();
      final pdfService = PdfGeneratorService();

      final dataPaquete = await controller.generarReporteMensualPernoctas(
          picked.year, picked.month);
      final config = dataPaquete['config'] as ConfigSetting?;
      final items = dataPaquete['items'] as List<ReporteDataDTO>;

      final bytes = await pdfService.generateMonthlyReport(
        config: config,
        items: items,
        month: picked.month,
        year: picked.year,
      );

      if (mounted) {
        Navigator.pop(context);
        await Printing.layoutPdf(
          onLayout: (_) async => bytes,
          name: 'Rol_Pernocta_${picked.month}_${picked.year}.pdf',
          format: PdfPageFormat.a4.landscape,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PlanningController>();

    return FutureBuilder<List<ReporteDataDTO>>(
      future: controller.listarHistorial(esPernocta: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay pernoctas registradas."));
        }

        final items = snapshot.data!;

        // AGRUPAR POR MES (Día 1 del mes)
        final agrupado = groupBy(items, (item) {
          return DateTime(
              item.actividad.fecha.year, item.actividad.fecha.month, 1);
        });

        // Ordenar meses (más reciente primero)
        final mesesOrdenados = agrupado.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: mesesOrdenados.length,
          itemBuilder: (context, index) {
            final mesDate = mesesOrdenados[index];
            final actividadesDelMes = agrupado[mesDate]!;
            final tituloMes =
                DateFormat('MMMM yyyy').format(mesDate).toUpperCase();

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                initiallyExpanded: index == 0,
                shape: Border.all(color: Colors.transparent),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.night_shelter, color: Colors.purple),
                ),
                title: Text(
                  tituloMes,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("${actividadesDelMes.length} guardias"),
                trailing: IconButton(
                  icon: const Icon(Icons.print, color: Colors.grey),
                  tooltip: "Imprimir Rol Mensual",
                  onPressed: () => _imprimirMes(context, mesDate),
                ),
                children: actividadesDelMes.map((dto) {
                  return _ActividadTile(
                    dto: dto,
                    color: Colors.purple.shade50,
                    iconColor: Colors.purple,
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================================
// TAB 3: INCIDENCIAS / ACTAS (Listado Cronológico)
// ============================================================================

class _IncidenciasTab extends StatelessWidget {
  const _IncidenciasTab();

  Future<void> _verActa(BuildContext context, int incidenciaId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final controller = context.read<PlanningController>();

      // Usamos el método del PlanningController que obtiene toda la info legal
      final data = await controller.obtenerDatosActaCompleta(incidenciaId);

      // Usamos el generador del módulo 'incidents'
      final bytes = await ActaGenerator().generate(data);

      if (context.mounted) {
        Navigator.pop(context);
        await Printing.layoutPdf(
          onLayout: (_) async => bytes,
          name: 'Acta_Inasistencia_$incidenciaId.pdf',
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error abriendo acta: $e"),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PlanningController>();

    return FutureBuilder<List<IncidenciaDataDTO>>(
      future: controller.listarIncidencias(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gavel, size: 60, color: Colors.grey.shade300),
                const SizedBox(height: 10),
                Text(
                  "No hay actas registradas",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        final actas = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: actas.length,
          itemBuilder: (context, index) {
            final item = actas[index];
            final fechaActa = item.incidencia.fechaHoraRegistro;
            final nombreInasistente =
                "${item.inasistente.nombres} ${item.inasistente.apellidos}";

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.description, color: Colors.red.shade800),
                ),
                title: Text(
                  "Acta de Inasistencia #${item.incidencia.id}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text("Funcionario: $nombreInasistente"),
                    Text(
                      "Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(fechaActa)}",
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.print),
                  color: Colors.grey.shade700,
                  tooltip: "Ver/Imprimir Acta",
                  onPressed: () => _verActa(context, item.incidencia.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================================
// WIDGET COMPARTIDO: Tile de Actividad (Reutilizable)
// ============================================================================

class _ActividadTile extends StatelessWidget {
  final ReporteDataDTO dto;
  final Color color;
  final Color iconColor;

  const _ActividadTile({
    required this.dto,
    required this.color,
    required this.iconColor,
  });

  void _navegarAEditar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateActivityScreen(actividadId: dto.actividad.id),
      ),
    );
  }

  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("¿Eliminar Actividad?"),
        content: const Text(
            "Esta acción borrará la planificación y liberará al personal asignado.\n\n⚠️ No se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final controller = ctx.read<PlanningController>();
                await controller.eliminarActividad(dto.actividad.id);
                // No necesitamos setState porque usamos watch en el padre
              } catch (e) {
                // Manejo básico de error
              }
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEEE d').format(dto.actividad.fecha);
    final jefeName = dto.jefeServicio != null
        ? "${dto.jefeServicio!.nombres} ${dto.jefeServicio!.apellidos}"
        : "Sin Jefe Asignado";

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.circle, size: 12, color: iconColor),
          if (dto.actividad.fechaFin != null) ...[
            Container(
                height: 10, width: 2, color: iconColor.withValues(alpha: 0.3)),
            Icon(Icons.circle,
                size: 8, color: iconColor.withValues(alpha: 0.5)),
          ]
        ],
      ),
      title: Text(
        "${dto.actividad.nombreActividad} ($dateStr)",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dto.actividad.lugar,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          Text("Líder: $jefeName",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
        onSelected: (value) {
          if (value == 'edit') _navegarAEditar(context);
          if (value == 'delete') _confirmarEliminar(context);
        },
        itemBuilder: (ctx) => [
          const PopupMenuItem(value: 'edit', child: Text('Editar')),
          const PopupMenuItem(
              value: 'delete',
              child: Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
      onTap: () => _navegarAEditar(context),
    );
  }
}
```

## File: lib/src/features/planning/presentation/screens/planning_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:collection/collection.dart'; // Vital para agrupar por días

import '../../../../data/local/app_database.dart';
import '../../logic/planning_controller.dart';
import '../../../reports/logic/pdf_generator_service.dart';
import 'create_activity_screen.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  // Navegar entre semanas usando la memoria del controlador
  void _cambiarSemana(int semanas) {
    final controller = context.read<PlanningController>();
    final nuevoFoco = controller.focusedDay.add(Duration(days: 7 * semanas));
    controller.setFocusedDay(nuevoFoco);
  }

  // Volver a la semana actual
  void _irHoy() {
    context.read<PlanningController>().setFocusedDay(DateTime.now());
  }

  // Generar PDF de la semana que estamos viendo
  Future<void> _imprimirReporteActual(DateTime inicioSemana) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final controller = context.read<PlanningController>();
      final pdfService = PdfGeneratorService();

      final dataPaquete = await controller.generarPaqueteReporte(inicioSemana);
      final config = dataPaquete['config'] as ConfigSetting?;
      final items = dataPaquete['items'] as List<ReporteDataDTO>;

      final bytes = await pdfService.generateWeeklyReport(
        config: config,
        items: items,
        inicioSemana: inicioSemana,
      );

      if (mounted) {
        Navigator.pop(context); // Cerrar loading
        await Printing.layoutPdf(
          onLayout: (format) async => bytes,
          name: 'Rol_Semanal_${DateFormat('dd_MM').format(inicioSemana)}.pdf',
          format: PdfPageFormat.a4.landscape,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error generando PDF: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Escuchar al controlador para saber qué semana mostrar
    final controller = context.watch<PlanningController>();
    final focusedDay = controller.focusedDay;

    // 2. Calcular inicio (Lunes) y fin (Domingo) de la semana en foco
    final inicioSemana =
        focusedDay.subtract(Duration(days: focusedDay.weekday - 1));
    final finSemana = inicioSemana.add(const Duration(days: 6));

    // Texto del rango (Ej: 10 Feb - 16 Feb 2026)
    final rangoTexto =
        "${DateFormat('d MMM').format(inicioSemana)} - ${DateFormat('d MMM yyyy').format(finSemana)}";

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("Planificador Semanal", style: TextStyle(fontSize: 18)),
            Text(
              rangoTexto.toUpperCase(),
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: "Ir a Hoy",
            onPressed: _irHoy,
          ),
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: "Imprimir esta semana",
            onPressed: () => _imprimirReporteActual(inicioSemana),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- BARRA DE NAVEGACIÓN SEMANAL ---
          Container(
            color: Colors.green.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.green),
                  onPressed: () => _cambiarSemana(-1),
                ),
                Text(
                  "SEMANA ${DateFormat('w').format(inicioSemana)}", // Número de semana
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.green),
                  onPressed: () => _cambiarSemana(1),
                ),
              ],
            ),
          ),

          // --- LISTA DE ACTIVIDADES (VISTA DIARIA) ---
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: controller.generarPaqueteReporte(inicioSemana),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items =
                    (snapshot.data?['items'] as List<ReporteDataDTO>?) ?? [];

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy,
                            size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        Text(
                          "Sin actividades planificadas",
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                // Agrupar por día para mostrar cabeceras (Lunes, Martes...)
                final agrupado = groupBy(items, (item) {
                  return DateFormat('EEEE d', 'es_ES')
                      .format(item.actividad.fecha);
                });

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: agrupado.length,
                  itemBuilder: (context, index) {
                    final diaKey = agrupado.keys.elementAt(index);
                    final actividadesDia = agrupado[diaKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabecera del Día
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            diaKey.toUpperCase(),
                            style: TextStyle(
                              color: Colors.indigo.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        // Lista de tarjetas del día
                        ...actividadesDia.map((dto) => _ActivityCard(dto: dto)),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Botón flotante para agregar actividad (pasa la fecha actual del foco)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegamos pasando la fecha de la semana que estamos mirando
          Navigator.pushNamed(
            context,
            '/create_activity',
            // Opcional: Podrías pasar arguments: controller.focusedDay
            // Pero como CreateActivityScreen es independiente, al guardar
            // actualizará la memoria del controller y al volver aquí se refrescará solo.
          );
        },
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Planificar", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// Widget auxiliar para cada tarjeta de actividad
class _ActivityCard extends StatelessWidget {
  final ReporteDataDTO dto;

  const _ActivityCard({required this.dto});

  @override
  Widget build(BuildContext context) {
    final act = dto.actividad;
    final personalCount = dto.funcionarios.length;
    final jefe = dto.jefeServicio;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              act.esPernocta ? Colors.purple.shade50 : Colors.blue.shade50,
          child: Icon(
            act.esPernocta ? Icons.night_shelter : Icons.shield,
            color: act.esPernocta ? Colors.purple : Colors.blue,
            size: 20,
          ),
        ),
        title: Text(
          act.nombreActividad,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(act.lugar, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (jefe != null)
              Text("Líder: ${jefe.nombres} ${jefe.apellidos}",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
          ],
        ),
        trailing: Chip(
          label: Text("$personalCount"),
          avatar: const Icon(Icons.people, size: 14),
          visualDensity: VisualDensity.compact,
          backgroundColor: Colors.grey.shade100,
        ),
        onTap: () {
          // Navegar a editar (reutilizando pantalla de creación)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateActivityScreen(actividadId: act.id),
            ),
          );
        },
      ),
    );
  }
}
```

## File: lib/src/features/reports/logic/pdf_generator_service.dart
```dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../planning/logic/planning_controller.dart';
import '../../../data/local/app_database.dart';

class PdfGeneratorService {
  Future<Uint8List> generateWeeklyReport({
    required ConfigSetting? config,
    required List<ReporteDataDTO> items,
    required DateTime inicioSemana,
  }) async {
    final doc = pw.Document();

    final font = await PdfGoogleFonts.nunitoExtraLight();
    final fontBold = await PdfGoogleFonts.nunitoBold();

    final finSemana = inicioSemana.add(const Duration(days: 6));
    final periodoStr =
        "SEMANA DEL ${DateFormat('dd/MM/yyyy').format(inicioSemana)} AL ${DateFormat('dd/MM/yyyy').format(finSemana)}";

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(context, config,
            "ROL DE GUARDIAS ORDINARIAS", periodoStr, font, fontBold),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildWeeklyTable(items, font, fontBold),
        ],
        footer: (context) => _buildFooter(context, font),
      ),
    );

    return doc.save();
  }

  Future<Uint8List> generateMonthlyReport({
    required ConfigSetting? config,
    required List<ReporteDataDTO> items,
    required int month,
    required int year,
  }) async {
    final doc = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final fontBold = await PdfGoogleFonts.nunitoBold();

    final mesStr = DateFormat('MMMM yyyy', 'es').format(DateTime(year, month));
    final tituloPeriodo = "PERÍODO: ${mesStr.toUpperCase()}";

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
            context, config, "ROL DE PERNOCTAS", tituloPeriodo, font, fontBold),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildMonthlyTable(items, font, fontBold),
        ],
        footer: (context) => _buildFooter(context, font),
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader(
    pw.Context context,
    ConfigSetting? config,
    String tituloReporte,
    String subtitulo,
    pw.Font font,
    pw.Font fontBold,
  ) {
    // PREPARACIÓN DE DATOS (LIMPIEZA DE WARNINGS)
    String nombreCompletoJefe = "INPARQUES";
    if (config != null) {
      // CORRECCIÓN: nombreJefe y rangoJefe NO son nulos en BD.
      // apellidoJefe SI es nulo.
      nombreCompletoJefe =
          "${config.rangoJefe} ${config.nombreJefe} ${config.apellidoJefe ?? ''}"
              .toUpperCase();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // 1. Institución / Parque
        // CORRECCIÓN: nombreInstitucion no es nulo en BD
        pw.Text(
          config?.nombreInstitucion.toUpperCase() ?? "INPARQUES",
          style: pw.TextStyle(font: fontBold, fontSize: 16),
          textAlign: pw.TextAlign.center,
        ),
        pw.Text(
          "${config?.municipio ?? ''} - ${config?.estado ?? ''}".toUpperCase(),
          style: pw.TextStyle(font: font, fontSize: 10),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 10),

        // 2. Título del Reporte
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            children: [
              pw.Text(tituloReporte,
                  style: pw.TextStyle(font: fontBold, fontSize: 14)),
              pw.Text(subtitulo,
                  style: pw.TextStyle(font: fontBold, fontSize: 12)),
            ],
          ),
        ),
        pw.SizedBox(height: 10),

        // 3. Datos del Jefe de Sector
        if (config != null)
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(5),
            color: PdfColors.grey200,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text("JEFE DE SECTOR: ",
                    style: pw.TextStyle(font: fontBold, fontSize: 10)),
                pw.Text(
                  nombreCompletoJefe,
                  style: pw.TextStyle(font: font, fontSize: 10),
                ),
              ],
            ),
          ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _buildWeeklyTable(
      List<ReporteDataDTO> items, pw.Font font, pw.Font fontBold) {
    if (items.isEmpty) {
      return pw.Center(child: pw.Text("SIN ACTIVIDADES REGISTRADAS"));
    }

    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(60),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(3),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _cellHeader("FECHA", fontBold),
            _cellHeader("ACTIVIDAD / LUGAR", fontBold),
            _cellHeader("JEFE DE SERVICIO", fontBold),
            _cellHeader("PERSONAL ASIGNADO", fontBold),
          ],
        ),
        ...items.map((item) {
          final dateStr = DateFormat('EEE dd/MM', 'es')
              .format(item.actividad.fecha)
              .toUpperCase();
          final jefeStr = item.jefeServicio != null
              ? "${item.jefeServicio!.rango ?? ''} ${item.jefeServicio!.nombres} ${item.jefeServicio!.apellidos}"
              : "SIN ASIGNAR";

          final personalList = item.funcionarios
              .where((f) => f.id != item.jefeServicio?.id)
              .map((f) => "• ${f.rango ?? ''} ${f.nombres} ${f.apellidos}")
              .join("\n");

          return pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: [
              _cell(dateStr, font, align: pw.TextAlign.center),
              _cell(
                  "${item.actividad.nombreActividad}\n(${item.actividad.lugar})",
                  font),
              _cell(jefeStr, font),
              _cell(personalList.isEmpty ? "(Solo Jefe)" : personalList, font),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildMonthlyTable(
      List<ReporteDataDTO> items, pw.Font font, pw.Font fontBold) {
    if (items.isEmpty) {
      return pw.Center(child: pw.Text("SIN PERNOCTAS REGISTRADAS"));
    }

    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(80),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(3),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _cellHeader("PERIODO", fontBold),
            _cellHeader("PUESTO / UBICACIÓN", fontBold),
            _cellHeader("JEFE DE SERVICIO", fontBold),
            _cellHeader("PERSONAL ASIGNADO", fontBold),
          ],
        ),
        ...items.map((item) {
          final inicio = DateFormat('dd/MM').format(item.actividad.fecha);
          final fin = item.actividad.fechaFin != null
              ? DateFormat('dd/MM').format(item.actividad.fechaFin!)
              : "?";
          final periodo = "$inicio AL $fin";

          final jefeStr = item.jefeServicio != null
              ? "${item.jefeServicio!.rango ?? ''} ${item.jefeServicio!.nombres} ${item.jefeServicio!.apellidos}"
              : "SIN ASIGNAR";

          final personalList = item.funcionarios
              .where((f) => f.id != item.jefeServicio?.id)
              .map((f) => "• ${f.rango ?? ''} ${f.nombres} ${f.apellidos}")
              .join("\n");

          return pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: [
              _cell(periodo, font, align: pw.TextAlign.center),
              _cell(item.actividad.lugar, font, align: pw.TextAlign.center),
              _cell(jefeStr, font),
              _cell(personalList.isEmpty ? "(Solo Jefe)" : personalList, font),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _cellHeader(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
            font: font, fontSize: 9, fontWeight: pw.FontWeight.bold),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _cell(String text, pw.Font font,
      {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 9),
        textAlign: align,
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context, pw.Font font) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        "Página ${context.pageNumber} de ${context.pagesCount} - Generado el ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}",
        style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey),
      ),
    );
  }
}
```

## File: lib/src/features/reports/logic/weekly_report_generator.dart
```dart
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../data/local/app_database.dart';
import '../../planning/logic/planning_controller.dart';

class WeeklyReportGenerator {
  static const Map<int, String> _diasSemana = {
    1: 'LUNES',
    2: 'MARTES',
    3: 'MIERCOLES',
    4: 'JUEVES',
    5: 'VIERNES',
    6: 'SABADO',
    7: 'DOMINGO'
  };

  static const Map<int, String> _meses = {
    1: '01',
    2: '02',
    3: '03',
    4: '04',
    5: '05',
    6: '06',
    7: '07',
    8: '08',
    9: '09',
    10: '10',
    11: '11',
    12: '12'
  };

  Future<Uint8List> generate(
    Map<String, dynamic> dataPaquete,
    DateTime inicioSemana,
  ) async {
    WidgetsFlutterBinding.ensureInitialized();

    final config = dataPaquete['config'] as ConfigSetting?;
    final items = dataPaquete['items'] as List<ReporteDataDTO>;

    final fontRegular = pw.Font.courier();
    final fontBold = pw.Font.courierBold();
    final fontItalic = pw.Font.courierOblique();
    final fontBoldItalic = pw.Font.courierBoldOblique();

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      italic: fontItalic,
      boldItalic: fontBoldItalic,
      icons: fontRegular,
    );

    final pdf = pw.Document(theme: theme);

    const pageFormat = PdfPageFormat(
        21.0 * PdfPageFormat.cm, 29.7 * PdfPageFormat.cm,
        marginAll: 1.5 * PdfPageFormat.cm);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return [
            pw.DefaultTextStyle(
              style: pw.TextStyle(font: fontRegular, fontSize: 10),
              child: pw.Column(
                children: [
                  _buildHeader(config, inicioSemana, fontBold, fontRegular),
                  pw.SizedBox(height: 10),
                  if (items.isEmpty)
                    pw.Center(
                        child: pw.Text("SIN ACTIVIDADES PROGRAMADAS",
                            style: pw.TextStyle(font: fontBold, fontSize: 18)))
                  else
                    pw.Column(
                      children: items
                          .map((item) => pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 12),
                                child: _buildActivityCard(
                                    item, fontRegular, fontBold, fontItalic),
                              ))
                          .toList(),
                    ),
                  pw.SizedBox(height: 15),
                  _buildFooter(config, fontRegular),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  String _clean(String input) {
    var text = input.toUpperCase();
    text = text
        .replaceAll('Á', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ñ', 'N');
    return text;
  }

  String _formatDate(DateTime date) {
    final diaNombre = _diasSemana[date.weekday] ?? 'DIA';
    final diaNum = date.day.toString().padLeft(2, '0');
    return "$diaNombre $diaNum";
  }

  pw.Widget _buildHeader(ConfigSetting? config, DateTime inicio,
      pw.Font fontBold, pw.Font fontRegular) {
    final fin = inicio.add(const Duration(days: 6));
    final diaInicio = inicio.day.toString().padLeft(2, '0');
    final diaFin = fin.day.toString().padLeft(2, '0');
    final mes = _meses[fin.month] ?? '01';
    final anio = fin.year.toString();

    final textoPeriodo = "PERIODO $diaInicio-$diaFin-$mes-$anio";
    final rangoJefe = _clean(config?.rangoJefe ?? "");
    final nombreJefe = _clean(config?.nombreJefe ?? "ADMINISTRADOR");
    final apellidoJefe = _clean(config?.apellidoJefe ?? "");
    final datosJefe = "$rangoJefe $nombreJefe $apellidoJefe".trim();
    final nombreSector = _clean(config?.sectorNombre ?? "INPARQUES");

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(datosJefe, style: pw.TextStyle(font: fontBold, fontSize: 14)),
        pw.Text(nombreSector,
            style: pw.TextStyle(font: fontRegular, fontSize: 12)),
        pw.Divider(thickness: 1, height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("ROL DE GUARDIAS",
                style: pw.TextStyle(font: fontBold, fontSize: 16)),
            pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: pw.BorderRadius.circular(4)),
              child: pw.Text(textoPeriodo, style: pw.TextStyle(font: fontBold)),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildActivityCard(ReporteDataDTO item, pw.Font fontReg,
      pw.Font fontBold, pw.Font fontItalic) {
    final fecha = _formatDate(item.actividad.fecha);
    final esPernocta = item.actividad.esPernocta;

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey600),
        borderRadius: pw.BorderRadius.circular(4),
        color: esPernocta ? PdfColors.grey100 : PdfColors.white,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(children: [
            pw.Text("FECHA: ",
                style: pw.TextStyle(font: fontBold, fontSize: 10)),
            pw.Text(fecha, style: pw.TextStyle(font: fontReg, fontSize: 10)),
            if (esPernocta) ...[
              pw.SizedBox(width: 10),
              pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                color: PdfColors.black,
                child: pw.Text("PERNOCTA",
                    style: pw.TextStyle(
                        font: fontBold, color: PdfColors.white, fontSize: 8)),
              )
            ]
          ]),
          pw.SizedBox(height: 2),
          pw.Row(children: [
            pw.Text("ACTIVIDAD: ",
                style: pw.TextStyle(font: fontBold, fontSize: 10)),
            pw.Text(_clean(item.tipoNombre),
                style: pw.TextStyle(font: fontReg, fontSize: 10)),
          ]),
          pw.SizedBox(height: 2),
          if (item.actividad.nombreActividad.isNotEmpty)
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text("DETALLE: ",
                  style: pw.TextStyle(font: fontBold, fontSize: 10)),
              pw.Expanded(
                  child: pw.Text(_clean(item.actividad.nombreActividad),
                      style: pw.TextStyle(font: fontItalic, fontSize: 10))),
            ]),
          pw.SizedBox(height: 2),
          pw.Row(children: [
            pw.Text("LUGAR: ",
                style: pw.TextStyle(font: fontBold, fontSize: 10)),
            pw.Text(_clean(item.actividad.lugar),
                style: pw.TextStyle(font: fontReg, fontSize: 10)),
          ]),
          pw.Divider(height: 8, thickness: 0.5, color: PdfColors.grey400),
          if (item.jefeServicio != null)
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.SizedBox(
                  width: 120,
                  child: pw.Text("JEFE DE SERVICIO:",
                      style: pw.TextStyle(font: fontBold, fontSize: 10))),
              pw.Expanded(
                  child: pw.Text(_formatFuncionario(item.jefeServicio!),
                      style: pw.TextStyle(font: fontReg, fontSize: 10))),
            ]),
          if (item.funcionarios.any((f) => f.id != item.jefeServicio?.id)) ...[
            pw.SizedBox(height: 4),
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.SizedBox(
                  width: 120,
                  child: pw.Text("PERSONAL ASIGNADO:",
                      style: pw.TextStyle(font: fontBold, fontSize: 10))),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: item.funcionarios
                      .where((f) => f.id != item.jefeServicio?.id)
                      .map((f) => pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 2),
                          child: pw.Text("- ${_formatFuncionario(f)}",
                              style:
                                  pw.TextStyle(font: fontReg, fontSize: 10))))
                      .toList(),
                ),
              ),
            ]),
          ]
        ],
      ),
    );
  }

  String _formatFuncionario(Funcionario f) {
    final r = f.rango ?? "";
    final n = f.nombres;
    final a = f.apellidos;
    // Eliminado el check de 'is not null' innecesario para cedula ya que es un String robusto
    final cedulaTexto = " (C.I. ${f.cedula})";
    return _clean("$r $n $a$cedulaTexto").trim();
  }

  pw.Widget _buildFooter(ConfigSetting? config, pw.Font font) {
    final nombreJefeCompleto = _clean(
        "${config?.nombreJefe ?? 'ADMINISTRADOR'} ${config?.apellidoJefe ?? ''}"
            .trim());
    final cargoJefe = _clean((config?.jefeCargo ?? "JEFE DE SECTOR"));

    return pw.Column(
      children: [
        pw.Divider(thickness: 1),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("ELABORADO POR:",
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.SizedBox(height: 25),
                  pw.Text(nombreJefeCompleto,
                      style: pw.TextStyle(
                          font: font,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10)),
                  pw.Text(cargoJefe,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
            ),
            pw.SizedBox(width: 40),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("RECIBIDO POR:",
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.SizedBox(height: 25),
                  pw.Container(height: 1, color: PdfColors.black),
                  pw.Text("FECHA Y HORA",
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
```

## File: lib/src/features/reports/presentation/screens/report_config_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

// RUTAS RELATIVAS CORREGIDAS
import '../../../planning/logic/planning_controller.dart';
import '../../logic/pdf_generator_service.dart';

class ReportConfigScreen extends StatefulWidget {
  const ReportConfigScreen({super.key});

  @override
  State<ReportConfigScreen> createState() => _ReportConfigScreenState();
}

class _ReportConfigScreenState extends State<ReportConfigScreen> {
  // 0 = Semanal, 1 = Mensual
  int _reportTypeIndex = 0;

  // Variables Semanal
  DateTime _inicioSemana =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  // Variables Mensual
  DateTime _mesSeleccionado = DateTime.now();

  bool _isGenerating = false;

  final PdfGeneratorService _pdfService = PdfGeneratorService();

  Future<void> _generarYPrevisualizar() async {
    setState(() => _isGenerating = true);
    try {
      final controller = context.read<PlanningController>();

      // Lógica según tipo
      if (_reportTypeIndex == 0) {
        // --- REPORTE SEMANAL ---
        final data = await controller.generarPaqueteReporte(_inicioSemana);
        final config = data['config'];
        final items = data['items'] as List<ReporteDataDTO>;

        if (items.isEmpty && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("No hay actividades ordinarias en esta semana."),
              backgroundColor: Colors.orange));
        }

        final pdfBytes = await _pdfService.generateWeeklyReport(
          config: config,
          items: items,
          inicioSemana: _inicioSemana,
        );

        if (mounted) {
          await Printing.layoutPdf(
            onLayout: (format) async => pdfBytes,
            name:
                'Rol_Semanal_${DateFormat('dd-MM').format(_inicioSemana)}.pdf',
          );
        }
      } else {
        // --- REPORTE MENSUAL (PERNOCTAS) ---
        final data = await controller.generarReporteMensualPernoctas(
            _mesSeleccionado.year, _mesSeleccionado.month);
        final config = data['config'];
        final items = data['items'] as List<ReporteDataDTO>;

        if (items.isEmpty && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("No hay pernoctas en este mes."),
              backgroundColor: Colors.orange));
        }

        final pdfBytes = await _pdfService.generateMonthlyReport(
          config: config,
          items: items,
          month: _mesSeleccionado.month,
          year: _mesSeleccionado.year,
        );

        if (mounted) {
          await Printing.layoutPdf(
            onLayout: (format) async => pdfBytes,
            name:
                'Pernoctas_${DateFormat('MM-yyyy').format(_mesSeleccionado)}.pdf',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error generando PDF: $e"),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  void _seleccionarSemana() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _inicioSemana,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      helpText: "Seleccione un día (se ajustará al Lunes)",
    );
    if (picked != null) {
      setState(() {
        _inicioSemana = picked.subtract(Duration(days: picked.weekday - 1));
      });
    }
  }

  void _cambiarMes(int delta) {
    setState(() {
      _mesSeleccionado =
          DateTime(_mesSeleccionado.year, _mesSeleccionado.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekEnd = _inicioSemana.add(const Duration(days: 6));

    return Scaffold(
      appBar: AppBar(title: const Text("Generar Reportes PDF")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Selector de Tipo
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                    value: 0,
                    label: Text("Semanal (Ordinaria)"),
                    icon: Icon(Icons.calendar_view_week)),
                ButtonSegment(
                    value: 1,
                    label: Text("Mensual (Pernocta)"),
                    icon: Icon(Icons.calendar_month)),
              ],
              selected: {_reportTypeIndex},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() => _reportTypeIndex = newSelection.first);
              },
            ),
            const SizedBox(height: 30),

            // 2. Controles de Fecha (Dinámicos)
            if (_reportTypeIndex == 0) ...[
              // Controles SEMANAL
              Text("Seleccione la Semana:",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              InkWell(
                onTap: _seleccionarSemana,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Desde: ${DateFormat('dd/MM/yyyy').format(_inicioSemana)}"),
                          Text(
                              "Hasta: ${DateFormat('dd/MM/yyyy').format(weekEnd)}"),
                        ],
                      ),
                      const Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Controles MENSUAL
              Text("Seleccione el Mes:",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => _cambiarMes(-1),
                        icon: const Icon(Icons.chevron_left)),
                    Text(
                      DateFormat('MMMM yyyy', 'es')
                          .format(_mesSeleccionado)
                          .toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () => _cambiarMes(1),
                        icon: const Icon(Icons.chevron_right)),
                  ],
                ),
              )
            ],

            const Spacer(),

            // 3. Botón de Acción
            SizedBox(
              height: 55,
              child: FilledButton.icon(
                onPressed: _isGenerating ? null : _generarYPrevisualizar,
                icon: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.print),
                label: Text(
                    _isGenerating ? "Generando..." : "VISUALIZAR E IMPRIMIR"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## File: lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 1. Librería visual
import 'package:intl/date_symbol_data_local.dart'; // 2. NECESARIO PARA EL CALENDARIO

// Importaciones de datos
import 'src/data/local/app_database.dart';

// Importaciones de Lógica (Controllers)
import 'src/features/auth/logic/auth_controller.dart';
import 'src/features/personal/logic/personal_controller.dart';
import 'src/features/planning/logic/planning_controller.dart';
import 'src/features/dashboard/logic/dashboard_controller.dart';
import 'src/features/planning/logic/config_types_controller.dart';
import 'src/features/calendar/logic/calendar_controller.dart';
import 'src/features/incidents/logic/incidents_controller.dart';

// Importaciones de Pantallas (Screens)
import 'src/features/auth/presentation/screens/login_screen.dart';
import 'src/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'src/features/personal/presentation/screens/personal_list_screen.dart';
import 'src/features/planning/presentation/screens/planning_screen.dart';
import 'src/features/planning/presentation/screens/create_activity_screen.dart';
import 'src/features/planning/presentation/screens/actividad_form_screen.dart';
import 'src/features/planning/presentation/screens/config_types_screen.dart';
import 'src/features/calendar/presentation/screens/vacation_setup_screen.dart';
import 'src/features/incidents/presentation/screens/report_incident_screen.dart';
import 'src/features/config/presentation/screens/backup_screen.dart';

void main() async {
  // <--- Convertir main a async
  WidgetsFlutterBinding.ensureInitialized();

  // 3. INICIALIZAR FORMATOS DE FECHA EN ESPAÑOL ANTES DE ARRANCAR
  await initializeDateFormatting('es_ES', null);

  // Instancia única de la base de datos
  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider(create: (_) => AuthController(database)),
        ChangeNotifierProvider(create: (_) => PersonalController(database)),
        ChangeNotifierProvider(create: (_) => PlanningController(database)),
        ChangeNotifierProvider(create: (_) => DashboardController(database)),
        ChangeNotifierProvider(create: (_) => ConfigTypesController(database)),
        ChangeNotifierProvider(create: (_) => CalendarController(database)),
        ChangeNotifierProvider(create: (_) => IncidentsController(database)),
      ],
      child: const InparquesApp(),
    ),
  );
}

class InparquesApp extends StatelessWidget {
  const InparquesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Gestión - Inparques',

      // CONFIGURACIÓN DE IDIOMA
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español España
        Locale('es', 'VE'), // Español Venezuela
      ],
      locale: const Locale('es', 'ES'), // Forzar Español

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF1B5E20),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/personal': (context) => const PersonalListScreen(),
        '/planning': (context) => const PlanningScreen(),
        '/create_activity': (context) => const CreateActivityScreen(),
        '/actividad_form': (context) => const ActividadFormScreen(),
        '/config_types': (context) => const ConfigTypesScreen(),
        '/vacations': (context) => const VacationSetupScreen(),
        '/report_incident': (context) => const ReportIncidentScreen(),
        '/backup': (context) => const BackupScreen(),
      },
    );
  }
}
```

## File: pubspec.yaml
```yaml
name: inparques
description: "Sistema de Gestion de Guardias Inparques"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.1.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # Gestión de Estado
  provider: ^6.1.1

  # Base de Datos Local
  drift: ^2.20.0
  sqlite3_flutter_libs: ^0.5.20
  path_provider: ^2.1.2
  path: ^1.8.3

  # Utilidades
  intl: ^0.20.2
  
  # Archivos y PDF
  file_picker: ^8.0.0 
  url_launcher: ^6.2.5
  pdf: ^3.10.0
  printing: ^5.11.0
  image_picker: ^1.2.1
  archive: ^4.0.7
  share_plus: ^12.0.1
  collection: ^1.19.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  
  # Generación de Código
  build_runner: ^2.4.8
  drift_dev: ^2.20.0

flutter:
  uses-material-design: true

  # ⚠️ SECCIÓN CRÍTICA AGREGADA PARA CORREGIR EL ERROR "UNABLE TO LOAD ASSET"
  # Asegúrate de que las carpetas existan físicamente en tu proyecto.
  assets:
    - assets/images/
    - assets/database/
```
