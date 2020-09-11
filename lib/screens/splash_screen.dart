import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../storage.dart';
import '../screens/bottom_nav.dart';
import '../screens/login.dart';
import '../screens/user_details_input.dart';
import '../service/notification_handler.dart';

class SplashScreen extends StatefulWidget {
  final nkey;

  const SplashScreen({Key key, this.nkey}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool gotDetails = false;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() async {
    await Firebase.initializeApp();
    if (FirebaseAuth.instance.currentUser != null) {
      String uid;
      String phone;
      User value = FirebaseAuth.instance.currentUser;
      uid = value.uid;
      phone = value.phoneNumber;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((val) async {
        if (val.data() == null) {
          Navigator.pushReplacement(
              context, createRoute(UserDetailsInput(uid, phone)));
        } else {
          Storage.user = val.data();
          Storage.cart = val.data()['cart'];
          Storage.cart_products_id.length = 0;
          Storage.cart.forEach((_, element) {
            Storage.cart_products_id.add(element['id']);
          });
          Storage.cart_keys = Storage.cart.keys.toList();
          await FirebaseFirestore.instance
              .collection('shop')
              .doc(Storage.APP_NAME_ + '_' + Storage.APP_LOCATION)
              .get()
              .then((value) {
            Storage.shop_details = value.data();
            Storage.categories = [];
            value.data()['categories'].forEach((e) {
              Storage.categories.add(e.toString());
            });
          });
          await FirebaseFirestore.instance
              .collection('shop')
              .doc(val.data()['ar'].toString())
              .collection('prods')
              .orderBy('n')
              .get()
              .then((value) {
            Storage.products = value.docs;
            Storage.productsMap.clear();
            Storage.products.forEach((element) {
              Storage.productsMap[element.id] = element.data();
            });
            /*Storage.products.sort((a, b) {
              return categories.indexOf(a.data()['c']) -
                  categories.indexOf(b.data()['c']);
            });*/
          });
          Navigator.of(context).pushReplacement(createRoute(BottomNavBar()));
        }
      });
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
              Image.network(
                'https://firebasestorage.googleapis.com/v0/b/modern-mart.appspot.com/o/Images%2Fftd_logo.png?alt=media&token=8f3d7a03-67e1-488f-ac61-18a00d12a278',
                width: 100,
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
