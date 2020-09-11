import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../screens/cart.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationHandler {
  List<Color> colors = [
    Color(0xffffaf00),
    Color(0xfffff700),
    Color(0xff00fd5d),
    Colors.cyanAccent,
    Colors.deepOrangeAccent
  ];
  String serverToken =
      'AAAAzy-D9pI:APA91bEEV7znT__t-8EMXD8e1ftgrOwMSscndEhe9VO5pXwJkowLe2NHLQE9BHNv0zUIQapQA_njS04khM5LMVQRbYevE9XXr74GcbXpFS5VU7mRAO2M2J2eBYbKCoKOOLTZmg8dZ6Tw';

  NotificationHandler._();

  factory NotificationHandler() => instance;
  static final NotificationHandler instance = NotificationHandler._();

  Future<void> sendMessage(title, body, nt) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': nt,
        },
      ),
    );
  }
}
