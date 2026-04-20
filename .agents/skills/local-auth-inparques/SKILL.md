---
name: local-auth-inparques
description: Reglas e instrucciones arquitectónicas para crear o modificar flujos de autenticación (Login, Registro, Recuperación) usando bases de datos locales (Drift) y Clean Architecture en Flutter.
---

# Autenticación Local (Offline-First) - INPARQUES

## 🎯 Cuándo usar este skill
- Al crear o modificar pantallas de `LoginScreen`, `RegisterScreen` o `RecoveryScreen`.
- Al alterar la lógica de sesión del usuario en `AuthController`.
- Al realizar cambios en la tabla de credenciales de la base de datos `AppDatabase` (Drift).

## 🏛️ Reglas de Arquitectura (Clean Architecture)

### 1. Separación de Capas Obligatoria
- **UI (Presentation):** Las pantallas (`Screens`) **NUNCA** deben importar o llamar directamente a `AppDatabase`. Toda interacción debe hacerse a través de `context.read<AuthController>()`.
- **Lógica (Controllers):** `AuthController` es la única clase autorizada para ejecutar consultas a la tabla `ConfigSettings` y `UsuariosSistema`. Debe manejar su propio estado (`_isAuthenticated`, `_rolActual`) y notificar a la UI con `notifyListeners()`.
- **Datos (Drift):** Las credenciales de acceso deben aislarse en tablas específicas y las migraciones de `schemaVersion` deben escribirse explícitamente en el `onUpgrade`.

### 2. Flujos del Sistema de Autenticación
El sistema contempla tres flujos principales que deben respetarse:
1. **Inicio de Sesión (Login):** Debe validar primero si el usuario es el *Administrador Maestro* (en la tabla `ConfigSettings`). Si no lo es, debe buscar en la tabla secundaria de Operadores (`UsuariosSistema`).
2. **Creación de Cuentas (Register):** Solo debe crear usuarios con el rol `Operador`. El usuario `admin` está estrictamente reservado. Debe validar que el usuario no exista previamente.
3. **Recuperación (Recovery):** Al ser un sistema offline (sin email ni SMS), la recuperación se realiza **exclusivamente mediante una pregunta de seguridad secreta** establecida durante el primer arranque del sistema.

## 📱 Reglas de Interfaz de Usuario (UI/UX)
- **Responsividad:** Las pantallas de autenticación deben usar `LayoutBuilder` o `ConstrainedBox` (ej. `maxWidth: 400`) para garantizar que los formularios no se estiren de forma antiestética en las versiones de Escritorio (Windows/Linux) y mantengan la ergonomía en dispositivos móviles (Target: Tecno Spark 20).
- **Seguridad Visual:** Los campos de contraseñas (`obscureText`) deben incluir siempre un botón de "Ver/Ocultar" tipo `suffixIcon`.
- **Identidad Gráfica:** Se debe utilizar el widget `Image.asset` para cargar el logo oficial (`assets/images/logo_inparques.png`). Es **obligatorio** incluir un parámetro `errorBuilder` (ej. mostrando un `Icon(Icons.park)`) como *fallback* en caso de que el asset falle durante las compilaciones en Linux/Windows.

## 🚧 Manejo de Estado y Errores
1. Al pulsar un botón de acción (Login/Registro/Recuperar), la pantalla debe deshabilitar inmediatamente el botón y mostrar un `CircularProgressIndicator` gestionando un booleano local `_isLoading` mediante `setState`.
2. Las respuestas del controlador hacia la UI deben manejarse mediante *SnackBars* genéricos y limpios usando `ScaffoldMessenger`, cubriendo siempre bloques `try-catch` para evitar cierres inesperados de la app.
3. Siempre verificar `if (!mounted) return;` después de tareas asíncronas (`await`) antes de interactuar con el BuildContext.