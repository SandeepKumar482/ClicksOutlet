import 'package:clicksoutlet/FirebaseService/google_auth.service.dart';
import 'package:clicksoutlet/FirebaseService/user_collection.service.dart';
import 'package:clicksoutlet/View/screens/authentication/otp.view.dart';
import 'package:clicksoutlet/View/screens/authentication/user_details_form.view.dart';
import 'package:clicksoutlet/View/widgets/custom_app_bar.widget.dart';
import 'package:clicksoutlet/View/widgets/input.widget.dart';
import 'package:clicksoutlet/View/widgets/otp_input.widget.dart';
import 'package:clicksoutlet/constants/style.dart';
import 'package:clicksoutlet/model/user_details.dart';
import 'package:clicksoutlet/utils/floating_msg.util.dart';
import 'package:clicksoutlet/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isAuthenticating = false;
  bool isOTPSent = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      scrollable: true,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            brandName,
            const SizedBox(
              height: 12.0,
            ),
            const _AuthModel(),
          ],
        ),
      ),
    );
  }
}

class _AuthModel extends StatefulWidget {
  const _AuthModel();

  @override
  State<_AuthModel> createState() => __AuthModelState();
}

class __AuthModelState extends State<_AuthModel> {
  TextEditingController? controller = TextEditingController();

  bool isSendingVerifcationCode = false;
  bool isGoolgleAuthenticating = false;
  bool isOTPSent = false;
  String? verificationCode;

  @override
  Widget build(BuildContext context) {
    if (isOTPSent && verificationCode != null) {
      return _OTPModel(
        verificationId: verificationCode!,
      );
    } else {
      return Column(
        children: [
          InputWidget(
            label: 'Phone Number',
            prefixIcon: const Icon(Icons.phone_android_rounded),
            readOnly: isSendingVerifcationCode,
            suffixIcon: isSendingVerifcationCode
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator())
                : InkWell(
                    onTap: _sendVerificationCode,
                    child: const Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 35.0,
                    ),
                  ),
            controller: controller,
          ),
          Row(
            children: [
              const Expanded(child: Divider()),
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    color: ColorsConst.primary,
                    borderRadius: BorderRadius.circular(25.0)),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const Text("OR"),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          ElevatedButton(
            onPressed: isGoolgleAuthenticating ? null : _googleAuth,
            child: isGoolgleAuthenticating
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                          ),
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text("Authenticating ...")
                      ],
                    ),
                  )
                : const Text('Continue with Google'),
          )
        ],
      );
    }
  }

  Future<void> _sendVerificationCode() async {
    if (controller?.text.length == 10 && controller!.text.isPhoneNumber) {
      setState(() {
        isSendingVerifcationCode = true;
      });
      try {
        final FirebaseAuth auth = FirebaseAuth.instance;

        await auth.verifyPhoneNumber(
          phoneNumber: '+91${controller?.text.toString()}',
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {},
          codeSent: (String verificationId, int? resendToken) {
            verificationCode = verificationId;
            setState(() {
              isOTPSent = true;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        e.printError(info: "Error in authentication--");
        Utils.getSnacbar("Authentication", e.toString());
      }
    } else {
      Utils.getSnacbar("Invalid!!!", "Enter a Valid Phone Number");
    }
  }

  Future<void> _googleAuth() async {
    setState(() {
      isGoolgleAuthenticating = true;
    });
    UserCredential? userCredential = await GoogleAuth.signInWithGoogle();
    if (userCredential?.user == null) {
      FloatingMsg.show(
          context: context,
          msg: "Something Went Wrong",
          msgType: MsgType.error);
    } else {
      User user = userCredential!.user!;
      UserDetailsModel userDetailsModel = UserDetailsModel(
        id: user.uid,
        name: user.displayName,
        userName: Utils.generateUserName(username: user.email),
        profilePicture: user.photoURL,
      );

      bool isSetToFB =
          await UserCollectionService().addUpdateData(userDetailsModel);

      FloatingMsg.show(
        context: context,
        msg: isSetToFB ? "Sign IN Successfully" : "Failed to Authenticatye",
        msgType: isSetToFB ? MsgType.success : MsgType.error,
      );
    }

    setState(() {
      isGoolgleAuthenticating = false;
    });
    Get.back();
  }
}

class _OTPModel extends StatefulWidget {
  final String verificationId;
  const _OTPModel({required this.verificationId});

  @override
  State<_OTPModel> createState() => __OTPModelState();
}

class __OTPModelState extends State<_OTPModel> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OtpInput(_fieldOne, true), // auto focus
                OtpInput(_fieldTwo, false),
                OtpInput(_fieldThree, false),
                OtpInput(_fieldFour, false),
                OtpInput(_fieldFive, false),
                OtpInput(_fieldSix, false)
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _verifyOTP,
            child: _isLoading
                ? const Text("Verifyinig ...")
                : const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyOTP() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    setState(() {
      _isLoading = true;
    });

    _otpController.text = _fieldOne.text +
        _fieldTwo.text +
        _fieldThree.text +
        _fieldFour.text +
        _fieldFive.text +
        _fieldSix.text;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _otpController.text,
    );
    await auth.signInWithCredential(credential).then((cred) {
      FloatingMsg.show(
          context: context, msg: "Sign In", msgType: MsgType.success);
    }).catchError((e, s) {
      FloatingMsg.show(
          context: context,
          msg: "Wrong SMS ${e.message}",
          msgType: MsgType.error);
    });

    setState(() {
      _isLoading = false;
    });
  }
}
