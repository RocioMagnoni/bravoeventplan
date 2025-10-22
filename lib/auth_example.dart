import 'package:firebase_auth/firebase_auth.dart';

class AuthExample {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registrar un nuevo usuario
  Future<String?> registrarUsuario(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Usuario registrado exitosamente: ${userCredential.user?.email}');
      return null; // null significa éxito

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'La contraseña es muy débil. Usa al menos 6 caracteres.';
      } else if (e.code == 'email-already-in-use') {
        return 'Ya existe una cuenta con este email.';
      } else if (e.code == 'invalid-email') {
        return 'El formato del email no es válido.';
      }
      return 'Error desconocido: ${e.message}';
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }

  // Iniciar sesión
  Future<String?> iniciarSesion(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Sesión iniciada: ${userCredential.user?.email}');
      return null;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No existe un usuario con este email.';
      } else if (e.code == 'wrong-password') {
        return 'Contraseña incorrecta.';
      }
      return 'Error: ${e.message}';
    }
  }

  // Cerrar sesión
  Future<void> cerrarSesion() async {
    await _auth.signOut();
    print('Sesión cerrada exitosamente');
  }

  // Obtener usuario actual
  User? get usuarioActual => _auth.currentUser;

  // Verificar si hay un usuario autenticado
  bool get estaAutenticado => _auth.currentUser != null;
}
