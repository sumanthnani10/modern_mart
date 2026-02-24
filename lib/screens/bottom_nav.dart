import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../containers/title_text.dart';
import '../screens/categories_screen.dart';
import '../screens/order.dart';
import '../screens/products_screen.dart';
import '../screens/profile.dart';
import '../storage.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  List<Color> colors = [
    Color(0xffffaf00),
    Color(0xfffff700),
    Color(0xff00fd5d),
    Colors.cyanAccent,
    Colors.deepOrangeAccent
  ];
  int sel = 0;
  String appBarTitle = 'Home';
  TabController tabController;

  String token;
  final FirebaseMessaging fcm = FirebaseMessaging();

  @override
  void initState() {
    tabController = new TabController(length: 4, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      setState(() {
        int i = tabController.index;
        sel = i;
        if (i == 0) {
          appBarTitle = 'Categories';
        }
        if (i == 1) {
          appBarTitle = 'Store';
        }
        if (i == 2) {
          appBarTitle = 'Home';
        }
        if (i == 3) {
          appBarTitle = 'Profile';
        }
      });
    });
    super.initState();
    init(context);
    getCart();
  }

  getCart() async {
    //CHANGED CART
    /*FirebaseFirestore.instance
        .collection('users')
        .doc('${Storage.user['cid']}')
        .collection('cart')
        .snapshots()
        .listen((value) {
      setState(() {
        Storage.cart = value.docs;
        Storage.cart_products_id.length = 0;
        Storage.cart.forEach((element) {
          Storage.cart_products_id.add(element.data()['id']);
        });
      });
    });*/
    /*FirebaseFirestore.instance
        .collection('users')
        .doc('${Storage.user['cid']}')
        .snapshots()
        .listen((val) {
      Storage.cart = val.data()['cart'];
      Storage.cart_products_id.length = 0;
      Storage.cart.forEach((_, element) {
        Storage.cart_products_id.add(element['id']);
      });
      Storage.cart_keys = Storage.cart.keys.toList();
      setState(() {});
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(72),
          child: TitleText(
            appBarTitle,
            cart: false,
          ),
        ),
        backgroundColor: Storage.APP_COLOR,
        body: TabBarView(
          children: <Widget>[
            CategoriesScreen(),
            ProductsScreen(),
            //Home Screen
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Storage.shop_details['store_name'],
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Order by',
                    style: TextStyle(
                        fontSize: 18, decoration: TextDecoration.underline),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Call',
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      Icon(
                        Icons.call,
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () async {
                          if (await canLaunch(
                              'tel:${Storage.shop_details['mobile']}')) {
                            await launch(
                                'tel:${Storage.shop_details['mobile']}');
                          } else {
                            throw 'Could not launch tel:${Storage.shop_details['mobile']}';
                          }
                        },
                        child: Text(
                          Storage.shop_details['mobile'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Message',
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      Icon(
                        Icons.message,
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () async {
                          if (await canLaunch(
                              'sms:${Storage.shop_details['message']}')) {
                            await launch(
                                'sms:${Storage.shop_details['message']}');
                          } else {
                            throw 'Could not launch sms:${Storage.shop_details['message']}';
                          }
                        },
                        child: Text(
                          Storage.shop_details['message'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Whatsapp',
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      FaIcon(
                        FontAwesomeIcons.whatsapp,
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () async {
                          String url() {
                            if (Platform.isIOS) {
                              return "whatsapp://wa.me/${Storage.shop_details['whatsapp']}";
                            } else {
                              return "whatsapp://send?phone=${Storage.shop_details['whatsapp']}";
                            }
                          }

                          if (await canLaunch(url())) {
                            await launch(url());
                          } else {
                            throw 'Could not launch ${url()}';
                          }
                        },
                        child: Text(
                          Storage.shop_details['whatsapp'],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'App',
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          tabController.animateTo(1);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.mobileAlt,
                                size: 16,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Go to Store',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Profile()
          ],
          controller: tabController,
          physics: BouncingScrollPhysics(),
        ),
        bottomNavigationBar: PersistentBottomNavBar(
          navBarHeight: 64,
          navBarStyle: NavBarStyle.style1,
          decoration: NavBarDecoration(),
          selectedIndex: sel,
          backgroundColor: Colors.white,
          popScreensOnTapOfSelectedTab: false,
          onItemSelected: (i) {
            setState(() {
              sel = i;
              tabController.animateTo(sel);
              if (i == 0) {
                appBarTitle = 'Categories';
              }
              if (i == 1) {
                appBarTitle = 'Store';
              }
              if (i == 2) {
                appBarTitle = 'Home';
              }
              if (i == 3) {
                appBarTitle = 'Profile';
              }
            });
          },
          items: <PersistentBottomNavBarItem>[
            PersistentBottomNavBarItem(
              icon: Icon(
                Icons.view_module,
              ),
              activeColor: Colors.green,
              inactiveColor: Colors.orange,
              title: 'Categories',
            ),
            PersistentBottomNavBarItem(
              icon: Icon(Icons.category),
              activeColor: Colors.green,
              inactiveColor: Colors.orange,
              title: 'Store',
            ),
            PersistentBottomNavBarItem(
              icon: Icon(Icons.home),
              title: 'Home',
              activeColor: Colors.green,
              inactiveColor: Colors.orange,
            ),
            PersistentBottomNavBarItem(
              icon: Icon(Icons.person),
              title: 'Profile',
              activeColor: Colors.green,
              inactiveColor: Colors.orange,
            ),
          ],
        ));
  }

  Future<String> init(context) async {
    fcm.requestNotificationPermissions();
    fcm.configure(onMessage: (message) async {
      int c = 3;
      if (message['data']['type'] == 'stage') {
        switch (message['data']['stage']) {
          case 'Accepted':
            c = 1;
            break;
          case 'Packed':
            c = 2;
            break;
          case 'Delivered':
            c = 3;
            break;
          case 'Rejected':
            c = 4;
            break;
        }
        showSimpleNotification(
            Text(
              message['notification']['body'],
            ),
            autoDismiss: true,
            background: colors[c],
            foreground: Colors.black,
            duration: Duration(seconds: 5),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            position: NotificationPosition.bottom,
            trailing: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Order(id: message['data']['order_id']),
                      ));
                },
                child: Text('Check')));
      } else {
        showSimpleNotification(
          Text(
            message['notification']['body'],
          ),
          autoDismiss: true,
          background: colors[c],
          foreground: Colors.black,
          duration: Duration(seconds: 5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          position: NotificationPosition.bottom,
        );
      }
    }, onResume: (message) async {
      if (message['data']['type'] == 'stage') {
        if (message['data']['order_id'] != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Order(id: message['data']['order_id']),
              ));
        }
      }
    }, onLaunch: (message) async {
      if (message['data']['type'] == 'stage') {
        if (message['data']['order_id'] != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Order(id: message['data']['order_id']),
              ));
        }
      }
    });

    // For testing purposes print the Firebase Messaging token
    token = await fcm.getToken();
    Storage.notif_token = token;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      'nt': token,
    });
    return token;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
