import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class Storage {
  static String localStorageKey = "Modern_Mart";
  static LocalStorage localStorage = new LocalStorage(localStorageKey);
  static List<dynamic> products = [];
  static Map<String, dynamic> productsMap = {};
  static Map<String, dynamic> cart = {};
  static List<dynamic> cart_products_id = [];
  static List<dynamic> cart_keys = [];
  static List<dynamic> categories = [];
  static Map<String, dynamic> user = {};
  static Map<String, dynamic> shop_details = {};
  static String notif_token = '';

  static const APP_NAME = 'Modern Mart';
  static const APP_COLOR = Colors.lightBlueAccent;
  static const APP_LOCATION = 'nandigama';
  static const APP_NAME_ = 'modern_mart';
  static const APP_LATITUDE = 16.76818;
  static const APP_LONGITUDE = 80.29094;

  static writeLocal(String key, Map<String, dynamic> value) async {
    await localStorage.ready;
    await localStorage.setItem(key, value);
    return 1;
  }

  static readLocal(String key) async {
    await localStorage.ready;
    return await localStorage.getItem(key);
  }

  static getImageURL(id) {
    return 'https://firebasestorage.googleapis.com/v0/b/modern-mart.appspot.com/o/Images%2Fmodern_mart_nandigama%2Fproducts%2F' +
        id +
        '?alt=media&token=';
  }

  static showLoadingDialog(BuildContext context, String title) {
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

  static Route createRoute(dest) {
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

  static showAlertDialog(BuildContext context, String title, String message) {
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
}
