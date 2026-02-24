import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/cart.dart';
import '../storage.dart';
//import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TitleText extends StatelessWidget {
  String title;
  bool cart, back;
  double textSize;

  TitleText(this.title, {this.cart, this.back = false, this.textSize = 32});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      color: Storage.APP_COLOR,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      shadowColor: Colors.black,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: textSize == 32
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: <Widget>[
            if (back)
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 0),
              child: Text(
                title,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: textSize,
                    // fontWeight: FontWeight.w600,
                    fontFamily: 'Gabriola'),
              ),
            ),
            Spacer(),
            if (!cart)
              FlatButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Cart(),
                  ));
                },
                splashColor: Color(0x66a6e553),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                icon: Icon(Icons.shopping_basket),
                label: Text(
                  Storage.cart != null
                      ? Storage.cart.length != 0
                          ? 'Cart (${Storage.cart.length})'
                          : 'Cart'
                      : 'Cart',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

/*
Stack(
alignment: Alignment.topLeft,
children: <Widget>[
Text(
                title,
                style: TextStyle(
                    color: Colors.white38,
                    fontWeight: FontWeight.w800,
                    fontSize: 56),
              ),
Row(
mainAxisAlignment: MainAxisAlignment.start,
crossAxisAlignment: textSize == 32
? CrossAxisAlignment.start
    : CrossAxisAlignment.center,
children: <Widget>[
if (back)
InkWell(
onTap: () {
Navigator.pop(context);
},
child: Padding(
padding: const EdgeInsets.all(12.0),
child: Icon(
Icons.arrow_back,
color: Colors.black,
size: 28,
),
),
),
Padding(
padding: const EdgeInsets.only(left: 8),
child: Text(
title,
style: TextStyle(
color: Colors.black,
fontSize: textSize,
fontWeight: FontWeight.w600,
),
),
),
Spacer(),
if (!cart)
FlatButton.icon(
onPressed: () {
Navigator.of(context).push(MaterialPageRoute(
builder: (context) => Cart(),
));
},
splashColor: Color(0x66a6e553),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16)),
icon: Icon(Icons.shopping_basket),
label: Text(
Storage.cart != null
? Storage.cart.length != 0
? 'Cart (${Storage.cart.length})'
    : 'Cart'
    : 'Cart',
style: TextStyle(
color: Colors.black,
fontSize: 16,
),
),
)
],
),
],
)
*/
