import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderContainer extends StatelessWidget {
  Color color, splashColor;
  String orderId, items;
  int itemnumbers;
  String total;
  Timestamp time;
  VoidCallback onTap;

  OrderContainer(
      {Key key,
      @required this.color,
      @required this.splashColor,
      @required this.orderId,
      @required this.itemnumbers,
      @required this.items,
      @required this.onTap,
      @required this.time,
      @required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = time.toDate().toLocal();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Ink(
        width: 340,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(16)),
//            border: Border.all(color: Colors.black12, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0x16000000),
                offset: Offset(1, 1),
                blurRadius: 6,
              ),
              BoxShadow(
                color: const Color(0x16000000),
                offset: Offset(-1, -1),
                blurRadius: 6,
              ),
            ]),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          splashColor: splashColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '#' + orderId,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$itemnumbers items',
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                Text(
                  items,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Placed On: ${t.day}-${t.month}-${t.year} - ${t.hour} : ${t.minute}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Rs.$total',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
