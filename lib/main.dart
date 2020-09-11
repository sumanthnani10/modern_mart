import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>(debugLabel: 'Main Navigator');

  runApp(OverlaySupport(
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(fontFamily: 'Poppins'),
        home: SplashScreen(
          nkey: navigatorKey,
        )),
  ));
}
