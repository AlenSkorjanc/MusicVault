import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserResponse {
  User? user;
  String? error;

  UserResponse({this.user, this.error});
}

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

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

  Future<String?> updateDisplayName(String displayName) async {
    try {
      await currentUser!.updateDisplayName(displayName);
      return null;
    } catch (e) {
      print("An unexpected error occurred: ${e.toString()}");
      return 'An unexpected error occurred.';
    }
  }

  Future<String?> getDefaultProfilePicture() async {
    try {
      String downloadURL = await storage
          .ref('profile_pictures/default_avatar.png')
          .getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> uploadProfilePicture(Uint8List imageData) async {
    try {
      // Create a reference to the location you want to upload to
      Reference ref = storage.ref().child('profile_pictures/${currentUser!.uid}.png');

      // Upload the file
      UploadTask uploadTask = ref.putData(imageData);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

      // Get the download URL
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  Future<String?> updateProfilePicture(String photoURL) async {
    try {
      User? user = auth.currentUser;

      if (user != null) {
        await user.updateProfile(photoURL: photoURL);
        await user.reload(); // Reload user to reflect the changes
        user = auth.currentUser; // Get the updated user

        print("User profile updated with photoURL: ${user!.photoURL}");
        return null;
      } else {
        return "No user is currently signed in.";
      }
    } catch (e) {
      print("Error updating profile picture: $e");
      return e.toString();
    }
  }

  Future<String?> updateEmail(String newEmail) async {
    try {
      await currentUser!.verifyBeforeUpdateEmail(newEmail);
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseAuthException(e);
    } catch (e) {
      print("An unexpected error occurred: ${e.toString()}");
      return 'An unexpected error occurred.';
    }
  }

  Future<String?> updateUsername(String newUsername) async {
    try {
      await currentUser!.updateDisplayName(newUsername);
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
