import 'dart:async';
import 'dart:convert';
import 'dart:developer';
//import 'dart:developer';
//import 'dart:html';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:orderguide/models/image_controller.dart';
import 'package:orderguide/models/upc.dart';
import 'package:path_provider/path_provider.dart';

//import '../pages/inventory.dart';

List _categories = [];
List _products = [];

Future<String> localPath() async {
  var directory;
  if (Platform.isIOS) {
    directory = await getApplicationSupportDirectory();
  } else {
    directory = await getApplicationDocumentsDirectory();
  }

  return directory.path;
}

Future<dynamic> readJson() async {
  final _dirPath = await localPath();
  final _myFile = File('$_dirPath/inventory.json');

  //final String response =
  //    await rootBundle.loadString('inventory.json');
  //print((await _myFile.exists()).toString());
  if (await _myFile.exists() == false) {
    //print('file Doesnt Exist');
    // await createJson().then((value) async {
    //   final _json = jsonDecode(value);
    //   //print(_json);
    //   return _json;
    // });
    final _json = jsonDecode(await createJson());

    return _json;
  } else {
    final _data = await _myFile.readAsString(encoding: utf8);
    final _json = jsonDecode(_data);

    return _json;
    //print(_data);
    //print(_json);
    //print(_json["categories"]);

    //InventoryData(_categories, _products);

    //setState(() {
    //  _categories = _json["categories"];
    //  _products = _json["products"];
    // setupAddNewProduct();
    //});
  }
}

Future<dynamic> createJson() async {
  final _dirPath = await localPath();
  if (await File('$_dirPath/inventory.json').exists() == false) {
    final _loadedData =
        await rootBundle.loadString('assets/initial_inventory.json');
    writeData(_loadedData);
    return _loadedData;
    //print('Inventory File Created');
    //readJson();
  } else {
    //print('Inventory File Exists');
  }
}

Future<void> writeData(String fileToWrite) async {
  final _dirPath = await localPath();
  //print(await localPath());

  final _jsonFile = File('$_dirPath/inventory.json');

  await _jsonFile.writeAsString(fileToWrite);
}

Future<void> updateProduct(int id, String category, String name, String upc,
    Function? refresh, String? setCategory) async {
  final _readJson = await readJson();
  _products = _readJson['products'];
  final currentProductIndex =
      _products.indexWhere((element) => element['id'] == id);

  _products[currentProductIndex]['category'] = category;
  _products[currentProductIndex]['name'] = name;
  _products[currentProductIndex]['upc'] = upc;
  _products[currentProductIndex]['image'] = '';
  writeJson(_products);
  refresh!(true, true, setCategory);
}

Future<void> writeJson(List products) async {
  var _data = {"products": products};
  //print(_data);
  final json = jsonEncode(_data);
  //print(combineJson);
  //log(combineJson.toString());
  await writeData(json);
}

Future<void> addProduct(String category, String name, String upc,
    [Function? refresh, String? setCategory]) async {
  final _readJson = await readJson();
  _products = _readJson['products'];
  var largestValue = 0;

  for (var e in _products) {
    if (e['id'] is String) {
      if (int.parse(e['id']) > largestValue) {
        largestValue = int.parse(e['id']);
      }
    } else {
      if (e['id'] > largestValue) {
        largestValue = e['id'];
      }
    }
  }
  if (upc.length == 13) {
    if (upc[0] == '0' &&
        upc[1] == '0' &&
        upc[2] == '0' &&
        upc[3] == '0' &&
        upc[4] == '0' &&
        upc[5] == '0' &&
        upc[6] == '0' &&
        upc[7] == '0') {
      if (upc[8] == '0') {
        upc = upc[9] + upc[10] + upc[11] + upc[12];
      } else {
        upc = upc[8] + upc[9] + upc[10] + upc[11] + upc[12];
      }
    }
  }
  largestValue++;
  final _newId = largestValue;
  final _newProduct = {
    "id": (_newId),
    "category": category,
    "name": name,
    "upc": upc,
    "count": 0
  };
  final lastProductCategoryIndex =
      _products.lastIndexWhere((element) => element['category'] == category);
  //print(lastProductCategoryIndex);
  //print(_newProduct);
  if (lastProductCategoryIndex == -1) {
    _products.add(_newProduct);
  } else {
    _products.insert(lastProductCategoryIndex + 1, _newProduct);
  }
  //print(_products);
  //print(_categories);
  writeJson(_products);
  refresh!(true, true, setCategory);
}

