import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioController = TextEditingController();
  final _claveController = TextEditingController();

  // Variables de estado local exigidas por el Skill (Manejo de Estado y Errores)
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _usuarioController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final usuario = _usuarioController.text.trim();
    final password = _claveController.text.trim();

    if (usuario.isEmpty || password.isEmpty) {
      _mostrarSnackBar("Por favor, ingrese usuario y contraseña",
          esError: true);
      return;
    }

    // Bloqueamos la UI mientras el controlador consulta a Drift
    setState(() => _isLoading = true);

    try {
      // Regla de Arquitectura 1: Comunicación exclusiva a través del Controller
      final authController = context.read<AuthController>();
      final exito = await authController.login(usuario, password);

      // Verificación de montaje exigida por el Skill
      if (!mounted) return;

      if (exito) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        _mostrarSnackBar("Usuario o contraseña incorrectos", esError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarSnackBar("Error interno al conectar con el servicio local",
          esError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarSnackBar(String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red.shade800 : Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Regla de UI/UX: Responsividad y protección de Notches en móviles
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Regla de UI/UX: Identidad Gráfica con Fallback Seguro
                  Center(
                    child: Image.asset(
                      'assets/images/logo_inparques.png',
                      height: 140,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.park,
                            size: 100, color: Color(0xFF2E7D32));
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Sistema Inparques",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Gestión de Personal y Guardias",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Campo de Usuario
                  TextFormField(
                    controller: _usuarioController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: "Usuario",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Campo de Contraseña
                  TextFormField(
                    controller: _claveController,
                    enabled: !_isLoading,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: const Icon(Icons.lock_outline),
                      // Regla de UI/UX: Seguridad Visual (Toggle View)
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: _isLoading
                            ? null
                            : () =>
                                setState(() => _obscureText = !_obscureText),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onFieldSubmitted: (_) => _handleLogin(),
                  ),
                  const SizedBox(height: 40),

                  // Botón de Inicio de Sesión
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "INICIAR SESIÓN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Enlaces a los otros flujos del Skill (Recuperación y Registro)
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.pushNamed(context, '/recovery'),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.shade700),
                    child:
                        const Text("¿Olvidó su contraseña? Recuperar acceso"),
                  ),
                  const Divider(height: 32),
                  OutlinedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.pushNamed(context, '/register'),
                    icon: const Icon(Icons.person_add_alt_1, size: 20),
                    label: const Text("Crear cuenta de Operador"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      side: const BorderSide(color: Color(0xFF2E7D32)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
