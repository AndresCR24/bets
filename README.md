# Fight Picks — Notas de Predicción de Peleas.

App Flutter para registrar y editar predicciones sobre peleas de boxeo/MMA.

## Características

- **Login / Registro** con Firebase Authentication (email + contraseña)
- **Lista de predicciones** (Home) con stream reactivo desde Drift
- **Crear predicción** → guardada en SQLite (Drift) y sincronizada en Firestore
- **Editar predicción** → actualizada en SQLite (Drift) y sincronizada en Firestore

## Arquitectura

```
lib/
├── data/
│   ├── local/
│   │   ├── app_database.dart       ← Drift: tabla Notes
│   │   └── app_database.g.dart     ← Generado por build_runner
│   └── remote/
│       └── note_remote_service.dart ← Firestore (colección "andres")
├── features/
│   ├── auth/
│   │   ├── auth_service.dart       ← Firebase Auth
│   │   └── login_page.dart         ← Pantalla Login/Registro
│   └── notes/
│       ├── note_model.dart         ← Modelo de datos
│       ├── note_repository.dart    ← Coordina local + remoto
│       ├── notes_page.dart         ← Lista de predicciones (Home)
│       └── note_form_page.dart     ← Crear/Editar predicción
├── firebase_options.dart
└── main.dart
```

## Dependencias principales

| Paquete | Uso |
|---|---|
| `drift` + `drift_flutter` | Base de datos local SQLite |
| `firebase_core` | Inicialización Firebase |
| `firebase_auth` | Autenticación email/password |
| `cloud_firestore` | Base de datos remota |
| `path_provider` | Ruta del directorio de soporte |

## Configuración Firebase

Este proyecto usa el proyecto Firebase `t1xg0-flutter`.

> **Importante:** Para que Firebase Auth funcione con el package `com.example.bets`,
> debes registrar la nueva app Android en Firebase Console:
>
> 1. Ve a [Firebase Console](https://console.firebase.google.com) → proyecto `t1xg0-flutter`
> 2. Agrega una app Android con package name `com.example.bets`
> 3. Descarga el nuevo `google-services.json` y reemplaza `android/app/google-services.json`
> 4. Actualiza `lib/firebase_options.dart` con el nuevo `appId` de Android
>
> **Alternativa rápida:** Ejecuta `flutterfire configure` dentro de la carpeta `bets/`
> para reconfigurarlo automáticamente.

### Habilitar Firebase Auth

En Firebase Console → Authentication → Sign-in method → habilitar **Email/Password**.

### Reglas de Firestore (modo desarrollo)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Cómo correr el proyecto

### Requisitos previos

- Flutter SDK >= 3.11
- Android Studio / emulador Android
- Proyecto Firebase configurado (ver sección anterior)

### Pasos

```bash
# 1. Instalar dependencias
cd bets
flutter pub get

# 2. Regenerar código Drift (solo si modificas app_database.dart)
dart run build_runner build --delete-conflicting-outputs

# 3. Correr en emulador/dispositivo Android
flutter run
```

## Estructura Firestore

Los documentos se guardan en la colección **`andres`** con este esquema:

```json
{
  "title": "Canelo vs Berlanga",
  "content": "Canelo gana por decisión unánime...",
  "createdAt": Timestamp,
  "userId": "uid-del-usuario-autenticado"
}
```

El ID del documento en Firestore corresponde al `id` local de Drift.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
