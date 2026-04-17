import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 1. Librería visual
import 'package:intl/date_symbol_data_local.dart'; // 2. NECESARIO PARA EL CALENDARIO

// Importaciones de datos
import 'src/data/local/app_database.dart';

// Importaciones de Lógica (Controllers)
import 'src/features/auth/logic/auth_controller.dart';
import 'src/features/personal/logic/personal_controller.dart';
import 'src/features/planning/logic/planning_controller.dart';
import 'src/features/dashboard/logic/dashboard_controller.dart';
import 'src/features/planning/logic/config_types_controller.dart';
import 'src/features/calendar/logic/calendar_controller.dart';
import 'src/features/incidents/logic/incidents_controller.dart';

// Importaciones de Pantallas (Screens)
import 'src/features/auth/presentation/screens/login_screen.dart';
import 'src/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'src/features/personal/presentation/screens/personal_list_screen.dart';
import 'src/features/planning/presentation/screens/planning_screen.dart';
import 'src/features/planning/presentation/screens/create_activity_screen.dart';
import 'src/features/planning/presentation/screens/actividad_form_screen.dart';
import 'src/features/planning/presentation/screens/config_types_screen.dart';
import 'src/features/calendar/presentation/screens/vacation_setup_screen.dart';
import 'src/features/incidents/presentation/screens/report_incident_screen.dart';
import 'src/features/config/presentation/screens/backup_screen.dart';

void main() async {
  // <--- Convertir main a async
  WidgetsFlutterBinding.ensureInitialized();

  // 3. INICIALIZAR FORMATOS DE FECHA EN ESPAÑOL ANTES DE ARRANCAR
  await initializeDateFormatting('es_ES', null);

  // Instancia única de la base de datos
  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider(create: (_) => AuthController(database)),
        ChangeNotifierProvider(create: (_) => PersonalController(database)),
        ChangeNotifierProvider(create: (_) => PlanningController(database)),
        ChangeNotifierProvider(create: (_) => DashboardController(database)),
        ChangeNotifierProvider(create: (_) => ConfigTypesController(database)),
        ChangeNotifierProvider(create: (_) => CalendarController(database)),
        ChangeNotifierProvider(create: (_) => IncidentsController(database)),
      ],
      child: const InparquesApp(),
    ),
  );
}

class InparquesApp extends StatelessWidget {
  const InparquesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Gestión - Inparques',

      // CONFIGURACIÓN DE IDIOMA
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español España
        Locale('es', 'VE'), // Español Venezuela
      ],
      locale: const Locale('es', 'ES'), // Forzar Español

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF1B5E20),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/personal': (context) => const PersonalListScreen(),
        '/planning': (context) => const PlanningScreen(),
        '/create_activity': (context) => const CreateActivityScreen(),
        '/actividad_form': (context) => const ActividadFormScreen(),
        '/config_types': (context) => const ConfigTypesScreen(),
        '/vacations': (context) => const VacationSetupScreen(),
        '/report_incident': (context) => const ReportIncidentScreen(),
        '/backup': (context) => const BackupScreen(),
      },
    );
  }
}
