import 'package:clicks_outlet/utils/shared_preferrences.util.dart';
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

      return googleAuth?.accessToken;

    } catch(e) {
      debugPrint("Error in Google Sign in $e");
      return "qsecyterfhtdewr"; // TODO : Remove for Production
    }
  }

  static Future<bool> signOut() async {
    try {
      SharedPreference.clear();
      // TODO: Review it Return Type
      await GoogleSignIn().signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
