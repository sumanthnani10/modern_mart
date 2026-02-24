import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'screens/splash_screen.dart';

void main() {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>(debugLabel: 'Main Navigator');

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
          fontFamily: 'Poppins',
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            textStyle: TextStyle(color: Colors.black),
          )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                textStyle: TextStyle(color: Colors.black)),
          )),
      home: OverlaySupport(
        child: SplashScreen(
          nkey: navigatorKey,
        ),
      )));
}