Future<void> writeImageLocationToJson() async {
  final _readJson = await readJson();
  final _dirPath = await localPath();
  _products = _readJson['products'];
  //print(_products);
  //Future.forEach(_products, (element) async {

  for (var element in _products) {
    final elementUpc = element['upc'].toString();
    final fullUpc = createFullUpc(elementUpc);

    if (element['image'] == '' || element['image'] == null) {
      //print('image doesnt exist');
      final imageExistsence = await imageExists(fullUpc);
      if (imageExistsence == true) {
        //print('image exists. added to json');
        element['image'] = "$_dirPath/$fullUpc";
      } else {
        if (await saveImage(fullUpc) == 'true') {
          element['image'] = "$_dirPath/$fullUpc";
          //print('image doesnt exist. downloaded and added to json');
        }
      }
    } else {
      final imagePath = _dirPath + fullUpc;
      final currentImageUpc =
          imagePath.substring(imagePath.length - elementUpc.length);
      if (currentImageUpc != elementUpc) {
        //print('image didnt match current upc. downloaded and replaced in json');
        if (await saveImage(fullUpc) == 'true') {
          element['image'] = _dirPath + fullUpc;
        }
        element['image'] = _dirPath + fullUpc;
      }
    }
  }
  writeJson(_products);
  //log(_products.toString());
  log('images saved to Json');
}

// Future<void> addCategory(String name, Function refresh) async {
//   final _readJson = await readJson();
//   _categories = _readJson['categories'];
//   _products = _readJson['products'];
//   var largestValue = 0;

//   _categories.forEach((e) {
//     if (e['id'] is String) {
//       if (int.parse(e['id']) > largestValue) {
//         largestValue = int.parse(e['id']);
//       }
//     } else {
//       if (e['id'] > largestValue) {
//         largestValue = e['id'];
//       }
//     }
//   });
//   largestValue++;
//   final _newId = largestValue;
//   final _newCategory = {"id": _newId, "name": name};

//   _categories.add(_newCategory);
//   writeJson(_products);
//   refresh();
// }

Future<void> removeProduct(id, Function refresh) async {
  final _readJson = await readJson();
  _products = _readJson['products'];

  _products.removeWhere((item) => item['id'] == id);

  writeJson(_products);
  refresh(true, true);
}

Future<void> toggleProductVisibility(id, Function refresh) async {
  final _readJson = await readJson();
  _products = _readJson['products'];
  final currentProductIndex =
      _products.indexWhere((element) => element['id'] == id);
  final currentVisibleBool = _products[currentProductIndex]['visible'];
  bool visibleBool = false;
  //print("visiblility is set to $currentVisibleBool");
  if (currentVisibleBool != null) {
    switch (currentVisibleBool) {
      case true:
        visibleBool = false;
        break;
      case false:
        visibleBool = true;
        break;
    }
  } else {
    visibleBool = false;
  }
  _products[currentProductIndex]['visible'] = visibleBool;

  writeJson(_products);
  //refresh(true);
}

Future<void> removeCategory(id, Function refresh) async {
  final _readJson = await readJson();
  _products = _readJson['products'];

  _categories.removeWhere((item) => item['id'] == id);

  writeJson(_products);
  refresh();
}

Future<void> clearCounts() async {
  final _readJson = await readJson();

  _products = _readJson['products'];

  for (var e in _products) {
    e['count'] = 0;
  }

  await writeJson(_products);
}

class InventoryData {
  //StreamController _controller = StreamController<List>();
  //List categories;
  //List products;

  //InventoryData(this.categories, this.products);

  Future<Stream> readStream() async {
    final _readData = await readJson();
    return _readData;
  }

  //Stream readProductsStream() {
  //Stream<List> stream = Stream.fromFuture(readProducts());
  //_controller.add(readProducts());
  //print("print " + _controller.toString());
  //return _controller.stream;
  //final _readData = await readJson();
  //stream = _readData['products'];
  //yield _controller;
  //}

  Future<dynamic> read() async {
    final _readData = await readJson();
    return _readData;
  }

  Future<List> readProducts() async {
    final _readProducts = await readJson();

    //print(_readProducts.toString());
    return _readProducts['products'];
  }
}
