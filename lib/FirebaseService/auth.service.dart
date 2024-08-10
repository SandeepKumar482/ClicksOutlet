import 'package:apex_infinity/apex_infinity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthServices {
  static Future<String?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      return googleAuth?.idToken;

    } catch(e) {
      debugPrint("Error in Google Sign in $e");
      return null;
    }
  }

  static Future<bool> signOut() async {
    try {
      Ax.sharedPreference.clear();
      // TODO: Review it Return Type
      await GoogleSignIn().signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
