import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    final auth = FirebaseAuth.instance;
    User? user;

    try {
      final googleAuthProvider = GoogleAuthProvider();
      final userCredential = await auth.signInWithPopup(googleAuthProvider);
      user = userCredential.user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error occurred using Google Sign-In. Try again.',
        ),
      );
    }

    return user;
  }

  static SnackBar customSnackBar({required String content}) => SnackBar(
        content: Text(
          content,
          style: const TextStyle(letterSpacing: 0.5),
        ),
      );
}
