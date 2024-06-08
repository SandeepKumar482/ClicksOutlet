import 'package:clicksoutlet/FirebaseService/user_collection.service.dart';
import 'package:clicksoutlet/model/user_details.dart';
import 'package:clicksoutlet/utils/floating_msg.util.dart';
import 'package:clicksoutlet/utils/shared_preferrences.util.dart';
import 'package:clicksoutlet/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthSevrvices {
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception {
      return null;
    }
  }

  static Future<bool> signOut() async {
    try {
      PreferenceUtils.clear();
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

  static Future<void> validateUser(
      {required BuildContext context,
      required UserCredential? userCredential}) async {
    if (userCredential?.user == null) {
      FloatingMsg.show(
          context: context,
          msg: "Something Went Wrong",
          msgType: MsgType.error);
    } else {
      User user = userCredential!.user!;
      UserDetailsModel userDetailsModel = UserDetailsModel(
        id: user.uid,
        email: userCredential.user?.email,
        phone: userCredential.user?.phoneNumber,
        name: user.displayName,
        userName: Utils.generateUserName(username: user.email),
        profilePicture: user.photoURL,
      );

      bool isSetToFB =
          await UserCollectionService().addUpdateData(userDetailsModel);

      FloatingMsg.show(
        context: context,
        msg: isSetToFB ? "Sign IN Successfully" : "Failed to Authenticate",
        msgType: isSetToFB ? MsgType.success : MsgType.error,
      );
    }
  }
}
