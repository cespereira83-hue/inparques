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
