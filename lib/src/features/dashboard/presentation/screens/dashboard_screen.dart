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
        // MODIFICACIÓN: Logo en el AppBar con manejo de overflow
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo_inparques.png',
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.park), // Fallback de seguridad
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                "Sistema Inparques",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
        int columnas = 2;
        double anchoMaximo = double.infinity;

        if (constraints.maxWidth > 900) {
          columnas = 4;
          anchoMaximo = 1000;
        } else if (constraints.maxWidth > 600) {
          columnas = 3;
          anchoMaximo = 800;
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: anchoMaximo),
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
                          crossAxisCount: columnas,
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
                // Si tienes un pattern, genial. Si no, se ignorará sin crashear.
                image: AssetImage('assets/images/pattern.png'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MODIFICACIÓN: Logo de INPARQUES en el Drawer en lugar del Icon(Icons.park)
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(
                        4.0), // Pequeño margen interno para que respire
                    child: Image.asset(
                      'assets/images/logo_inparques.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.park, size: 40, color: Colors.green),
                    ),
                  ),
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
            maxLines: 1,
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
