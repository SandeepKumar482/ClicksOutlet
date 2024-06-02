import 'package:clicksoutlet/FirebaseService/google_auth.service.dart';
import 'package:clicksoutlet/FirebaseService/user_collection.service.dart';
import 'package:clicksoutlet/View/screens/authentication/otp.view.dart';
import 'package:clicksoutlet/View/widgets/input.widget.dart';
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
  TextEditingController? controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: const Text(
        "Signup to Continue",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          InputWidget(
              label: 'Phone Number',
              prefixIcon: const Icon(Icons.phone_android_rounded),
              controller: controller),
          SizedBox(
            width: deviceWidth * 0.65, // 60% of device width
            child: ElevatedButton(
              onPressed: () async {
                if (controller?.text.length == 10 &&
                    controller!.text.isPhoneNumber) {
                  try {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    await auth.verifyPhoneNumber(
                      phoneNumber: '+91${controller?.text.toString()}',
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return OtpScreen(verificationId);
                            });
                        Utils.getSnacbar("Otp Sent", "to your phone number");
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
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: ColorsConst.secondary,
                  backgroundColor: ColorsConst.fourth),
              child: const Text('Submit'),
            ),
          ),
          const Divider(),
          ElevatedButton(
            onPressed: () async {
              UserCredential? userCredential =
                  await GoogleAuth.signInWithGoogle();
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

                bool isSetToFB = await UserCollectionService()
                    .addUpdateData(userDetailsModel);

                FloatingMsg.show(
                  context: context,
                  msg: isSetToFB
                      ? "Sign IN Successfully"
                      : "Failed to Authenticatye",
                  msgType: isSetToFB ? MsgType.success : MsgType.error,
                );
              }
              Get.back();
            },
            child: Text('Continue with Google'),
          )
        ],
      ),
    );
  }
}
