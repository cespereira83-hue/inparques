import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../../data/local/app_database.dart';
import '../../../core/utils/file_helper.dart'; // INYECTAMOS EL HELPER

class BackupController extends ChangeNotifier {
  final AppDatabase db;

  BackupController(this.db);

  Future<File> _getDatabaseFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return File(p.join(dbFolder.path, 'db.sqlite'));
  }

  /// EXPORTAR: Guarda la base de datos en la carpeta pública INPARQUES y la comparte
  Future<String?> exportarBaseDeDatos() async {
    try {
      final dbFile = await _getDatabaseFile();

      if (!await dbFile.exists()) {
        throw Exception("Archivo de base de datos no encontrado");
      }

      final String fecha = DateFormat('yyyy-MM-dd_HHmm').format(DateTime.now());
      final String nombreArchivo = "Respaldo_INPARQUES_$fecha.sqlite";

      // 1. Obtenemos nuestra carpeta pública mágica
      final rutaCarpeta = await FileHelper.obtenerCarpetaPublicaInparques();
      final rutaDestino = p.join(rutaCarpeta, nombreArchivo);

      // 2. Copiamos el archivo de la BD oculta a la carpeta pública
      await dbFile.copy(rutaDestino);

      // 3. Abrimos el menú de compartir (WhatsApp, Telegram, etc.)
      await FileHelper.compartirArchivo(rutaDestino, nombreArchivo);

      return rutaDestino;
    } catch (e) {
      rethrow;
    }
  }

  /// IMPORTAR: Se mantiene igual (usando FilePicker para buscar la copia vieja)
  Future<bool> importarBaseDeDatos() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        dialogTitle: 'Seleccione el archivo de respaldo (.sqlite)',
      );

      if (result != null && result.files.single.path != null) {
        final nuevoArchivo = File(result.files.single.path!);
        final dbFile = await _getDatabaseFile();

        await db.close();
        await nuevoArchivo.copy(dbFile.path);

        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
