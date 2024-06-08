import 'package:clicksoutlet/FirebaseService/auth.service.dart';
import 'package:clicksoutlet/View/widgets/custom_app_bar.widget.dart';
import 'package:clicksoutlet/View/widgets/input.widget.dart';
import 'package:clicksoutlet/constants/style.dart';
import 'package:clicksoutlet/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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

enum AuthState { auth, sendingVrificationCode, otpSent, googleAuthentication }

class _AuthModel extends StatefulWidget {
  const _AuthModel();

  @override
  State<_AuthModel> createState() => __AuthModelState();
}

class __AuthModelState extends State<_AuthModel> {
  TextEditingController? controller = TextEditingController();

  AuthState currentAuthState = AuthState.auth;
  final _formKey = GlobalKey<FormState>();

  String? verificationCode;

  @override
  Widget build(BuildContext context) {
    if (currentAuthState == AuthState.otpSent && verificationCode != null) {
      return _OTPModel(
        verificationId: verificationCode!,
      );
    } else {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            InputWidget(
              label: 'Phone Number',
              prefixIcon: const Icon(Icons.phone_android_rounded),
              readOnly: currentAuthState == AuthState.sendingVrificationCode,
              validator: (phoneNumber) {
                if (phoneNumber != null &&
                    phoneNumber.length == 10 &&
                    phoneNumber.isPhoneNumber) {
                  return null;
                } else {
                  return "Enter a Valid Phone Number";
                }
              },
              suffixIcon: currentAuthState == AuthState.sendingVrificationCode
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ))
                  : InkWell(
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _sendVerificationCode();
                        }
                      },
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
              onPressed: currentAuthState == AuthState.googleAuthentication
                  ? null
                  : _googleAuth,
              child: currentAuthState == AuthState.googleAuthentication
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
        ),
      );
    }
  }

  Future<void> _sendVerificationCode() async {
    setState(() {
      setState(() {
        currentAuthState = AuthState.sendingVrificationCode;
      });
    });
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      await auth.verifyPhoneNumber(
        phoneNumber: '+91${controller?.text.toString()}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            currentAuthState = AuthState.auth;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationCode = verificationId;
          setState(() {
            currentAuthState = AuthState.otpSent;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      e.printError(info: "Error in authentication--");
      Utils.getSnacbar("Authentication", e.toString());
    }
  }

  Future<void> _googleAuth() async {
    setState(() {
      currentAuthState = AuthState.googleAuthentication;
    });
    UserCredential? userCredential = await AuthSevrvices.signInWithGoogle();
    if (userCredential != null) {
      Get.back();
      AuthSevrvices.validateUser(
          context: context, userCredential: userCredential);
    } else {
      setState(() {
        currentAuthState = AuthState.auth;
      });
    }
  }
}

class _OTPModel extends StatefulWidget {
  final String verificationId;
  const _OTPModel({required this.verificationId});

  @override
  State<_OTPModel> createState() => __OTPModelState();
}

enum OTPState { none, verifying, wrongOtp }

class __OTPModelState extends State<_OTPModel> {
  OTPState currentOTPSatet = OTPState.none;
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: PinCodeTextField(
            appContext: context,
            length: 6,
            readOnly: currentOTPSatet == OTPState.verifying,
            controller: _otpController,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8.0),
              activeColor: Theme.of(context).colorScheme.secondary,
              inactiveColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        if (currentOTPSatet == OTPState.wrongOtp)
          const Text(
            "Wrong OTP",
            style: TextStyle(color: Colors.red),
          ),
        ElevatedButton(
          onPressed: currentOTPSatet == OTPState.verifying ? null : _verifyOTP,
          child: currentOTPSatet == OTPState.verifying
              ? const Text("Verifyinig ...")
              : const Text('Submit'),
        ),
      ],
    );
  }

  Future<void> _verifyOTP() async {
    setState(() {
      currentOTPSatet = OTPState.verifying;
    });

    UserCredential? userCredential = await AuthSevrvices.verifyOTP(
        verificationId: widget.verificationId, smsCode: _otpController.text);

    if (userCredential != null) {
      Get.back();
      AuthSevrvices.validateUser(
          context: context, userCredential: userCredential);
    } else {
      setState(() {
        currentOTPSatet = OTPState.wrongOtp;
      });
    }
  }
}
