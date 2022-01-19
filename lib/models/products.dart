import 'package:flutter/material.dart';

//import 'package:flutter/material.dart';
class Product {
  int id;
  String name;
  String category;
  String image;
  String upc;
  double count;
  bool visible;

  Product(
      {required this.id,
      required this.name,
      required this.category,
      required this.image,
      required this.upc,
      required this.count,
      required this.visible});

  bool get isOrganic {
    if (upc.toString()[0] == "9") {
      return true;
    } else {
      return false;
    }
  }

  bool get isVisible {
    //
    return visible;
  }

  bool get isPackaged {
    if (upc.toString().length > 5) {
      return true;
    } else {
      return false;
    }
  }

  String get getCount {
    String countString;
    bool isInteger(num value) => (value % 1) == 0;

    if (isInteger(count) == true) {
      countString = count.toDouble().toStringAsFixed(0);
    } else {
      countString = count.toString();
    }
    return countString;
  }
}
