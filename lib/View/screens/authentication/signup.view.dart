import 'package:clicksoutlet/View/screens/authentication/otp.view.dart';
import 'package:clicksoutlet/View/screens/home.view.dart';
import 'package:clicksoutlet/View/widgets/custom_app_bar.widget.dart';
import 'package:clicksoutlet/constants/style.dart';
import 'package:clicksoutlet/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInUp extends StatefulWidget {
  const SignInUp({super.key});

  @override
  State<SignInUp> createState() => _SignInUpState();
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            //settings: RouteSettings(name: OtherPage.routeName),
            builder: (context) => const Home(),
          ),
        );
      } catch (e) {}

      debugPrint('User is signed in!');
    } else {
      // The user is not logged in
      debugPrint('User is not signed in.');
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
        title: const CustomAppBar(
          word1: "Clicks",
          word2: "Outlet",
        ),
      ),
      body: Center(
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: deviceWidth * 0.9, // 80% of device width
                    child: TextFormField(
                      decoration: Utils.buildInputDecoration(
                          "Enter your phone number", Icons.phone),
                      style: const TextStyle(color: ColorsConst.third),
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
                  SizedBox(
                    width: deviceWidth * 0.65, // 60% of device width
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          try {
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            await auth.verifyPhoneNumber(
                              phoneNumber: '+91$_phoneNumber',
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {},
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                // Get.to(OtpScreen(verificationId));
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
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ColorsConst.secondary,
                      ),
                      child: const Text('Submit'),
                    ),
                  )
                  /*SizedBox(
                      height: deviceHeight * 0.02,
                      child: const Text(
                        'OR',
                        style: TextStyle(color: ColorsConst.third),
                      )),*/
                  // 2% of device height
                  /* SizedBox(
                    width: deviceWidth * 0.55, // 60% of device width
                    child: ElevatedButton(
                      onPressed: () {
                        try {
                          Get.off(const Home());
                        } catch (e) {}
                      },
                      child: Text('Continue as Guest'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ColorsConst.secondary,
                        primary: ColorsConst.fourth,
                      ),
                    ),
                  ),*/
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
