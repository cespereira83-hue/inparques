import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _claveController = TextEditingController();
  final _confirmarClaveController = TextEditingController();
  final _preguntaController = TextEditingController();
  final _respuestaController = TextEditingController();

  // NUEVO CONTROALDOR: Autorización del Administrador
  final _claveAdminController = TextEditingController();

  bool _isRegistering = false;
  bool _obscureText = true;
  bool _obscureAdminText = true;

  @override
  void dispose() {
    _usuarioController.dispose();
    _claveController.dispose();
    _confirmarClaveController.dispose();
    _preguntaController.dispose();
    _respuestaController.dispose();
    _claveAdminController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_claveController.text != _confirmarClaveController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Las contraseñas no coinciden"),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isRegistering = true);

    try {
      final authController = context.read<AuthController>();

      // Enviamos todos los datos incluyendo la clave de autorización
      final error = await authController.registrarUsuario(
        usuario: _usuarioController.text,
        password: _claveController.text,
        pregunta: _preguntaController.text,
        respuesta: _respuestaController.text,
        claveAdmin: _claveAdminController.text, // Validación de seguridad
      );

      if (!mounted) return;

      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Usuario creado y autorizado exitosamente."),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red.shade800),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error inesperado al registrar."),
            backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Registrar Nuevo Operador"),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.shield_outlined,
                      size: 64, color: Color(0xFF2E7D32)),
                  const SizedBox(height: 16),
                  const Text(
                    "Crear cuenta de Operador",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // DATOS DE ACCESO
                  TextFormField(
                    controller: _usuarioController,
                    enabled: !_isRegistering,
                    decoration: const InputDecoration(
                      labelText: "Nombre de Usuario",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => v!.trim().isEmpty ? "Requerido" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _claveController,
                    enabled: !_isRegistering,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? "Requerido" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmarClaveController,
                    enabled: !_isRegistering,
                    obscureText: _obscureText,
                    decoration: const InputDecoration(
                      labelText: "Confirmar Contraseña",
                      prefixIcon: Icon(Icons.lock_clock),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Confirme la contraseña" : null,
                  ),

                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Divider()),

                  // SEGURIDAD DE RECUPERACIÓN
                  const Text(
                    "SEGURIDAD DE RECUPERACIÓN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _preguntaController,
                    enabled: !_isRegistering,
                    decoration: const InputDecoration(
                      labelText: "Pregunta Secreta (Ej. Color favorito)",
                      prefixIcon: Icon(Icons.help_outline),
                    ),
                    validator: (v) => v!.trim().isEmpty ? "Requerido" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _respuestaController,
                    enabled: !_isRegistering,
                    decoration: const InputDecoration(
                      labelText: "Respuesta a la pregunta",
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                    ),
                    validator: (v) => v!.trim().isEmpty ? "Requerido" : null,
                  ),

                  const SizedBox(height: 32),

                  // BLOQUE DE AUTORIZACIÓN (LA SOLUCIÓN AL FALLO)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.red.shade200, width: 2)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.admin_panel_settings,
                                color: Colors.red.shade800),
                            const SizedBox(width: 8),
                            Text("AUTORIZACIÓN REQUERIDA",
                                style: TextStyle(
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Para crear este usuario, el Jefe de Sector debe autorizarlo ingresando su contraseña maestra.",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _claveAdminController,
                          enabled: !_isRegistering,
                          obscureText: _obscureAdminText,
                          decoration: InputDecoration(
                            labelText: "Clave de Administrador",
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon:
                                Icon(Icons.key, color: Colors.red.shade700),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureAdminText
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () => setState(
                                  () => _obscureAdminText = !_obscureAdminText),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.red.shade700, width: 2),
                            ),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? "Autorización obligatoria" : null,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isRegistering ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                      ),
                      child: _isRegistering
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("AUTORIZAR Y REGISTRAR",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
