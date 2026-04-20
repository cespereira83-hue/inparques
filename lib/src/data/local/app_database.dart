import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// --- NUEVA TABLA MULTIUSUARIO ---
class UsuariosSistema extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get usuario => text().unique()();
  TextColumn get password => text()();
  TextColumn get rol => text().withDefault(const Constant('Operador'))();

  // CAMBIO V13: Pregunta de seguridad por cada operador
  TextColumn get preguntaSeguridad => text().nullable()();
  TextColumn get respuestaSeguridad => text().nullable()();
}

// --- TABLAS DE CONFIGURACIÓN Y MAESTROS ---

class ConfigSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombreInstitucion =>
      text().withDefault(const Constant('INPARQUES'))();

  // CAMBIO V14: Ubicación Geográfica Detallada
  TextColumn get parqueNombre => text().nullable()();
  TextColumn get sectorNombre => text().nullable()();
  TextColumn get ciudad => text().nullable()();
  TextColumn get municipio => text().nullable()();
  TextColumn get estado => text().nullable()();

  TextColumn get nombreJefe => text()();
  TextColumn get apellidoJefe => text().nullable()();
  TextColumn get rangoJefe => text()();

  TextColumn get jefeCargo =>
      text().withDefault(const Constant('Jefe de Sector'))();
  TextColumn get usuario => text()();
  TextColumn get password => text()();

  TextColumn get preguntaSeguridad => text().nullable()();
  TextColumn get respuestaSeguridad => text().nullable()();
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
    UsuariosSistema,
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

  // VERSIÓN 14: Campos de Ubicación Geográfica
  @override
  int get schemaVersion => 14;

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
        if (from < 10) {
          await m.addColumn(configSettings, configSettings.nombreInstitucion);
          await m.addColumn(configSettings, configSettings.estado);
          await m.renameColumn(
              configSettings, 'jefe_nombre', configSettings.nombreJefe);
          await m.renameColumn(
              configSettings, 'jefe_apellido', configSettings.apellidoJefe);
          await m.renameColumn(
              configSettings, 'jefe_rango', configSettings.rangoJefe);
        }
        if (from < 11) {
          await m.addColumn(configSettings, configSettings.preguntaSeguridad);
          await m.addColumn(configSettings, configSettings.respuestaSeguridad);
        }
        if (from < 12) {
          await m.createTable(usuariosSistema);
        }
        if (from < 13) {
          await m.addColumn(usuariosSistema, usuariosSistema.preguntaSeguridad);
          await m.addColumn(
              usuariosSistema, usuariosSistema.respuestaSeguridad);
        }
        if (from < 14) {
          // V14: Nuevos campos de ubicación detallada
          await m.addColumn(configSettings, configSettings.parqueNombre);
          await m.addColumn(configSettings, configSettings.ciudad);
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
        parqueNombre: const Value('P.N. Gral. Juan Pablo Peñaloza'),
        sectorNombre: const Value('Bailadores'),
        ciudad: const Value('Bailadores'),
        municipio: const Value('Rivas Dávila'),
        estado: const Value('Mérida'),
        nombreJefe: 'Administrador',
        rangoJefe: 'GP/.',
        jefeCargo: const Value('Jefe de Sector'),
        usuario: 'admin',
        password: 'admin123',
        preguntaSeguridad: const Value('¿Año de fundación de Inparques?'),
        respuestaSeguridad: const Value('1973'),
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
    return NativeDatabase.createInBackground(file);
  });
}
