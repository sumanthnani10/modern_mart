import 'package:flutter/material.dart';
import '../screens/otp_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  String phoneNumber = '';

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
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
                  'assets/images/login_screen.jpg',
                  fit: BoxFit.cover,
                )),
                Text(
                  "Mobile Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    "An OTP will be sent to your mobile.",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 64,
                ),
                Container(
                  width: 300,
                  child: TextField(
                    maxLength: 10,
                    onChanged: (v) {
                      this.phoneNumber = v;
                    },
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(16.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 2),
                          borderRadius: BorderRadius.circular(48)),
                      hintText: "Mobile number",
                      prefixText: '+91 ',
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
                      Navigator.push(context,
                          createRoute(OtpScreen(phoneNumber: phoneNumber)));
                    },
                    child: Text(
                      "GET OTP",
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

  Route createRoute(dest) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => dest,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1, 0);
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
