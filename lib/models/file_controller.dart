import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:orderguide/models/inventory_controller.dart';

import 'package:external_path/external_path.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveFile() async {
  final json = await readJson();
  for (var element in json['products']) {
    element['image'] = '';
  }
  //print(json.toString());
  writeFile(json);
}

Future<dynamic> getDownloadsPath() async {
  String? path;
  if (Platform.isAndroid) {
    path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
  } else if (Platform.isIOS) {
    await getApplicationDocumentsDirectory()
        .then((value) => path = value.path.toString());
    //path = await getApplicationDocumentsDirectory();

  }

  return (path); // /storage/emulated/0/Pictures
}

Future<void> writeFile(Map fileToWrite) async {
  final _dirPath = await getDownloadsPath();
  print(_dirPath);
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
  _jsonFile.writeAsStringSync(_file);
  // if (await _hasAcceptedPermissions() == true) {
  //   //print(await getDownloadsPath());

  // }
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
