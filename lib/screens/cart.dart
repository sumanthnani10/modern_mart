import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../containers/title_text.dart';
import '../service/notification_handler.dart';
import '../storage.dart';
import 'order.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Map<String, dynamic> products = new Map<String, dynamic>();
  List<int> tl = new List<int>();
  List<int> ml = new List<int>();
  int total = 0, mrp = 0;
  bool loading = false;
  int delivery = 0;

  @override
  Widget build(BuildContext context) {
    // print(FirebaseAuth.instance.currentUser.uid);
    tl.length = 0;
    ml.length = 0;
    var date = DateTime.now().add(Duration(days: 2));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: TitleText(
          'Cart',
          cart: true,
          back: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Storage.cart.length != 0
            ? SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List<Widget>.generate(Storage.cart.length, (ind) {
                var t;
                String id = '${Storage.cart_products_id[ind]}';
                String i = Storage.cart_keys[ind];
                int pn = Storage.cart[i]['pn'];
                t = Storage.productsMap[Storage.cart[i]['id']];
                if (t != null) {
                  products[id] = t;
                  products[id].addAll(Storage.cart[i]);
                  if (tl.length > ind) {
                    tl[ind] =
                    (products[id]['dp$pn'] * products[id]['q']);
                    ml[ind] =
                    (products[id]['m$pn'] * products[id]['q']);
                  } else {
                    // print(products[id]['dp$pn']);
                    tl.add(products[id]['dp$pn'] * products[id]['q']);
                    ml.add(products[id]['m$pn'] * products[id]['q']);
                  }
                  mrp = ml.fold(0, (p, c) => p + c);
                  total = tl.fold(0, (p, c) => p + c);
                  /*if (total >= 1000) {
                    delivery = 0;
                  } else {
                    if (Storage.user['d'] <= 1000) {
                      delivery = 25;
                    } else {
                      delivery = 40;
                    }
                  }*/
                }
                return Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  constraints:
                  BoxConstraints(maxWidth: 400, maxHeight: 98),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    progressIndicatorBuilder:
                                        (context, url, progress) =>
                                            CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(child: Text('Image')),
                                    useOldImageOnUrlChange: true,
                                    imageUrl: Storage.getImageURL(
                                            products[id]['id']) +
                                        products[id]['i'],
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 90,
                                  ),
                                ),
                      SizedBox(
                        width: 4,
                      ),
                      Container(
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              products[id]['n'],
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              Storage.categories[products[id]['c']],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54),
                            ),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  products[id]['q$pn'].toString() !=
                                      '0'
                                      ? 'Rs.${products[id]['dp$pn']}/${products[id]['q$pn']}${products[id]['u$pn']}'
                                      : 'Rs.${products[id]['dp$pn']}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                if (products[id]['dp$pn'] !=
                                    products[id]['m$pn'])
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Rs.${products[id]['m$pn']}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.red,
                                            decoration: TextDecoration
                                                .lineThrough,
                                            decorationColor:
                                            Colors.black),
                                        overflow:
                                        TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '(${((products[id]['m$pn'] - products[id]['dp$pn']) / products[id]['m$pn'] * 100).round()}%)',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.green,
                                            fontWeight:
                                            FontWeight.w600),
                                        overflow:
                                        TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  )
                              ],
                            ),
                            Spacer(),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                RupeeText(
                                  amount: products[id]['dp$pn'] *
                                      Storage.cart[i]['q'],
                                  size: 18,
                                  color: Colors.green[800],
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  (products[id]['m$pn'] *
                                      Storage.cart[i]['q'])
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    decoration:
                                    TextDecoration.lineThrough,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              showLoadingDialog(
                                  context, 'Adding to Cart');
                              products[id]['q']++;
                              setState(() {});
                              //CHANGED CART
                              /*await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc('${Storage.user['cid']}')
                                  .collection('cart')
                                  .doc(i)
                                  .update({
                                'q':
                                Storage.cart[i]['q'] +
                                    1,
                              });*/
                                        /*await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc('${Storage.user['cid']}')
                                  .update({
                                'cart.$i.q': Storage.cart[i]['q'] + 1,
                              });*/
                                        Storage.cart['$i']['q'] =
                                            Storage.cart[i]['q'] + 1;
                                        await Storage.writeLocal(
                                            "cart", Storage.cart);
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Colors.black)),
                              child: Icon(
                                Icons.add,
                                color: Colors.green,
                                size: 24,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            Storage.cart[i]['q'].toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () async {
                              showLoadingDialog(
                                  context, 'Removing from Cart');
                              if (Storage.cart[i]['q'] > 1) {
                                products[id]['q']--;
                                setState(() {});
                                //CHANGED CART
                                /*await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc('${Storage.user['cid']}')
                                    .collection('cart')
                                    .doc(i)
                                    .update({
                                  'q':
                                  Storage.cart[i]['q'] -
                                      1,
                                });*/
                                          /*await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc('${Storage.user['cid']}')
                                    .update({
                                  'cart.$i.q':
                                  Storage.cart[i]['q'] - 1,
                                });*/
                                          Storage.cart['$i']['q'] =
                                              Storage.cart[i]['q'] - 1;
                                          await Storage.writeLocal(
                                              "cart", Storage.cart);
                                        } else {
                                products[id] = null;
                                setState(() {});
                                //CHANGED CART
                                /*await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc('${Storage.user['cid']}')
                                    .collection('cart')
                                    .doc(i)
                                    .delete();*/
                                          /*await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc('${Storage.user['cid']}')
                                    .update({
                                  'cart.$i': FieldValue.delete()
                                });*/
                                          Storage.cart.remove('$i');
                                          Storage.cart_products_id = [];
                                          Storage.cart.forEach((_, element) {
                                            Storage.cart_products_id
                                                .add(element['id']);
                                          });
                                          Storage.cart_keys.remove('$i');
                                          await Storage.writeLocal(
                                              "cart", Storage.cart);
                                        }
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Colors.black)),
                              child: Icon(
                                Icons.remove,
                                color: Colors.green,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }).toList() +
                  <Widget>[]),
        )
            : Text('Add products to your cart.'),
      ),
      bottomNavigationBar: Storage.cart.length != 0
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Total:  '),
                    Row(
                      children: <Widget>[
                        RupeeText(
                          amount: total,
                          color: Colors.green,
                          fontWeight: FontWeight.w800,
                          size: 22,
                        ),
                        Text(
                          delivery == 0
                              ? ' (Free Delivery)'
                              : ' + Rs.$delivery (Delivery)',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    if (mrp != total)
                      Row(
                        children: <Widget>[
                          Text(
                            mrp.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                              ' (You Save: ${(((mrp - total) / mrp) * 100).round()}%)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                              )),
                        ],
                      ),
                  ],
                ),
                Spacer(),
                RaisedButton.icon(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.greenAccent,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Place Order'),
                          content: Text('Confirm Your Order?'),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style:
                                  TextStyle(color: Colors.deepOrange),
                                )),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  placeOrder();
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.green),
                                ))
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.done_all,
                      size: 24,
                    ),
                    label: Text(
                      'Checkout',
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            ),
            Text(
              'Your Order will be delivered on or before ${date.day}-${date.month}-${date.year}',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 8,
                ),
                Flexible(
                    child: ImageIcon(
                      AssetImage('assets/payments/phonepe_logo.png'),
                      size: 56,
                    )),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                    child: ImageIcon(
                      AssetImage('assets/payments/paytm_logo.png'),
                      size: 56,
                    )),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                    child: ImageIcon(
                      AssetImage('assets/payments/google_pay_logo.png'),
                      size: 48,
                    )),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                    child: ImageIcon(
                      AssetImage('assets/payments/amazon_pay_logo.png'),
                      size: 64,
                    )),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                    child: Text(
                      'CASH',
                      style: TextStyle(
                          fontSize: 12,
                          height: 1,
                          fontWeight: FontWeight.w800),
                    )),
                SizedBox(
                  width: 8,
                ),
              ],
            )
          ],
        ),
      )
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12))),
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 8,
            ),
            Flexible(
                child: ImageIcon(
                  AssetImage('assets/payments/phonepe_logo.png'),
                  size: 56,
                )),
            SizedBox(
              width: 8,
            ),
            Flexible(
                child: ImageIcon(
                  AssetImage('assets/payments/paytm_logo.png'),
                  size: 56,
                )),
            SizedBox(
              width: 8,
            ),
            Flexible(
                child: ImageIcon(
                  AssetImage('assets/payments/google_pay_logo.png'),
                  size: 48,
                )),
            SizedBox(
              width: 8,
            ),
            Flexible(
                child: ImageIcon(
                  AssetImage('assets/payments/amazon_pay_logo.png'),
                  size: 64,
                )),
            SizedBox(
              width: 8,
            ),
            Flexible(
                child: Text(
                  'Cash on Delivery',
                  style: TextStyle(fontSize: 10, height: 1),
                )),
            SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
      backgroundColor: Storage.APP_COLOR,
    );
  }

  placeOrder() async {
    showLoadingDialog(context, 'Placing Order');
    try {
      var kk = [];
      /*await FirebaseFirestore.instance
        .collection('orders')
        .where('det.cid', isEqualTo: Storage.user['cid'])
        .where('det.stage', whereIn: ['Order Placed', 'Accepted', 'Packed'])
        .get()
        .then((value) => kk = value.docs);*/
      if (true) {
        // if (kk.length == 0) {
        List<Map<String, dynamic>> cart = [];
        List<dynamic> pids = [];
        // cart = Storage.cart.values.toList();
        pids = Storage.cart_products_id.sublist(0);
        Storage.cart.forEach((k, element) {
          cart.add(element);
          // pids.add(element['id']);
        });

        String ntoken = Storage.notif_token;

        Map<String, dynamic> order = {
          'prods': cart,
          'det': {
            'cid': Storage.user['cid'],
            'pid': Storage.APP_NAME_ + '_' + Storage.APP_LOCATION,
            'stage': 'Order Placed',
          },
          'time': {'pla': Timestamp.now()},
          'price': {
            'tot': total,
            'mrp': mrp,
            'sav': (((mrp - total) / mrp) * 100).round(),
            'del': delivery
          },
          'nt': ntoken,
          'len': Storage.cart.length,
        };

        order['id'] = generateOrderId();

        await FirebaseFirestore.instance
            .collection('orders')
            .doc(order['id'])
            .set(order);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(Storage.user['cid'])
            .update({'nt': ntoken, 'ordrd': FieldValue.arrayUnion(pids)});
        //CHANGED CART
        /*var l = Storage.cart;
                        l.forEach((key,e) async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(Storage.user['cid'])
                              .collection('cart')
                              .doc(key)
                              .delete();
                        });*/
        Storage.cart = {};
        Storage.cart_products_id = [];
        Storage.cart_keys = [];
        await Storage.writeLocal("cart", Storage.cart);

        Storage.shop_details['nts'].forEach((e) async {
          await NotificationHandler.instance
              .sendMessage('New Order', "You got a new Order.", e);
        });
        Navigator.pop(context);
        Navigator.of(context)
            .pushReplacement(createRoute(Order(orderdet: order)));
      }
      /*else {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Can\'t place order'),
          content: Text(
              'You already have an order to be delivered. Please order after your previous order is delivered'),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok'))
          ],
        ),
      );
    }*/
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Can\'t place order'),
          content:
              Text('Something went wrong. Please try again after sometime.'),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Ok'))
          ],
        ),
      );
    }
  }

  String generateOrderId() {
    var chars =
        'zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA9876543210zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA9876543210';
    // print(chars.split('').reversed.join(''));
    var t = DateTime.now();
    String id = 'o';
    id += chars[(t.year / 100).round()];
    id += chars[t.year % 100];
    id += chars[t.month];
    id += chars[t.day];
    id += chars[t.hour];
    id += chars[t.minute];
    id += chars[t.second];
    id += chars[t.millisecond % 100];
    return id;
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
}

class RupeeText extends StatelessWidget {
  Color color = Colors.black;
  double size = 16;
  int amount = 0;
  FontWeight fontWeight = FontWeight.normal;
  TextDecoration textDecoration = TextDecoration.none;

  RupeeText({this.amount,
    this.color,
    this.size,
    this.fontWeight,
    this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          '\u20B9 ',
          style: TextStyle(
              fontSize: this.size, color: this.color, fontFamily: 'Roboto'),
        ),
        Text(
          '${this.amount}',
          style: TextStyle(
              fontSize: this.size,
              color: this.color,
              fontWeight: fontWeight,
              decoration: textDecoration),
        ),
      ],
    );
  }
}
