import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../data/local/app_database.dart';
import '../../../auth/logic/auth_controller.dart';

class EditConfigScreen extends StatefulWidget {
  const EditConfigScreen({super.key});

  @override
  State<EditConfigScreen> createState() => _EditConfigScreenState();
}

class _EditConfigScreenState extends State<EditConfigScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores Geográficos
  late TextEditingController _parqueController;
  late TextEditingController _sectorController;
  late TextEditingController _ciudadController;
  late TextEditingController _municipioController;
  late TextEditingController _estadoController;

  // Controladores de Autoridad
  late TextEditingController _jefeNombreController;
  late TextEditingController _jefeApellidoController;
  late TextEditingController _jefeRangoController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Cargamos los datos actuales desde el AuthController
    final auth = context.read<AuthController>();
    final config = auth.config;

    _parqueController = TextEditingController(text: config?.parqueNombre ?? '');
    _sectorController = TextEditingController(text: config?.sectorNombre ?? '');
    _ciudadController = TextEditingController(text: config?.ciudad ?? '');
    _municipioController = TextEditingController(text: config?.municipio ?? '');
    _estadoController = TextEditingController(text: config?.estado ?? '');

    _jefeNombreController =
        TextEditingController(text: config?.nombreJefe ?? '');
    _jefeApellidoController =
        TextEditingController(text: config?.apellidoJefe ?? '');
    _jefeRangoController = TextEditingController(text: config?.rangoJefe ?? '');
  }

  @override
  void dispose() {
    _parqueController.dispose();
    _sectorController.dispose();
    _ciudadController.dispose();
    _municipioController.dispose();
    _estadoController.dispose();
    _jefeNombreController.dispose();
    _jefeApellidoController.dispose();
    _jefeRangoController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final auth = context.read<AuthController>();
      final currentConfig = auth.config;
      final db = context.read<AppDatabase>();

      if (currentConfig != null) {
        // Actualizamos directamente en Drift usando los nuevos campos V14
        await (db.update(db.configSettings)
              ..where((t) => t.id.equals(currentConfig.id)))
            .write(
          ConfigSettingsCompanion(
            parqueNombre: drift.Value(_parqueController.text.trim()),
            sectorNombre: drift.Value(_sectorController.text.trim()),
            ciudad: drift.Value(_ciudadController.text.trim()),
            municipio: drift.Value(_municipioController.text.trim()),
            estado: drift.Value(_estadoController.text.trim()),
            nombreJefe: drift.Value(_jefeNombreController.text.trim()),
            apellidoJefe: drift.Value(_jefeApellidoController.text.trim()),
            rangoJefe: drift.Value(_jefeRangoController.text.trim()),
          ),
        );

        // Refrescamos el estado global para que el menú y los PDF se enteren del cambio
        await auth.checkInitialSetup();
      }

      // Validamos que el widget siga montado antes de usar el context (Corrección Linter)
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Datos actualizados correctamente"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al guardar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Editar Datos del Sector"),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- SECCIÓN 1: UBICACIÓN ---
                      _buildSectionTitle("Ubicación y Jurisdicción", Icons.map),
                      const SizedBox(height: 16),
                      _buildTextField(_parqueController,
                          "Parque Nacional / Recreacional", Icons.park),
                      _buildTextField(
                          _sectorController, "Nombre del Sector", Icons.flag),
                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField(_ciudadController,
                                  "Ciudad", Icons.location_city)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildTextField(_municipioController,
                                  "Municipio", Icons.explore)),
                        ],
                      ),
                      _buildTextField(
                          _estadoController, "Estado", Icons.public),

                      const Divider(height: 40),

                      // --- SECCIÓN 2: AUTORIDAD ---
                      _buildSectionTitle(
                          "Autoridad Responsable", Icons.admin_panel_settings),
                      const SizedBox(height: 16),
                      _buildTextField(_jefeNombreController, "Nombres del Jefe",
                          Icons.person),
                      _buildTextField(_jefeApellidoController,
                          "Apellidos del Jefe", Icons.person_outline),
                      _buildTextField(_jefeRangoController, "Rango / Grado",
                          Icons.military_tech),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: _isSaving ? null : _guardarCambios,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.save),
                          label: Text(
                              _isSaving ? "Guardando..." : "GUARDAR CAMBIOS",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade800),
        const SizedBox(width: 8),
        Text(title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900)),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (v) => v!.trim().isEmpty ? "Requerido" : null,
      ),
    );
  }
}
