import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileHelper {
  /// Crea o localiza la carpeta pública INPARQUES_Archivos en Documentos
  static Future<String> obtenerCarpetaPublicaInparques() async {
    Directory directorioDestino;

    if (Platform.isAndroid) {
      // Ruta pública universal para Documentos en Android
      directorioDestino =
          Directory('/storage/emulated/0/Documents/INPARQUES_Archivos');
    } else {
      // Ruta de Documentos en Linux/Windows
      final dirDocs = await getApplicationDocumentsDirectory();
      directorioDestino = Directory('${dirDocs.path}/INPARQUES_Archivos');
    }

    // Si la carpeta no existe en el sistema, la creamos
    if (!await directorioDestino.exists()) {
      await directorioDestino.create(recursive: true);
    }

    return directorioDestino.path;
  }

  /// Lanza el menú nativo para compartir el archivo en WhatsApp, Telegram, etc.
  static Future<void> compartirArchivo(
      String rutaArchivo, String nombreArchivo) async {
    try {
      final archivo = File(rutaArchivo);
      if (!await archivo.exists()) {
        debugPrint("Error: El archivo no existe en la ruta $rutaArchivo");
        return;
      }

      // Convertimos el archivo al formato que exige share_plus
      final xFile = XFile(rutaArchivo);

      // Lanzamos la ventana nativa de Android/Linux
      await Share.shareXFiles(
        [xFile],
        text: 'Documento INPARQUES: $nombreArchivo',
      );
    } catch (e) {
      debugPrint("Error al intentar compartir el archivo: $e");
    }
  }
}
