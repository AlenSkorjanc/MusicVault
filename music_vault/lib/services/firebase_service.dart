import 'package:firebase_auth/firebase_auth.dart';

class UserResponse {
  User? user;
  String? error;

  UserResponse({this.user, this.error});
}

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;

  Future<UserResponse> loginUser(String email, String password) async {
    if (currentUser != null) {
      await logoutUser();
    }

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return UserResponse(user: userCredential.user);
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleFirebaseAuthException(e);
      print(e);
      return UserResponse(error: errorMessage);
    } catch (e) {
      print("An unexpected error occurred: ${e.toString()}");
      return UserResponse(error: 'An unexpected error occurred.');
    }
  }

  Future<bool> logoutUser() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<UserResponse> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return UserResponse(user: userCredential.user);
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleFirebaseAuthException(e);
      print(errorMessage);
      return UserResponse(error: errorMessage);
    } catch (e) {
      print("An unexpected error occurred: ${e.toString()}");
      return UserResponse(error: 'An unexpected error occurred.');
    }
  }

  Future<String?> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      print("An unexpected error occurred: ${e.toString()}");
      return 'An unexpected error occurred.';
    }
  }

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-credential':
        return 'Email or Password is incorrect.';
      default:
        return 'An undefined Error happened.';
    }
  }
}
