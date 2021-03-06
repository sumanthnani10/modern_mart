import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/cart.dart';
import '../storage.dart';

class Product extends StatefulWidget {
  Map<String, dynamic> product;

  Product({@required this.product});

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  Map<String, dynamic> variants = new Map<String, dynamic>();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 225,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Cart(),
                      ));
                    },
                    splashColor: Color(0x66a6e553),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    icon: Icon(
                      Icons.shopping_basket,
                      size: 14,
                    ),
                    color: Colors.white,
                    label: Text(
                      Storage.cart != null
                          ? Storage.cart.length != 0
                          ? 'Cart (${Storage.cart.length})'
                          : 'Cart'
                          : 'Cart',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              ],
              backgroundColor: Colors.white,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black))),
                child: Carousel(
                  dotBgColor: Colors.transparent,
                  dotColor: Colors.black,
                  dotIncreasedColor: Colors.black,
                  autoplay: false,
                  dotSpacing: 16,
                  dotPosition: DotPosition.bottomLeft,
                  dotIncreaseSize: 1.5,
                  images: <Widget>[
                    CachedNetworkImage(
                      progressIndicatorBuilder: (context, url, progress) =>
                          CircularProgressIndicator(
                        value: progress.progress,
                      ),
                      errorWidget: (context, url, error) =>
                          Center(child: Text('Image')),
                      useOldImageOnUrlChange: true,
                      imageUrl: Storage.getImageURL(widget.product['id']) +
                          widget.product['i'],
                    ),
                    CachedNetworkImage(
                      progressIndicatorBuilder: (context, url, progress) =>
                          CircularProgressIndicator(
                        value: progress.progress,
                      ),
                      errorWidget: (context, url, error) =>
                          Center(child: Text('Image')),
                      useOldImageOnUrlChange: true,
                      imageUrl: Storage.getImageURL(widget.product['id']) +
                          widget.product['i'],
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.product['n'],
                        maxLines: 2,
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        Storage.categories[widget.product['c']],
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Variants :',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(widget.product['p'], (index) {
                          //CHANGED CART
                          /*var t;
                      if ((t = Storage.cart.singleWhere((element) {
                            return element.id ==
                                '${widget.product['id']}${index + 1}';
                          }, orElse: () {
                            return null;
                          })) !=
                          null) {
                        variants[
                                '${widget.product['id']}${index + 1}'] =
                            t.data();
                      } else {
                        variants[
                                '${widget.product['id']}${index + 1}'] =
                            null;
                      }*/
                          if (Storage.cart_keys
                              .contains('${widget.product['id']}${index + 1}')) {
                            variants['${widget.product['id']}${index + 1}'] =
                            Storage.cart['${widget.product['id']}${index + 1}'];
                          } else {
                            variants['${widget.product['id']}${index + 1}'] = null;
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.product['q${index + 1}'].toString() != '0'
                                      ? 'Rs.${widget.product['dp${index + 1}']} - ${widget.product['q${index + 1}']}${widget.product['u${index + 1}']}'
                                      : 'Rs.${widget.product['dp${index + 1}']}',
                                  style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                if (widget.product['dp${index + 1}'] !=
                                    widget.product['m${index + 1}'])
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Rs.${widget.product['m${index + 1}']}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            decoration: TextDecoration.lineThrough,
                                            decorationColor: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '${((widget.product['m${index + 1}'] - widget.product['dp${index + 1}']) / widget.product['m${index + 1}'] * 100).round()}%',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                Spacer(),
                                if (widget.product['s'] &&
                                    variants[
                                    '${widget.product['id']}${index + 1}'] ==
                                        null)
                                  RaisedButton.icon(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)),
                                      color: Storage.APP_COLOR,
                                      onPressed: () async {
                                        showLoadingDialog(
                                            context, 'Adding to Cart');
                                        //CHANGED CART
                                        /*await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(
                                            '${Storage.user['cid']}')
                                        .collection('cart')
                                        .doc(
                                            '${widget.product['id']}${index + 1}')
                                        .set({
                                      'id':
                                          widget.product['id'],
                                      'pn': index + 1,
                                      'q': 1,
                                    });*/
                                    /*await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc('${Storage.user['cid']}')
                                            .update({
                                          'cart.${widget.product['id']}${index + 1}':
                                          {
                                            'id': widget.product['id'],
                                            'pn': index + 1,
                                            'q': 1,
                                          }
                                        });*/
                                    Storage.cart[
                                        '${widget.product['id']}${index + 1}'] = {
                                      'id': widget.product['id'],
                                      'pn': index + 1,
                                      'q': 1,
                                    };
                                    Storage.cart_products_id
                                        .add('${widget.product['id']}');
                                    Storage.cart_keys.add(
                                        '${widget.product['id']}${index + 1}');
                                    await Storage.writeLocal(
                                        "cart", Storage.cart);
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                      icon: Icon(
                                        Icons.shopping_basket,
                                        size: 16,
                                      ),
                                      label: Text(
                                        'Add to cart',
                                        style: TextStyle(fontSize: 12),
                                      )),
                                if (widget.product['s'] &&
                                    variants[
                                    '${widget.product['id']}${index + 1}'] !=
                                        null)
                                  Row(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () async {
                                          if (variants[
                                          '${widget.product['id']}${index + 1}']
                                          ['q'] !=
                                              1) {
                                            showLoadingDialog(
                                                context, 'Updating Cart');
                                            //CHANGED CART
                                            /*await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(
                                                '${Storage.user['cid']}')
                                            .collection('cart')
                                            .doc(
                                                '${widget.product['id']}${index + 1}')
                                            .update({
                                          'q': variants[
                                                      '${widget.product['id']}${index + 1}']
                                                  ['q'] -
                                              1,
                                        });*/
                                        /*await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc('${Storage.user['cid']}')
                                                .update({
                                              'cart.${widget.product['id']}${index + 1}.q':
                                              variants['${widget.product['id']}${index + 1}']
                                              ['q'] -
                                                  1
                                            });*/
                                        Storage.cart[
                                            '${widget.product['id']}${index + 1}'] = {
                                          'id': widget.product['id'],
                                          'pn': index + 1,
                                          'q': variants[
                                                      '${widget.product['id']}${index + 1}']
                                                  ['q'] -
                                              1,
                                        };
                                        await Storage.writeLocal(
                                            "cart", Storage.cart);
                                        Navigator.pop(context);
                                      } else {
                                            showLoadingDialog(
                                                context, 'Removing from Cart');
                                            //CHANGED CART
                                            /*await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(
                                                '${Storage.user['cid']}')
                                            .collection('cart')
                                            .doc(
                                                '${widget.product['id']}${index + 1}')
                                            .delete();*/
                                        /*await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc('${Storage.user['cid']}')
                                                .update({
                                              'cart.${widget.product['id']}${index + 1}':
                                              FieldValue.delete()
                                            });*/
                                        Storage.cart.remove(
                                            '${widget.product['id']}${index + 1}');
                                        /*Storage.cart_products_id = [];
                                            Storage.cart.forEach((_, element) {
                                              Storage.cart_products_id.add(element['id']);
                                            });*/
                                        Storage.cart_products_id
                                            .remove('${widget.product['id']}');
                                        Storage.cart_keys.remove(
                                            '${widget.product['id']}${index + 1}');
                                        await Storage.writeLocal(
                                            "cart", Storage.cart);
                                        Navigator.pop(context);
                                      }
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(4),
                                              border:
                                              Border.all(color: Colors.black)),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.blue,
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        variants['${widget.product['id']}${index + 1}']
                                        ['q']
                                            .toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          showLoadingDialog(
                                              context, 'Updating Cart');
                                          //CHANGED CART
                                          /*await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(
                                              '${Storage.user['cid']}')
                                          .collection('cart')
                                          .doc(
                                              '${widget.product['id']}${index + 1}')
                                          .update({
                                        'q': variants[
                                                    '${widget.product['id']}${index + 1}']
                                                ['q'] +
                                            1,
                                      });*/
                                      /*await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc('${Storage.user['cid']}')
                                              .update({
                                            'cart.${widget.product['id']}${index + 1}.q':
                                            variants['${widget.product['id']}${index + 1}']
                                            ['q'] +
                                                1
                                          });*/
                                      Storage.cart[
                                          '${widget.product['id']}${index + 1}'] = {
                                        'id': widget.product['id'],
                                        'pn': index + 1,
                                        'q': variants[
                                                    '${widget.product['id']}${index + 1}']
                                                ['q'] +
                                            1,
                                      };
                                      await Storage.writeLocal(
                                          "cart", Storage.cart);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(4),
                                              border:
                                              Border.all(color: Colors.black)),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.blue,
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (!widget.product['s'])
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8))),
                                        onPressed: () {},
                                        child: Text('Out Of Stock')),
                                  )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Description :',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        widget.product['d'] == ''
                            ? '    No description'
                            : '    ' + widget.product['d'],
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
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
