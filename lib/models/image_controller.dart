import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'inventory_controller.dart';

Future<String> urlStatusCode(imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 404) {
    //print(imageUrl);
    return '404';
  } else {
    //print(imageUrl);
    return '200';
  }
}

Future<bool> imageExists(String upc) async {
  final _dirPath = await localPath();

  final imageFile = File('$_dirPath/$upc');
  return imageFile.exists().then((value) {
    if (value == true) {
      //print('true');
      return true;
    } else {
      //print('false');
      return false;
    }
  });
  // if (await imageFile.existsSync() == true) {
  //   print('true');
  //   return 'true';
  // } else {
  //   //print('false');
  //   return 'false';
  // }
}

Future<String?> saveImage(String upc) async {
  final _dirPath = await localPath();
  //print(await _localPath());

  final imageFile = File('$_dirPath/$upc');
  final imageUrl = 'https://www.kroger.com/product/images/medium/front/' + upc;

  http.Response response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 404) {
    return 'false';
  }
  final image = response.bodyBytes;
  //print('file saved to $_dirPath/product_images/$upc');
  imageFile.writeAsBytes(image).then((value) {
    return 'true';
  });

  return 'true';
  //print('file saved to' + '$_dirPath/product_images/$upc');
  //return imageUrl;
  // print('file saved to' + '$_dirPath/product_images/$upc');
  // return imageUrl;
  //await imageFile.writeAsBytes(image);
}

Future<File> loadImageFilePath(String upc) async {
  final _dirPath = await localPath();
  //print('$_dirPath/$upc');
  final imageFile = File('$_dirPath/$upc');
  return imageFile;
}
