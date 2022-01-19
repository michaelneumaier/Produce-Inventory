import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:orderguide/models/inventory_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<bool> _hasAcceptedPermissions() async {
  if (Platform.isAndroid) {
    if (await Permission.storage.request().isGranted &&
        // access media location needed for android 10/Q
        await Permission.accessMediaLocation.request().isGranted &&
        // manage external storage needed for android 11/R
        await Permission.manageExternalStorage.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }
  if (Platform.isIOS) {
    if (await Permission.photos.request().isGranted) {
      return true;
    } else {
      return false;
    }
  } else {
    // not android or ios
    return false;
  }
}

Future<void> saveFile() async {
  final json = await readJson();
  for (var element in json['products']) {
    element['image'] = '';
  }
  //print(json.toString());
  writeFile(json);
}

Future<String> getDownloadsPath() async {
  var path = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS);
  return (path); // /storage/emulated/0/Pictures
}

Future<void> writeFile(Map fileToWrite) async {
  final _dirPath = await getDownloadsPath();
  //print(await _localPath());
  initializeDateFormatting('en', null);
  DateTime date = DateTime.now();
  final formattedDate = DateFormat('ddMMyy kms').format(date);
  final _jsonFile = await File('$_dirPath/inventory$formattedDate.json')
      .create(recursive: true);
  final _file = jsonEncode(fileToWrite);
  //print(formattedDate);
  //print(_file);
  //print(jsonEncode(fileToWrite));
  //var status = await Permission.manageExternalStorage.status;
  if (await _hasAcceptedPermissions() == true) {
    //print(await getDownloadsPath());
    _jsonFile.writeAsStringSync(_file);
  }
}

Future<void> loadFile() async {
  FilePicker.platform.clearTemporaryFiles();
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(allowedExtensions: ['json'], type: FileType.custom);

  if (result != null) {
    final file = File(result.files.single.path!);
    final _data = await file.readAsString(encoding: utf8);
    final _json = jsonDecode(_data);
    if (_json['products'] != null) {
      //print(_json.toString());
      writeJson(_json['products']);
      log('Inventory file overwritten');
    }
    //print(_json);
    //return _json;
    //print(file.readAsString());
    //print(File(result.files.single.path!).readAsString().toString());
  }
}

// Future<void> readProducts() async {
//   final _readProducts = await loadFile();

//   //print(_readProducts.toString());
//   //print(_readProducts['products']);
//   //return _readProducts['products'];
// }
