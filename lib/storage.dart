import 'package:flutter/material.dart';

class Storage {
  static List<dynamic> products;
  static Map<String, dynamic> productsMap = new Map<String, dynamic>();
  static Map<String, dynamic> cart;
  static List<dynamic> cart_products_id = [];
  static List<dynamic> cart_keys = [];
  static List<dynamic> categories = [];
  static Map<String, dynamic> user;
  static Map<String, dynamic> shop_details;
  static String notif_token = '';

  static const APP_NAME = 'Modern Mart';
  static const APP_COLOR = Colors.lightBlueAccent;
  static const APP_LOCATION = 'nandigama';
  static const APP_NAME_ = 'modern_mart';
  static const APP_LATITUDE = 16.76818;
  static const APP_LONGITUDE = 80.29094;

  static getImageURL(id) {
    return 'https://firebasestorage.googleapis.com/v0/b/modern-mart.appspot.com/o/Images%2Fmodern_mart_nandigama%2Fproducts%2F' +
        id +
        '?alt=media&token=';
  }
}
