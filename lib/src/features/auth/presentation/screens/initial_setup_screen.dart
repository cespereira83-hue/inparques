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
