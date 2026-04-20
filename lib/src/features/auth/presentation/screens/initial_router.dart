import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_controller.dart';
import 'login_screen.dart';
import 'initial_setup_screen.dart';

class InitialRouter extends StatefulWidget {
  const InitialRouter({super.key});

  @override
  State<InitialRouter> createState() => _InitialRouterState();
}

class _InitialRouterState extends State<InitialRouter> {
  @override
  void initState() {
    super.initState();
    // Verificamos el estado de la DB apenas carga el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().checkInitialSetup();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios en el controlador
    return Consumer<AuthController>(
      builder: (context, auth, child) {
        // 1. Estado de Carga: Mientras la DB responde
        if (auth.isSetupDone == null) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 20),
                  Text("Iniciando sistema...",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        }

        // 2. Si NO hay configuración -> Pantalla de Primer Arranque
        if (auth.isSetupDone == false) {
          return const InitialSetupScreen();
        }

        // 3. Si YA hay configuración -> Pantalla de Login
        return const LoginScreen();
      },
    );
  }
}
