import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_controller.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key});

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores Geográficos
  final _parqueController = TextEditingController();
  final _sectorController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _municipioController = TextEditingController();
  final _estadoController = TextEditingController();

  // Controladores Autoridad y Seguridad
  final _jefeNombreController = TextEditingController();
  final _jefeApellidoController = TextEditingController();
  final _jefeRangoController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _claveController = TextEditingController();
  final _preguntaController = TextEditingController();
  final _respuestaController = TextEditingController();

  bool _isSaving = false;

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
    _usuarioController.dispose();
    _claveController.dispose();
    _preguntaController.dispose();
    _respuestaController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await context.read<AuthController>().saveInitialConfig(
            parqueNombre: _parqueController.text,
            sectorNombre: _sectorController.text,
            ciudad: _ciudadController.text,
            municipio: _municipioController.text,
            estado: _estadoController.text,
            jefeNombre: _jefeNombreController.text,
            jefeApellido: _jefeApellidoController.text,
            jefeRango: _jefeRangoController.text,
            usuario: _usuarioController.text,
            password: _claveController.text,
            preguntaSeguridad: _preguntaController.text,
            respuestaSeguridad: _respuestaController.text,
          );
      // Al guardar exitosamente, el InitialRouter detectará el cambio y redirigirá al Login
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error al guardar: $e"),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text("Configuración de INPARQUES")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Icon(Icons.settings_suggest,
                          size: 64, color: Colors.green),
                      const SizedBox(height: 16),
                      const Text(
                        "Primer Arranque del Sistema",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),

                      // --- SECCIÓN 1: UBICACIÓN GEOGRÁFICA ---
                      _buildSectionTitle("Ubicación y Jurisdicción"),
                      _buildTextField(_parqueController,
                          "Nombre del Parque (Ej. Sierra Nevada)", Icons.park),
                      _buildTextField(_sectorController,
                          "Nombre del Sector (Ej. La Mucuy)", Icons.map),
                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField(_ciudadController,
                                  "Ciudad", Icons.location_city)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _buildTextField(_municipioController,
                                  "Municipio", Icons.explore)),
                        ],
                      ),
                      _buildTextField(
                          _estadoController, "Estado", Icons.public),

                      const SizedBox(height: 24),

                      // --- SECCIÓN 2: AUTORIDAD ---
                      _buildSectionTitle("Autoridad Responsable"),
                      _buildTextField(_jefeNombreController, "Nombre del Jefe",
                          Icons.person),
                      _buildTextField(_jefeApellidoController,
                          "Apellido del Jefe", Icons.person_outline),
                      _buildTextField(
                          _jefeRangoController,
                          "Rango Militar/Civil (Ej. GP/.)",
                          Icons.military_tech),

                      const SizedBox(height: 24),

                      // --- SECCIÓN 3: SEGURIDAD ---
                      _buildSectionTitle("Seguridad del Sistema"),
                      _buildTextField(_usuarioController,
                          "Usuario Administrador", Icons.admin_panel_settings),
                      _buildTextField(
                          _claveController, "Clave Maestra", Icons.lock,
                          isPassword: true),

                      const SizedBox(height: 24),

                      // --- SECCIÓN 4: RECUPERACIÓN ---
                      _buildSectionTitle("Recuperación Offline"),
                      _buildTextField(
                          _preguntaController,
                          "Pregunta Secreta (Para recuperar clave)",
                          Icons.help),
                      _buildTextField(
                          _respuestaController, "Respuesta", Icons.vpn_key),

                      const SizedBox(height: 48),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: _isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text("CONFIGURAR Y CONTINUAR",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
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

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green)),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (v) =>
            v!.trim().isEmpty ? "Este campo es obligatorio" : null,
      ),
    );
  }
}
