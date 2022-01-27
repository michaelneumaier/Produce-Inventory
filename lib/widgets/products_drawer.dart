import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:orderguide/main.dart';
import 'package:orderguide/models/file_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsListViewDrawer extends StatefulWidget {
  const ProductsListViewDrawer({Key? key}) : super(key: key);

  @override
  _ProductsListViewDrawerState createState() => _ProductsListViewDrawerState();
}

class _ProductsListViewDrawerState extends State<ProductsListViewDrawer> {
  var organicCheckboxValue = false;
  var viewOnlyPackagedValue = false;

  void _getCheckBoxValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      organicCheckboxValue = (prefs.getBool('view_organic_only') ?? false);
      viewOnlyPackagedValue = (prefs.getBool('view_packaged_only') ?? false);
    });
  }

  void _changeCheckBoxValue(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    // setState(() {
    //   //organicCheckboxValue = value;

    // });
  }

  // void _launchURL(url) async {
  //   if (!await launch(url)) throw 'Could not launch $url';
  // }

  @override
  void initState() {
    super.initState();
    _getCheckBoxValue();
  }

  TextStyle linkTextStyle = const TextStyle(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey.shade50,
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Show Only Organic Products',
                        textScaleFactor: 1,
                      ),
                      Checkbox(
                        value: organicCheckboxValue,
                        onChanged: (value) {
                          setState(() {
                            organicCheckboxValue = value!;
                            _changeCheckBoxValue('view_organic_only', value);
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Show Only Packaged Products',
                        textScaleFactor: 1,
                      ),
                      Checkbox(
                        value: viewOnlyPackagedValue,
                        onChanged: (value) {
                          setState(() {
                            viewOnlyPackagedValue = value!;
                            _changeCheckBoxValue('view_packaged_only', value);
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // ElevatedButton(
                      //     onPressed: () => writeImageLocationToJson(),
                      //     child: const Text('Write image location to JSON')),
                      ElevatedButton(
                          onPressed: () => loadFile().whenComplete(() => MyApp
                              .sharedPreferences
                              .setBool('loaded_new_inventory', true)),
                          child: const Text('Load Inventory File')),
                      ElevatedButton(
                          onPressed: () {
                            saveFile().whenComplete(() =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('File saved!'))));
                          },
                          child: const Text('Save Inventory File'))
                    ],
                  ),
                ),
              ),
              Column(children: [
                RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(children: [
                      const TextSpan(
                          text: 'Icons made by: ',
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                      TextSpan(
                          text: 'Flat Icons, ',
                          style: linkTextStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'https://www.flaticon.com/authors/flat-icons');
                            }),
                      TextSpan(
                          text: 'Smashicons, ',
                          style: linkTextStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'https://www.flaticon.com/authors/smashicons');
                            }),
                      TextSpan(
                        text: 'Freepik, ',
                        style: linkTextStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch('https://www.flaticon.com/authors/freepik');
                          },
                      ),
                      TextSpan(
                        text: 'kmg design, ',
                        style: linkTextStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                                'https://www.flaticon.com/authors/kmg-design');
                          },
                      ),
                      TextSpan(
                        text: 'umeicon, ',
                        style: linkTextStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch('https://www.flaticon.com/authors/umeicon');
                          },
                      ),
                      TextSpan(
                        text: 'Pixel perfect, ',
                        style: linkTextStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                                'https://www.flaticon.com/authors/pixel-perfect');
                          },
                      ),
                      const TextSpan(
                        text: 'and ',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      TextSpan(
                        text: 'justicon ',
                        style: linkTextStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch('https://www.flaticon.com/authors/justicon');
                          },
                      ),
                      const TextSpan(
                        text: 'from ',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      TextSpan(
                        text: 'flaticon.com',
                        style: linkTextStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch('https://www.flaticon.com/');
                          },
                      ),
                    ])),
              ])
            ]),
      )),
    );
  }
}
