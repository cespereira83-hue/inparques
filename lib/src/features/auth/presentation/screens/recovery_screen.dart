import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_controller.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variables de Estado (2 Pasos)
  int _pasoActual = 1;
  String _preguntaEncontrada = '';

  // Controladores
  final _usuarioBusquedaController = TextEditingController();
  final _respuestaController = TextEditingController();
  final _nuevaClaveController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _usuarioBusquedaController.dispose();
    _respuestaController.dispose();
    _nuevaClaveController.dispose();
    super.dispose();
  }

  // --- PASO 1: BUSCAR USUARIO ---
  Future<void> _buscarUsuario() async {
    final usuario = _usuarioBusquedaController.text.trim();
    if (usuario.isEmpty) {
      _mostrarSnackBar("Ingrese su nombre de usuario.", esError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authController = context.read<AuthController>();
      final pregunta = await authController.obtenerPreguntaSeguridad(usuario);

      if (!mounted) return;

      if (pregunta != null && pregunta.isNotEmpty) {
        setState(() {
          _preguntaEncontrada = pregunta;
          _pasoActual = 2; // Avanzamos al paso de responder
        });
      } else {
        _mostrarSnackBar(
            "Usuario no encontrado o no posee pregunta configurada.",
            esError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarSnackBar("Error interno al buscar usuario.", esError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- PASO 2: CAMBIAR CLAVE ---
  Future<void> _ejecutarRecuperacion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authController = context.read<AuthController>();
      final exito = await authController.recuperarAcceso(
        usuarioObjetivo: _usuarioBusquedaController.text,
        respuestaIngresada: _respuestaController.text,
        nuevaClave: _nuevaClaveController.text,
      );

      if (!mounted) return;

      if (exito) {
        _mostrarSnackBar("Contraseña restaurada con éxito.", esError: false);
        Navigator.pop(context); // Volvemos al Login
      } else {
        _mostrarSnackBar("Respuesta secreta incorrecta.", esError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarSnackBar("Error interno del sistema.", esError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarSnackBar(String mensaje, {required bool esError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red.shade800 : Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Recuperar Acceso"),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Si estamos en el paso 2, el botón de atrás vuelve al paso 1
            if (_pasoActual == 2) {
              setState(() {
                _pasoActual = 1;
                _respuestaController.clear();
                _nuevaClaveController.clear();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _pasoActual == 1 ? _buildPasoUno() : _buildPasoDos(),
          ),
        ),
      ),
    );
  }

  // --- UI PASO 1 ---
  Widget _buildPasoUno() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.search, size: 64, color: Color(0xFF2E7D32)),
        const SizedBox(height: 16),
        const Text(
          "Buscar Cuenta",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Ingrese su nombre de usuario para buscar su pregunta de seguridad.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _usuarioBusquedaController,
          enabled: !_isLoading,
          decoration: const InputDecoration(
            labelText: "Usuario",
            prefixIcon: Icon(Icons.person_outline),
          ),
          onSubmitted: (_) => _buscarUsuario(),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _buscarUsuario,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("BUSCAR PREGUNTA",
                    style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }

  // --- UI PASO 2 ---
  Widget _buildPasoDos() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.lock_reset, size: 64, color: Color(0xFF2E7D32)),
          const SizedBox(height: 16),
          Text(
            "Recuperar cuenta: ${_usuarioBusquedaController.text}",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pregunta de Seguridad:",
                    style: TextStyle(
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
                const SizedBox(height: 8),
                Text(_preguntaEncontrada,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _respuestaController,
            enabled: !_isLoading,
            decoration: const InputDecoration(
              labelText: "Su Respuesta Secreta",
              prefixIcon: Icon(Icons.vpn_key_outlined),
            ),
            validator: (v) => v!.trim().isEmpty ? "Requerido" : null,
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0), child: Divider()),
          TextFormField(
            controller: _nuevaClaveController,
            enabled: !_isLoading,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: "Nueva Contraseña",
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: _isLoading
                    ? null
                    : () => setState(() => _obscureText = !_obscureText),
              ),
            ),
            validator: (v) => v!.trim().isEmpty ? "Requerido" : null,
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _ejecutarRecuperacion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("RESTAURAR ACCESO",
                      style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
