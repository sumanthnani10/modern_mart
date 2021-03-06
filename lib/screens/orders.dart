import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../containers/order_container.dart';
import '../screens/order.dart';
import '../storage.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Color> colors = [
    Color(0xffffaf00),
    Color(0xfffff700),
    Color(0xff00fd5d),
    Colors.cyanAccent,
    Colors.deepOrangeAccent
  ];
  List<Color> splashColors = [
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.deepOrange,
  ];

  bool gotOrders = false;

  List<DocumentSnapshot> orders;

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  getOrders() async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .where('det.cid', isEqualTo: Storage.user['cid'])
          .get()
          .then((value) {
        orders = value.docs;
        // print(orders.length);
        orders.sort((a, b) {
          if (b
              .data()['time']['pla']
              .toDate()
              .isBefore(a.data()['time']['pla'].toDate()))
            return -1;
          else
            return 1;
        });
      });
      setState(() {
        gotOrders = true;
      });
    } catch (e) {
      orders = [];
      setState(() {
        gotOrders = true;
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Orders',
          style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontFamily: 'Gabriola' /* fontWeight: FontWeight.w600*/),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 113,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xffffaf00),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topLeft: Radius.circular(8))),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Placed',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 113,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xfffff700),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Accepted',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 113,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xff00fd5d),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Packed',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 84.75,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topLeft: Radius.circular(8))),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Delivered',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 84.75,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Rejected',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              if (orders == null) LinearProgressIndicator(),
              if (orders != null && orders.length == 0) Text('No Orders'),
              if (orders != null && orders.length != 0)
                ListView.builder(
                    itemCount: orders.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (_, index) {
                      var snap = orders[index].data();
                      int c = 0;
                      switch (snap['det']['stage']) {
                        case 'Order Placed':
                          c = 0;
                          break;
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
                      String items = '';
                      // print(snap);
                      snap['prods'].forEach((e) {
                        items += '${Storage.productsMap[e['id']]['n']}, ';
                      });
                      items = items.substring(0, items.length - 2) + ' .';
                      return OrderContainer(
                        onTap: () {
                          Navigator.of(context).push(createRoute(Order(
                            orderdet: snap,
                          )));
                        },
                        time: snap['time']['pla'],
                        splashColor: splashColors[c],
                        color: colors[c],
                        orderId: '${snap['id']}',
                        itemnumbers: snap['len'],
                        items: items,
                        total: '${snap['price']['tot']}',
                      );
                    })
              /*Column(
                        children: List.generate(snapshot.data().documents.length,
                            (index) {
                          var snap = snapshot.documents[index].data();
                          return OrderContainer(
                              onTap: () {
                                Navigator.of(context).push(createRoute(ItemList(
                                  snap: snap,
                                )));
                              },
                              splashColor: Colors.orange,
                              color: Color(0xffffaf00),
                              customerName: snap['det']['cid'],
                              itemnumbers: snap['len'],
                              items:
                                  'Small Fresh Fish,Handmade Granite Keyboard,Handmade');
                        }),
                      );*/
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
