import 'package:clicksoutlet/View/screens/Home.dart';
import 'package:clicksoutlet/View/screens/authentication/OtpScreen.dart';
import 'package:clicksoutlet/View/widgets/CustomAppBar.dart';
import 'package:clicksoutlet/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/ColorsConst.dart';

class SignInUp extends StatefulWidget {
  @override
  _SignInUpState createState() => _SignInUpState();
}

class _SignInUpState extends State<SignInUp>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late String _phoneNumber;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // The user is logged in
      try {
        Get.to(Home());
        Future.delayed(const Duration(milliseconds: 10), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
      } catch (e) {}

      print('User is signed in!');
    } else {
      // The user is not logged in
      print('User is not signed in.');
    }
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: ColorsConst.primary,
        title: CustomAppBar(
          word1: "Clicks",
          word2: "Outlet",
        ),
      ),
      body: Center(
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.easeIn,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: deviceWidth * 0.9, // 80% of device width
                    child: TextFormField(
                      decoration: Utils.buildInputDecoration(
                          "Enter your phone number", Icons.phone),
                      style: TextStyle(color: ColorsConst.third),
                      cursorColor: ColorsConst.primary,
                      validator: (value) {
                        if (value!.isEmpty || value.length != 10) {
                          Utils.getSnacbar(
                              "OOPS!!", "Please Enter a Valid Phone Number");
                          return ' ';
                        }
                        return null;
                      },
                      onSaved: (value) => _phoneNumber = value!,
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  // 2% of device height
                  Container(
                    width: deviceWidth * 0.65, // 60% of device width
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // TODO: Implement phone number authentication here
                          try {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            await _auth.verifyPhoneNumber(
                              phoneNumber: '+91' + _phoneNumber,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {},
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                Get.to(OtpScreen(verificationId));
                                Utils.getSnacbar(
                                    "Otp Sent", "to your phone number");
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                          } catch (e) {
                            e.printError(info: "Error in authentication--");
                            Utils.getSnacbar("Authentication", e.toString());
                          }
                        }
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        primary: ColorsConst.primary,
                        onPrimary: ColorsConst.third,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: deviceHeight * 0.02,
                      child: Text(
                        'OR',
                        style: TextStyle(color: ColorsConst.third),
                      )),
                  // 2% of device height
                  Container(
                    width: deviceWidth * 0.55, // 60% of device width
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement continue as guest here
                      },
                      child: Text('Continue as Guest'),
                      style: ElevatedButton.styleFrom(
                        primary: ColorsConst.fourth,
                        onPrimary: ColorsConst.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
