# Estructura del Proyecto INPARQUES
```text
.
├── analysis_options.yaml
├── assets
│   ├── database
│   ├── fonts
│   └── images
│       └── logo_inparques.png
├── build_log.txt
├── contexto_codigo_inparques.md
├── contexto_nucleo_inparques.md
├── contexto_sistema.md
├── crear_instalador.sh
├── data
│   └── certificados
├── debian-package
│   ├── DEBIAN
│   │   └── control
│   ├── opt
│   │   └── inparques
│   │       ├── data
│   │       │   ├── flutter_assets
│   │       │   │   ├── AssetManifest.bin
│   │       │   │   ├── assets
│   │       │   │   │   ├── database
│   │       │   │   │   └── images
│   │       │   │   │       └── logo_inparques.png
│   │       │   │   ├── FontManifest.json
│   │       │   │   ├── fonts
│   │       │   │   │   └── MaterialIcons-Regular.otf
│   │       │   │   ├── NativeAssetsManifest.json
│   │       │   │   ├── NOTICES.Z
│   │       │   │   ├── shaders
│   │       │   │   │   ├── ink_sparkle.frag
│   │       │   │   │   └── stretch_effect.frag
│   │       │   │   └── version.json
│   │       │   └── icudtl.dat
│   │       ├── inparques
│   │       └── lib
│   │           ├── libapp.so
│   │           ├── libfile_selector_linux_plugin.so
│   │           ├── libflutter_linux_gtk.so
│   │           ├── libpdfium.so
│   │           ├── libprinting_plugin.so
│   │           ├── libsqlite3_flutter_libs_plugin.so
│   │           └── liburl_launcher_linux_plugin.so
│   └── usr
│       └── share
│           └── applications
│               └── inparques.desktop
├── estructura.md
├── estructura_proyecto.md
├── estructura.txt
├── inparques-bailadores.deb
├── inparques.iml
├── lib
│   ├── main.dart
│   └── src
│       ├── core
│       │   ├── constants
│       │   ├── theme
│       │   └── utils
│       ├── data
│       │   ├── local
│       │   │   ├── app_database.dart
│       │   │   └── app_database.g.dart
│       │   ├── models
│       │   └── repositories
│       ├── domain
│       │   ├── entities
│       │   └── repositories
│       ├── features
│       │   ├── auth
│       │   │   ├── logic
│       │   │   │   └── auth_controller.dart
│       │   │   └── presentation
│       │   │       ├── screens
│       │   │       │   ├── initial_router.dart
│       │   │       │   ├── initial_setup_screen.dart
│       │   │       │   ├── login_screen.dart
│       │   │       │   ├── recovery_screen.dart
│       │   │       │   └── register_screen.dart
│       │   │       └── widgets
│       │   ├── backup
│       │   │   ├── logic
│       │   │   │   └── backup_controller.dart
│       │   │   └── presentation
│       │   │       └── screens
│       │   │           └── backup_screen.dart
│       │   ├── calendar
│       │   │   ├── logic
│       │   │   │   └── calendar_controller.dart
│       │   │   └── presentation
│       │   │       └── screens
│       │   │           └── vacation_setup_screen.dart
│       │   ├── config
│       │   │   ├── logic
│       │   │   │   └── backup_controller.dart
│       │   │   └── presentation
│       │   │       └── screens
│       │   │           ├── backup_screen.dart
│       │   │           ├── edit_config_screen.dart
│       │   │           └── ubicaciones_screen.dart
│       │   ├── dashboard
│       │   │   ├── logic
│       │   │   │   ├── dashboard_controller.dart
│       │   │   │   └── guardia_hoy_model.dart
│       │   │   └── presentation
│       │   │       └── screens
│       │   │           └── dashboard_screen.dart
│       │   ├── incidents
│       │   │   ├── logic
│       │   │   │   ├── acta_generator.dart
│       │   │   │   ├── incident_generator.dart
│       │   │   │   └── incidents_controller.dart
│       │   │   └── presentation
│       │   │       └── screens
│       │   │           └── report_incident_screen.dart
│       │   ├── personal
│       │   │   ├── logic
│       │   │   │   └── personal_controller.dart
│       │   │   └── presentation
│       │   │       ├── screens
│       │   │       │   ├── funcionario_edit_screen.dart
│       │   │       │   ├── funcionario_profile_screen.dart
│       │   │       │   ├── funcionario_registration_screen.dart
│       │   │       │   └── personal_list_screen.dart
│       │   │       └── widgets
│       │   ├── planning
│       │   │   ├── logic
│       │   │   │   ├── config_types_controller.dart
│       │   │   │   ├── equity_algorithm.dart
│       │   │   │   └── planning_controller.dart
│       │   │   └── presentation
│       │   │       ├── screens
│       │   │       │   ├── actividad_form_screen.dart
│       │   │       │   ├── config_types_screen.dart
│       │   │       │   ├── create_activity_screen.dart
│       │   │       │   ├── planning_history_screen.dart
│       │   │       │   └── planning_screen.dart
│       │   │       └── widgets
│       │   └── reports
│       │       ├── logic
│       │       │   ├── pdf_generator_service.dart
│       │       │   └── weekly_report_generator.dart
│       │       └── presentation
│       │           └── screens
│       │               └── report_config_screen.dart
│       └── shared
│           └── widgets
├── pubspec.lock
├── pubspec.yaml
├── pubspec.yaml.backup
├── README.md
├── releases
│   ├── inparques-bailadores_1.0.0_amd64.deb
│   └── inparques-bailadores_1.0.0.apk
├── repomix-output.xml
├── sistema_gestion_guardias.iml
├── skills-lock.json
├── skills_upload
│   ├── skill_code_review.md
│   ├── skill_debugging.md
│   └── skill_pdf_manager.md
└── test
    └── widget_test.dart

80 directories, 85 files
```
