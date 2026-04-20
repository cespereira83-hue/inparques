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
  // 2. CREACIÓN (CREATE) Y REACTIVACIÓN (SOFT DELETE BYPASS)
  // ==========================================================

  Future<void> registrarFuncionarioCompleto({
    required String nombres,
    required String apellidos,
    required String cedula,
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
    // Limpieza preventiva de la cédula
    final cedulaLimpia = cedula.replaceAll('.', '').trim();

    // 1. Verificamos si la cédula ya existe en el sistema
    final existente = await (_db.select(_db.funcionarios)
          ..where((t) => t.cedula.equals(cedulaLimpia)))
        .getSingleOrNull();

    if (existente != null) {
      if (existente.estaActivo == false) {
        // ESTÁ INACTIVO (Borrado lógicamente). Lo revivimos.
        await _db.transaction(() async {
          // Actualizamos sus datos y lo ponemos activo
          await (_db.update(_db.funcionarios)
                ..where((t) => t.id.equals(existente.id)))
              .write(
            FuncionariosCompanion(
              nombres: drift.Value(nombres.trim()),
              apellidos: drift.Value(apellidos.trim()),
              rango: drift.Value(rango),
              rangoId: drift.Value(rangoId),
              fechaNacimiento: drift.Value(fechaNacimiento),
              fechaIngreso: drift.Value(fechaIngreso),
              telefono: drift.Value(telefono?.trim()),
              diasLibresPreferidos: drift.Value(diasLibresPreferidos),
              fotoPath: drift.Value(fotoPath),
              estaActivo: const drift.Value(true),
            ),
          );

          // Borramos su historial viejo de relaciones
          await (_db.delete(_db.estudiosAcademicos)
                ..where((t) => t.funcionarioId.equals(existente.id)))
              .go();
          await (_db.delete(_db.cursosCertificados)
                ..where((t) => t.funcionarioId.equals(existente.id)))
              .go();
          await (_db.delete(_db.familiares)
                ..where((t) => t.funcionarioId.equals(existente.id)))
              .go();
          await (_db.delete(_db.hijos)
                ..where((t) => t.funcionarioId.equals(existente.id)))
              .go();

          // Insertamos las nuevas relaciones
          await _insertarRelaciones(
              existente.id, estudios, cursos, familiares, hijos);
        });

        notifyListeners();
        return; // Salimos exitosamente
      } else {
        // Está activo. Lanzamos un error amigable para la interfaz.
        throw Exception(
            "La cédula $cedulaLimpia ya se encuentra registrada y activa en el sistema.");
      }
    }

    // 2. Si no existe, hacemos la inserción normal
    try {
      await _db.transaction(() async {
        final funcionarioId = await _db.into(_db.funcionarios).insert(
              FuncionariosCompanion(
                nombres: drift.Value(nombres.trim()),
                apellidos: drift.Value(apellidos.trim()),
                cedula: drift.Value(cedulaLimpia),
                rango: drift.Value(rango),
                rangoId: drift.Value(rangoId),
                fechaNacimiento: drift.Value(fechaNacimiento),
                fechaIngreso: drift.Value(fechaIngreso),
                telefono: drift.Value(telefono?.trim()),
                diasLibresPreferidos: drift.Value(diasLibresPreferidos),
                fotoPath: drift.Value(fotoPath),
                estaActivo: const drift.Value(true),
              ),
            );

        await _insertarRelaciones(
            funcionarioId, estudios, cursos, familiares, hijos);
      });
      notifyListeners();
    } catch (e) {
      // CORRECCIÓN: Manejo universal de excepciones de SQLite
      final errorStr = e.toString();
      if (errorStr.contains('2067') ||
          errorStr.contains('UNIQUE constraint failed')) {
        throw Exception("Esta cédula ya está registrada en la base de datos.");
      }
      throw Exception("Error de base de datos: $errorStr");
    }
  }

  // ==========================================================
  // 3. ACTUALIZACIÓN (UPDATE) - IMPLEMENTACIÓN ROBUSTA
  // ==========================================================

  Future<void> actualizarFuncionarioCompleto({
    required int id,
    required String nombres,
    required String apellidos,
    required String cedula,
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
    final cedulaLimpia = cedula.replaceAll('.', '').trim();

    // CORRECCIÓN: Uso de .not() en lugar de isNot() para Drift
    final conflicto = await (_db.select(_db.funcionarios)
          ..where((t) => t.cedula.equals(cedulaLimpia) & t.id.equals(id).not()))
        .getSingleOrNull();

    if (conflicto != null) {
      throw Exception(
          "La cédula $cedulaLimpia ya está asignada a otro funcionario.");
    }

    await _db.transaction(() async {
      // 1. Actualizar Datos Básicos
      await (_db.update(_db.funcionarios)..where((t) => t.id.equals(id))).write(
        FuncionariosCompanion(
          nombres: drift.Value(nombres.trim()),
          apellidos: drift.Value(apellidos.trim()),
          cedula: drift.Value(cedulaLimpia),
          rango: drift.Value(rango),
          rangoId: drift.Value(rangoId),
          fechaNacimiento: drift.Value(fechaNacimiento),
          fechaIngreso: drift.Value(fechaIngreso),
          telefono: drift.Value(telefono?.trim()),
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
