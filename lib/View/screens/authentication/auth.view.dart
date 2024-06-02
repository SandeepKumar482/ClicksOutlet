import 'package:clicksoutlet/FirebaseService/google_auth.service.dart';
import 'package:clicksoutlet/View/widgets/input.widget.dart';
import 'package:clicksoutlet/model/user_details.dart';
import 'package:clicksoutlet/utils/floating_msg.util.dart';
import 'package:clicksoutlet/utils/shared_preferrences.util.dart';
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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: const Text("Signup to Continue"),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          const InputWidget(label: 'Phone Number'),
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

                bool isSetToSP = await userDetailsModel.setToSP();

                FloatingMsg.show(
                  context: context,
                  msg: isSetToSP
                      ? "Sign IN Successfully"
                      : "Failed to Authenticatye",
                  msgType: isSetToSP ? MsgType.success : MsgType.error,
                );
              }
              Get.back();
            },
            child: const Text('Continue with Google'),
          )
        ],
      ),
    );
  }
}
