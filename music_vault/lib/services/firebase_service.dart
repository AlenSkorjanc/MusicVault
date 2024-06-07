import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;

  Future<User?> loginUser(String email, String password) async {
    if(currentUser != null) {
      await logoutUser();
    }

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> logoutUser() async {
    try {
      await auth.signOut();
      return true; // Logout successful
    } catch (e) {
      print(e.toString());
      return false; // Logout failed
    }
  }

  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }
}