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
  /// FCM server key must NEVER be in client code. Use a backend (e.g. Cloud
  /// Functions) to send notifications. Pass via --dart-define only for local
  /// dev; rotate the key immediately if it was ever committed.
  String serverToken =
      String.fromEnvironment('FCM_SERVER_KEY', defaultValue: '');

  NotificationHandler._();

  factory NotificationHandler() => instance;
  static final NotificationHandler instance = NotificationHandler._();

  Future<void> sendMessage(title, body, nt) async {
    if (serverToken.isEmpty) return;
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
