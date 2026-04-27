import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Servicio de autenticación con Firebase Auth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream del usuario autenticado actual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // Registrar con email y contraseña
  Future<String?> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // null = éxito
    } on FirebaseAuthException catch (e) {
      debugPrint('Error al registrar: ${e.code}');
      return _mapError(e.code);
    }
  }

  // Iniciar sesión con email y contraseña
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Error al iniciar sesión: ${e.code}');
      return _mapError(e.code);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Traduce códigos de error de Firebase a mensajes en español
  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'El correo ya está registrado.';
      case 'invalid-email':
        return 'Correo inválido.';
      case 'weak-password':
        return 'La contraseña es muy débil (mín. 6 caracteres).';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      default:
        return 'Error: $code';
    }
  }
}
