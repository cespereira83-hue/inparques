import 'dart:io'; // ¡ESTA ES LA LÍNEA QUE FALTABA PARA EL EXIT!
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/backup_controller.dart'; // ¡RUTA CORREGIDA!

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _isProcessing = false;

  Future<void> _handleExport() async {
    setState(() => _isProcessing = true);
    try {
      final backupCtrl = context.read<BackupController>();
      final path = await backupCtrl.exportarBaseDeDatos();

      if (!mounted) return;

      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("✅ Respaldo creado en: $path"),
              backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleImport() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("¿Restaurar Base de Datos?"),
        content: const Text(
            "Esta acción reemplazará TODOS los datos actuales por los del archivo seleccionado. La aplicación se cerrará para completar el proceso.\n\n⚠️ Esta acción no se puede deshacer."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancelar")),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Restaurar ahora")),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isProcessing = true);
    try {
      final backupCtrl = context.read<BackupController>();
      final success = await backupCtrl.importarBaseDeDatos();

      if (!mounted) return;

      if (success) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text("Restauración Exitosa"),
            content: const Text(
                "La base de datos ha sido reemplazada. La aplicación debe cerrarse para cargar los nuevos datos."),
            actions: [
              FilledButton(
                  onPressed: () => exit(0), // ESTO REQUIERE DART:IO
                  child: const Text("Cerrar Aplicación")),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("❌ Error durante la importación: $e"),
            backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Respaldos y Seguridad"),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.storage, size: 80, color: Colors.blueGrey),
                const SizedBox(height: 24),
                const Text(
                  "Gestión de Base de Datos",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Utilice estas opciones para mover sus datos a otro equipo o guardar copias de seguridad externas.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Botón Exportar
                _BackupCard(
                  title: "Crear Copia de Seguridad",
                  subtitle:
                      "Exporta un archivo .sqlite con toda la información.",
                  icon: Icons.unarchive,
                  color: Colors.green.shade700,
                  onTap: _isProcessing ? null : _handleExport,
                ),

                const SizedBox(height: 20),

                // Botón Importar
                _BackupCard(
                  title: "Restaurar Copia de Seguridad",
                  subtitle: "Carga datos desde un archivo externo.",
                  icon: Icons.archive,
                  color: Colors.orange.shade800,
                  onTap: _isProcessing ? null : _handleImport,
                ),

                if (_isProcessing) ...[
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  const Text("Procesando archivos..."),
                ]
              ],
            ),
          ),
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
  final VoidCallback? onTap;

  const _BackupCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
