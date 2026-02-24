import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../config.dart';
import '../screens/bottom_nav.dart';
import '../screens/login.dart';
import '../screens/user_details_input.dart';
import '../storage.dart';

class SplashScreen extends StatefulWidget {
  final nkey;

  const SplashScreen({Key key, this.nkey}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool gotDetails = false;
  LocalStorage storage = new LocalStorage('${Storage.localStorageKey}');

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() async {
    await Firebase.initializeApp();
    await storage.ready;
    if (FirebaseAuth.instance.currentUser != null) {
      String uid;
      String phone;
      User value = FirebaseAuth.instance.currentUser;
      uid = value.uid;
      phone = value.phoneNumber;
      var user = await storage.getItem("user");
      if (user == null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get()
            .then((val) async {
          if (val.data() == null) {
            Navigator.pushReplacement(
                context, createRoute(UserDetailsInput(uid, phone)));
          } else {
            user = val.data();
            await storage.setItem("user", user);
            await storage.setItem("cart", <String, dynamic>{});
          }
        });
      } else if (user["cid"] != uid) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get()
            .then((val) async {
          if (val.data() == null) {
            Navigator.pushReplacement(
                context, createRoute(UserDetailsInput(uid, phone)));
          } else {
            user = val.data();
            await storage.setItem("user", user);
            await storage.setItem("cart", <String, dynamic>{});
          }
        });
      }
      Storage.user = user;
      Storage.cart = await storage.getItem("cart") ?? <String, dynamic>{};
      Storage.cart_products_id.length = 0;
      Storage.cart.forEach((_, element) {
        Storage.cart_products_id.add(element['id']);
      });
      Storage.cart_keys = Storage.cart.keys.toList();

      int curr = DateTime.now().millisecondsSinceEpoch;
      var last = await FirebaseDatabase.instance
          .reference()
          .child('last_edit_products')
          .once();
      // print(last.value);
      int last_edit_products = last.value ?? curr;
      // print(last_edit_products);
      last = await FirebaseDatabase.instance
          .reference()
          .child('last_edit_shop')
          .once();
      // print(last.value);
      int last_edit_shop = last.value ?? curr;

      var lastRead = await storage.getItem("last_read_shop") ?? {"value": 0};

      // print(lastRead);
      // print(lastRead['value']);

      if (last_edit_shop > lastRead["value"] ?? 0) {
        // print(1);
        await FirebaseFirestore.instance
            .collection('shop')
            .doc(Storage.APP_NAME_ + '_' + Storage.APP_LOCATION)
            .get()
            .then((value) async {
          Storage.shop_details = value.data();
          Storage.categories = [];
          value.data()['categories'].forEach((e) {
            Storage.categories.add(e.toString());
          });
          await storage.setItem("shop", Storage.shop_details);
          await storage.setItem("categories", {"cats": Storage.categories});
          await storage.setItem("last_read_shop",
              {"value": DateTime.now().millisecondsSinceEpoch});
        });
      } else {
        // print(2);
        Storage.shop_details = await storage.getItem("shop");
        var r = await storage.getItem("categories") ?? {"cats": []};
        Storage.categories = r['cats'];
      }

      lastRead = await storage.getItem("last_read_products") ?? {"value": 0};

      // print(lastRead);
      // print(lastRead['value']);

      if (last_edit_products > lastRead["value"] ?? 0) {
        // print(1);
        await FirebaseFirestore.instance
            .collection('shop')
            .doc(user['ar'].toString())
            .collection('prods')
            .orderBy('n')
            .get()
            .then((value) async {
          Storage.productsMap = {};
          value.docs.forEach((element) {
            Storage.productsMap[element.id] = element.data();
            Storage.productsMap[element.id]['o'] =
                Storage.productsMap[element.id]['o'].millisecondsSinceEpoch;
            Storage.products.add(Storage.productsMap[element.id]);
          });
          await storage.setItem("products", Storage.productsMap);
          await storage.setItem("last_read_products",
              {"value": DateTime.now().millisecondsSinceEpoch});
        });
      } else {
        // print(2);
        Storage.productsMap = await storage.getItem("products");
        // print(Storage.productsMap);
        Storage.products = Storage.productsMap.values.toList();
      }
      Navigator.of(context).pushReplacement(createRoute(BottomNavBar()));
    } else {
      Navigator.of(context).pushReplacement(createRoute(Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: /*Color(0xffffaf00)*/ Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*Text(
                Storage.APP_NAME,
                style: TextStyle(color: Colors.white, fontSize: 64),
              ),*/
              Spacer(),
              Container(
                height: 300,
                child: Image.asset(
                  'assets/logo/foreground.png',
                  width: 300,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Storage.APP_COLOR),
                  )),
              Spacer(),
              splashLogoToken.isNotEmpty
                  ? CachedNetworkImage(
                      progressIndicatorBuilder: (context, url, progress) =>
                          CircularProgressIndicator(
                        value: progress.progress,
                      ),
                      errorWidget: (context, url, error) =>
                          Center(child: Text('FTD')),
                      useOldImageOnUrlChange: true,
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/modern-mart.appspot.com/o/Images%2Fftd_logo.png?alt=media&token=$splashLogoToken',
                      width: 100,
                    )
                  : Center(
                      child: Text('FTD',
                          style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
              SizedBox(
                height: 8,
              )
            ],
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
        var begin = Offset(0, 1);
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
