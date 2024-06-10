import 'package:clicks_outlet/FirebaseService/user_collection.service.dart';
import 'package:clicks_outlet/model/user_details.dart';
import 'package:clicks_outlet/utils/floating_msg.util.dart';
import 'package:clicks_outlet/utils/shared_preferrences.util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthSevrvices {
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        return await auth.signInWithCredential(credential);
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  static Future<bool> signOut() async {
    try {
      SharedPreference.clear();
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  static Future<UserCredential?> verifyOTP(
      {required String smsCode, required String verificationId}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      return await auth.signInWithCredential(credential);
    } on Exception {
      return null;
    }
  }

  static Future<UserDetailsModel?> validateUser(
      {required BuildContext context,
      required UserCredential? userCredential}) async {
    if (userCredential?.user == null) {
      FloatingMsg.show(
          context: context,
          msg: "Something Went Wrong",
          msgType: MsgType.error);
    } else {
      User user = userCredential!.user!;

      final UserDetailsModel? userDetailsModel =
          await UserCollectionService().fetchData(userId: user.uid);

      if (userDetailsModel?.id != null) {
        await userDetailsModel!.setToSP();
        return userDetailsModel;
      } else {
        return null;
        // bool isSetToFB =
        //     await UserCollectionService().addUpdateData(userDetailsModel);
      }
    }
    return null;
  }
}
