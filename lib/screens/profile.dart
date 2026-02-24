import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../screens/login.dart';
import '../screens/orders.dart';
import '../storage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showAddress = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 48,
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${Storage.user['fn']} ${Storage.user['ln']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '${Storage.user['m']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  /*Text(
                    '${Storage.user['ar']}',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),*/
                ],
              )
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      showAddress = !showAddress;
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border(bottom: BorderSide(color: Colors.black26))),
                    child: Text(
                      'Address',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                if (showAddress)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      '${Storage.user['fn']} ${Storage.user['ln']}\n${Storage.user['a'] ?? 'No Address'}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(createRoute(Orders()));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border(bottom: BorderSide(color: Colors.black26))),
                    child: Text(
                      'Orders',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    FirebaseAuth.instance.signOut();
                    await Storage.writeLocal("user", {});
                    await Storage.writeLocal("cart", <String, dynamic>{});
                    Navigator.pushReplacement(context, createRoute(Login()));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border(bottom: BorderSide(color: Colors.black26))),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Share.share(
                        'Check Out this app.\nbit.ly/${Storage.APP_NAME_}');
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border(bottom: BorderSide(color: Colors.black26))),
                    child: Text(
                      'Share',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(createRoute(
                      Scaffold(
                        appBar: AppBar(
                          title: Text(
                            'Full Time Develeopers (FTD)',
                            style: TextStyle(color: Colors.black),
                          ),
                          iconTheme: IconThemeData(color: Colors.black),
                          backgroundColor: Colors.white,
                          elevation: 0,
                        ),
                        body: WebView(
                          debuggingEnabled: false,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (c) {
                            c.loadUrl(
                                'https://fulltimedevs-aboutus.netlify.app/');
                          },
                        ),
                      ),
                    ));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border(bottom: BorderSide(color: Colors.black26))),
                    child: Text(
                      'About Us',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
