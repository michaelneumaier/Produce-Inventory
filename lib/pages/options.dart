import 'package:flutter/material.dart';
import 'package:orderguide/models/file_controller.dart';
import 'package:orderguide/models/inventory_controller.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () => writeImageLocationToJson(),
                child: Text('Write image location to JSON')),
            ElevatedButton(
                onPressed: () => loadFile(), child: Text('Load Order Guide')),
            ElevatedButton(
                onPressed: () {
                  saveFile().then((value) => ScaffoldMessenger.of(context)
                      .showSnackBar(
                          SnackBar(content: const Text('File saved!'))));
                },
                child: Text('Save Order Guide'))
          ],
        ),
      ),
    );
  }
}
