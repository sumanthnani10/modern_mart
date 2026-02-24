import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modern_mart/screens/cart.dart';

import '../screens/product_view_screen.dart';
import '../storage.dart';

class Order extends StatefulWidget {
  Map<String, dynamic> orderdet;
  String id;

  Order({this.orderdet, this.id});

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Map<String, dynamic> order;
  String id;
  bool loaded = true;

  @override
  void initState() {
    // print(id);
    order = widget.orderdet ?? {};
    id = widget.id;
    if (id != null) {
      loaded = false;
      order['id'] = id;
      getOrder();
    }
    super.initState();
  }

  getOrder() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(order['id'])
        .get()
        .then((e) {
      if (mounted) {
        setState(() {
          order = e.data();
          loaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0.12;
    if (loaded) {
      switch (order['det']['stage']) {
        case 'Accepted':
          progress = 0.36;
          break;
        case 'Packed':
          progress = 0.64;
          break;
        case 'Delivered':
          progress = 1;
          break;
        case 'Rejected':
          progress = 1;
          break;
      }
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Storage.APP_COLOR,
        title: Text(
          'Order Id: #' + order['id'],
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        titleSpacing: 0,
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Storage.showLoadingDialog(context, 'Loading');
              await getOrder();
              Navigator.pop(context);
            },
            label: Text(
              'Reload',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: loaded
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                          Container(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    //0.12,0.36,0.64,1
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        order['det']['stage'] != 'Rejected'
                                            ? Colors.blue
                                            : Colors.redAccent),
                                  ),
                                ),
                                if (order['det']['stage'] != 'Rejected')
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Placed',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                            CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.white,
                                            ),
                                            Text(
                                              '${order['time']['pla'].toDate().hour > 12 ? order['time']['pla'].toDate().hour - 12 : order['time']['pla'].toDate().hour}:${order['time']['pla'].toDate().minute} ${order['time']['pla'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['pla'].toDate().day}-${order['time']['pla'].toDate().month}-${order['time']['pla'].toDate().year}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Accepted',
                                              style: TextStyle(
                                                  fontWeight: order['time']
                                                              ['acc'] !=
                                                          null
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                  fontSize: 14),
                                            ),
                                            CircleAvatar(
                                              radius:
                                                  order['time']['acc'] != null
                                                      ? 10
                                                      : 6,
                                              backgroundColor:
                                                  order['time']['acc'] != null
                                                      ? Colors.white
                                                      : Colors.grey,
                                            ),
                                            Text(
                                              order['time']['acc'] != null
                                                  ? '${order['time']['acc'].toDate().hour > 12 ? order['time']['acc'].toDate().hour - 12 : order['time']['acc'].toDate().hour}:${order['time']['acc'].toDate().minute} ${order['time']['acc'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['acc'].toDate().day}-${order['time']['acc'].toDate().month}-${order['time']['acc'].toDate().year}'
                                                  : '\n',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Packed',
                                              style: TextStyle(
                                                  fontWeight: order['time']
                                                              ['pac'] !=
                                                          null
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                  fontSize: 14),
                                            ),
                                            CircleAvatar(
                                              radius:
                                                  order['time']['pac'] != null
                                                      ? 10
                                                      : 6,
                                              backgroundColor:
                                                  order['time']['pac'] != null
                                                      ? Colors.white
                                                      : Colors.grey,
                                            ),
                                            Text(
                                              order['time']['pac'] != null
                                                  ? '${order['time']['pac'].toDate().hour > 12 ? order['time']['pac'].toDate().hour - 12 : order['time']['pac'].toDate().hour}:${order['time']['pac'].toDate().minute} ${order['time']['pac'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['pac'].toDate().day}-${order['time']['pac'].toDate().month}-${order['time']['pac'].toDate().year}'
                                                  : '\n',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Delivered',
                                              style: TextStyle(
                                                  fontWeight: order['time']
                                                              ['del'] !=
                                                          null
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                  fontSize: 14),
                                            ),
                                            CircleAvatar(
                                              radius:
                                                  order['time']['del'] != null
                                                      ? 10
                                                      : 6,
                                              backgroundColor:
                                                  order['time']['del'] != null
                                                      ? Colors.white
                                                      : Colors.grey,
                                            ),
                                            Text(
                                              order['time']['del'] != null
                                                  ? '${order['time']['del'].toDate().hour > 12 ? order['time']['del'].toDate().hour - 12 : order['time']['del'].toDate().hour}:${order['time']['del'].toDate().minute} ${order['time']['del'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['del'].toDate().day}-${order['time']['del'].toDate().month}-${order['time']['del'].toDate().year}'
                                                  : '\n',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                if (order['det']['stage'] == 'Rejected')
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Placed',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                            CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.white,
                                            ),
                                            Text(
                                              '${order['time']['pla'].toDate().hour > 12 ? order['time']['pla'].toDate().hour - 12 : order['time']['pla'].toDate().hour}:${order['time']['pla'].toDate().minute} ${order['time']['pla'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['pla'].toDate().day}-${order['time']['pla'].toDate().month}-${order['time']['pla'].toDate().year}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Rejected',
                                              style: TextStyle(
                                                  fontWeight: order['time']
                                                              ['rej'] !=
                                                          null
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                  fontSize: 14),
                                            ),
                                            CircleAvatar(
                                              radius:
                                                  order['time']['rej'] != null
                                                      ? 10
                                                      : 6,
                                              backgroundColor:
                                                  order['time']['rej'] != null
                                                      ? Colors.white
                                                      : Colors.grey,
                                            ),
                                            Text(
                                              order['time']['rej'] != null
                                                  ? '${order['time']['rej'].toDate().hour > 12 ? order['time']['rej'].toDate().hour - 12 : order['time']['rej'].toDate().hour}:${order['time']['rej'].toDate().minute} ${order['time']['rej'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['rej'].toDate().day}-${order['time']['rej'].toDate().month}-${order['time']['rej'].toDate().year}'
                                                  : '\n',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Address:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${Storage.user['fn']} ${Storage.user['ln']}\n${Storage.user['a']}'),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Products:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              if (order['det']['stage'] == 'Order Placed')
                                TextButton.icon(
                                  onPressed: () async {
                                    await Storage.showLoadingDialog(
                                        context, 'Loading');
                                    await getOrder();
                                    if (order['det']['stage'] ==
                                        'Order Placed') {
                                      Storage.cart.clear();
                                      Storage.cart = {};
                                      Storage.cart_products_id.clear();
                                      Storage.cart_products_id = [];
                                      Storage.cart_keys.clear();
                                      Storage.cart_keys = [];

                                      order['prods'].forEach((p) {
                                        Storage.cart['${p['id']}${p['pn']}'] =
                                            p;
                                        Storage.cart_products_id
                                            .add('${p['id']}');
                                        Storage.cart_keys
                                            .add('${p['id']}${p['pn']}');
                                      });

                                      await Storage.writeLocal(
                                          "cart", Storage.cart);

                                      await FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(order['id'])
                                          .delete();

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          Storage.createRoute(Cart()),
                                          (r) => !r.hasActiveRouteBelow);
                                    } else {
                                      Navigator.pop(context);
                                      Storage.showAlertDialog(
                                          context,
                                          "Cannot change",
                                          "Order has been received already.");
                                    }
                                  },
                                  label: Text(
                                    'Change Order',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  icon: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.black,
                                  ),
                                )
                            ],
                          )
                        ] +
                        List<Widget>.generate(order['len'], (i) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(createRoute(Product(
                                product: Storage
                                    .productsMap[order['prods'][i]['id']],
                              )));
                            },
                            child: Container(
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
                                              Storage.productsMap[order['prods']
                                                  [i]['id']]['id']) +
                                          Storage.productsMap[order['prods'][i]
                                              ['id']]['i'],
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 90,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Container(
                                    width: 220,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          Storage.productsMap[order['prods'][i]
                                              ['id']]['n'],
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          Storage.categories[
                                              Storage.productsMap[order['prods']
                                                  [i]['id']]['c']],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          'Qty: ${order['prods'][i]['q']}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })),
              ),
            )
          : LinearProgressIndicator(),
      bottomNavigationBar: loaded
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Total:  '),
                  Row(
                    children: <Widget>[
                      RupeeText(
                        amount: order['price']['tot'],
                        color: Colors.green,
                        fontWeight: FontWeight.w800,
                        size: order['price']['del'] != 0 ? 24 : 22,
                      ),
                      if (order['price']['del'] != 0)
                        Text(
                          ' + Rs.${order['price']['del']} (Delivery)',
                          style: TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                  if (order['price']['sav'] != 0)
                    Row(
                      children: <Widget>[
                        Text(
                          order['price']['mrp'].toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(' (You Save: ${order['price']['sav']}%)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                            )),
                      ],
                    ),
                ],
              ),
            )
          : Container(),
      backgroundColor: Storage.APP_COLOR,
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

  RupeeText(
      {this.amount,
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
