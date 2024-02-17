import 'package:clicksoutlet/View/screens/Home.dart';
import 'package:clicksoutlet/View/widgets/CustomAppBar.dart';
import 'package:clicksoutlet/View/widgets/OtpInput.dart';
import 'package:clicksoutlet/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/ColorsConst.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  OtpScreen(this.verificationId);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

void authenticate() {}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;

  TextEditingController _fieldOne = TextEditingController();
  TextEditingController _fieldTwo = TextEditingController();
  TextEditingController _fieldThree = TextEditingController();
  TextEditingController _fieldFour = TextEditingController();
  TextEditingController _fieldFive = TextEditingController();
  TextEditingController _fieldSix = TextEditingController();

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
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
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
            SizedBox(
              height: deviceHeight * 0.05,
            ),
            Container(
              width: deviceWidth * 0.65, // 60% of device width
              child: ElevatedButton(
                onPressed: () async {
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
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithCredential(credential);
                  setState(() {
                    _isLoading = false;
                  });
                  Utils.getSnacbar(
                      "Authentication Status", "Authenticated!!!!!!!");
                  Get.off(Home());
                },
                child:
                    _isLoading ? CircularProgressIndicator() : Text('Submit'),
                style: ElevatedButton.styleFrom(
                  primary: ColorsConst.primary,
                  onPrimary: ColorsConst.third,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
