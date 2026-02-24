import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

class OtpScreen extends StatefulWidget {
  String phoneNumber;

  OtpScreen({@required this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  String otp, verificationId;

  @override
  void initState() {
    verifyPhone(widget.phoneNumber);
    _controller = AnimationController(vsync: this);
    super.initState();
//    showLoadingDialog(context, 'Sending OTP');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: <Widget>[
                Container(
                    child: Image.asset(
                  'assets/images/otp_screen.jpg',
                  fit: BoxFit.cover,
                )),
                Text(
                  "Enter OTP",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    "Enter OTP sent to your mobile.",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 64,
                ),
                Container(
                  width: 300,
                  child: TextField(
                    maxLength: 6,
                    onChanged: (v) {
                      this.otp = v;
                    },
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(16.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 2),
                          borderRadius: BorderRadius.circular(48)),
                      hintText: "OTP",
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
                ButtonTheme(
                  minWidth: 160,
                  height: 48,
                  child: RaisedButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      showLoadingDialog(context, 'Signing In');
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: otp);
                      FirebaseAuth.instance
                          .signInWithCredential(credential)
                          .then((value) async {
                        Navigator.popUntil(
                            context, (route) => route is PageRoute);

                        Navigator.push(context, createRoute(SplashScreen()));
                      }).catchError(() {
                        Navigator.pop(context);
                        showAlertDialog(context, 'Sign In Failed',
                            'An error occured. Try Again');
                      });
                    },
                    child: Text(
                      "VERIFY",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    splashColor: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(pno) async {
    final PhoneVerificationCompleted verified = (AuthCredential ac) {
      showLoadingDialog(context, 'Signing In');
      FirebaseAuth.instance.signInWithCredential(ac).then((value) async {
        // print("login success");
        Navigator.pushReplacement(context, createRoute(SplashScreen()));
      }).catchError(() {
        showAlertDialog(
            context, 'Sign In Failed', 'An error occured. Try Again');
      });
    };

    final PhoneVerificationFailed verifailed = (ae) {
      // print('${ae.message}');
    };

    final PhoneCodeSent codeSent = (String verId, [int forceResend]) {
      // print('code sent');
      this.verificationId = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeOut = (String verId) {
      // print('time out');
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + pno,
        timeout: const Duration(seconds: 10),
        verificationCompleted: verified,
        verificationFailed: verifailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoTimeOut);
  }

  showAlertDialog(BuildContext context, String title, String message) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(16),
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLoadingDialog(BuildContext context, String title) {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 8,
                  ),
                  Text(title)
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Route createRoute(dest) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => dest,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0, -1);
        var end = Offset.zero;
        var curve = Curves.fastOutSlowIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
