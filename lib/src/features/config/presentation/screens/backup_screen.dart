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
