# Estructura del Proyecto

```text
.
├── .agents
│   └── skills
│       └── flutter-animations
│           ├── assets
│           │   └── templates
│           │       ├── explicit_animation.dart
│           │       ├── hero_transition.dart
│           │       ├── implicit_animation.dart
│           │       └── staggered_animation.dart
│           ├── references
│           │   ├── curves.md
│           │   ├── explicit.md
│           │   ├── hero.md
│           │   ├── implicit.md
│           │   ├── physics.md
│           │   └── staggered.md
│           └── SKILL.md
├── analysis_options.yaml
├── android
│   ├── app
│   │   ├── build.gradle
│   │   └── src
│   │       ├── debug
│   │       │   └── AndroidManifest.xml
│   │       ├── main
│   │       │   ├── AndroidManifest.xml
│   │       │   ├── java
│   │       │   │   └── io
│   │       │   │       └── flutter
│   │       │   │           └── plugins
│   │       │   │               └── GeneratedPluginRegistrant.java
│   │       │   ├── kotlin
│   │       │   │   └── com
│   │       │   │       └── example
│   │       │   │           └── inparques
│   │       │   │               └── MainActivity.kt
│   │       │   └── res
│   │       │       ├── drawable
│   │       │       │   └── launch_background.xml
│   │       │       ├── drawable-v21
│   │       │       │   └── launch_background.xml
│   │       │       ├── mipmap-hdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-mdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xxhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── mipmap-xxxhdpi
│   │       │       │   └── ic_launcher.png
│   │       │       ├── values
│   │       │       │   └── styles.xml
│   │       │       └── values-night
│   │       │           └── styles.xml
│   │       └── profile
│   │           └── AndroidManifest.xml
│   ├── build.gradle
│   ├── .gitignore
│   ├── .gradle
│   │   ├── 8.10.2
│   │   │   ├── checksums
│   │   │   │   ├── checksums.lock
│   │   │   │   ├── md5-checksums.bin
│   │   │   │   └── sha1-checksums.bin
│   │   │   ├── dependencies-accessors
│   │   │   │   └── gc.properties
│   │   │   ├── executionHistory
│   │   │   │   ├── executionHistory.bin
│   │   │   │   └── executionHistory.lock
│   │   │   ├── expanded
│   │   │   ├── fileChanges
│   │   │   │   └── last-build.bin
│   │   │   ├── fileHashes
│   │   │   │   ├── fileHashes.bin
│   │   │   │   ├── fileHashes.lock
│   │   │   │   └── resourceHashesCache.bin
│   │   │   ├── gc.properties
│   │   │   └── vcsMetadata
│   │   ├── 8.14
│   │   │   ├── checksums
│   │   │   │   ├── checksums.lock
│   │   │   │   ├── md5-checksums.bin
│   │   │   │   └── sha1-checksums.bin
│   │   │   ├── executionHistory
│   │   │   │   ├── executionHistory.bin
│   │   │   │   └── executionHistory.lock
│   │   │   ├── expanded
│   │   │   ├── fileChanges
│   │   │   │   └── last-build.bin
│   │   │   ├── fileHashes
│   │   │   │   ├── fileHashes.bin
│   │   │   │   ├── fileHashes.lock
│   │   │   │   └── resourceHashesCache.bin
│   │   │   ├── gc.properties
│   │   │   └── vcsMetadata
│   │   ├── buildOutputCleanup
│   │   │   ├── buildOutputCleanup.lock
│   │   │   ├── cache.properties
│   │   │   └── outputFiles.bin
│   │   ├── file-system.probe
│   │   ├── kotlin
│   │   │   ├── errors
│   │   │   │   ├── errors-1770342786214.log
│   │   │   │   └── errors-1770414372975.log
│   │   │   └── sessions
│   │   ├── noVersion
│   │   │   └── buildLogic.lock
│   │   └── vcs-1
│   │       └── gc.properties
│   ├── gradle
│   │   └── wrapper
│   │       ├── gradle-wrapper.jar
│   │       └── gradle-wrapper.properties
│   ├── gradle.properties
│   ├── gradlew
│   ├── gradlew.bat
│   ├── .kotlin
│   │   ├── errors
│   │   │   ├── errors-1770342786214.log
│   │   │   └── errors-1770414372975.log
│   │   └── sessions
│   ├── local.properties
│   ├── settings.gradle
│   └── sistema_gestion_guardias_android.iml
├── assets
│   ├── database
│   ├── fonts
│   └── images
│       └── logo_inparques.png
├── build_log.txt
├── contexto_codigo_inparques.md
├── contexto_nucleo_inparques.md
├── contexto_sistema.md
├── data
│   └── certificados
├── estructura.md
├── estructura.txt
├── .flutter-plugins-dependencies
├── .gitignore
├── .idea
│   ├── libraries
│   │   ├── Dart_SDK.xml
│   │   └── KotlinJavaRuntime.xml
│   ├── modules.xml
│   ├── runConfigurations
│   │   └── main_dart.xml
│   └── workspace.xml
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
│       │   │       │   ├── initial_setup_screen.dart
│       │   │       │   └── login_screen.dart
│       │   │       └── widgets
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
├── linux
│   ├── CMakeLists.txt
│   ├── flutter
│   │   ├── CMakeLists.txt
│   │   ├── ephemeral
│   │   │   ├── flutter_linux
│   │   │   │   ├── fl_application.h
│   │   │   │   ├── fl_basic_message_channel.h
│   │   │   │   ├── fl_binary_codec.h
│   │   │   │   ├── fl_binary_messenger.h
│   │   │   │   ├── fl_dart_project.h
│   │   │   │   ├── fl_engine.h
│   │   │   │   ├── fl_event_channel.h
│   │   │   │   ├── fl_json_message_codec.h
│   │   │   │   ├── fl_json_method_codec.h
│   │   │   │   ├── fl_message_codec.h
│   │   │   │   ├── fl_method_call.h
│   │   │   │   ├── fl_method_channel.h
│   │   │   │   ├── fl_method_codec.h
│   │   │   │   ├── fl_method_response.h
│   │   │   │   ├── fl_pixel_buffer_texture.h
│   │   │   │   ├── fl_plugin_registrar.h
│   │   │   │   ├── fl_plugin_registry.h
│   │   │   │   ├── fl_standard_message_codec.h
│   │   │   │   ├── fl_standard_method_codec.h
│   │   │   │   ├── fl_string_codec.h
│   │   │   │   ├── fl_texture_gl.h
│   │   │   │   ├── fl_texture.h
│   │   │   │   ├── fl_texture_registrar.h
│   │   │   │   ├── flutter_linux.h
│   │   │   │   ├── fl_value.h
│   │   │   │   └── fl_view.h
│   │   │   ├── generated_config.cmake
│   │   │   ├── icudtl.dat
│   │   │   ├── libflutter_linux_gtk.so
│   │   │   └── .plugin_symlinks
│   │   │       ├── file_picker -> /home/cesar/.pub-cache/hosted/pub.dev/file_picker-8.3.7/
│   │   │       ├── file_selector_linux -> /home/cesar/.pub-cache/hosted/pub.dev/file_selector_linux-0.9.4/
│   │   │       ├── image_picker_linux -> /home/cesar/.pub-cache/hosted/pub.dev/image_picker_linux-0.2.2/
│   │   │       ├── path_provider_linux -> /home/cesar/.pub-cache/hosted/pub.dev/path_provider_linux-2.2.1/
│   │   │       ├── printing -> /home/cesar/.pub-cache/hosted/pub.dev/printing-5.14.2/
│   │   │       ├── share_plus -> /home/cesar/.pub-cache/hosted/pub.dev/share_plus-12.0.1/
│   │   │       ├── sqlite3_flutter_libs -> /home/cesar/.pub-cache/hosted/pub.dev/sqlite3_flutter_libs-0.5.41/
│   │   │       └── url_launcher_linux -> /home/cesar/.pub-cache/hosted/pub.dev/url_launcher_linux-3.2.2/
│   │   ├── generated_plugin_registrant.cc
│   │   ├── generated_plugin_registrant.h
│   │   └── generated_plugins.cmake
│   ├── .gitignore
│   └── runner
│       ├── CMakeLists.txt
│       ├── main.cc
│       ├── my_application.cc
│       └── my_application.h
├── .metadata
├── pubspec.lock
├── pubspec.yaml
├── pubspec.yaml.backup
├── README.md
├── repomix-output.xml
├── sistema_gestion_guardias.iml
├── skills-lock.json
├── test
└── web
    ├── favicon.png
    ├── icons
    │   ├── Icon-192.png
    │   ├── Icon-512.png
    │   ├── Icon-maskable-192.png
    │   └── Icon-maskable-512.png
    ├── index.html
    └── manifest.json

135 directories, 171 files
```
