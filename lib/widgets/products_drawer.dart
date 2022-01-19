import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

  void _launchURL(url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  void initState() {
    super.initState();
    _getCheckBoxValue();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(children: [
                    const Text('Show Only Organic Products'),
                    Checkbox(
                      value: organicCheckboxValue,
                      onChanged: (value) {
                        setState(() {
                          organicCheckboxValue = value!;
                          _changeCheckBoxValue('view_organic_only', value);
                        });
                      },
                    ),
                  ]),
                  Row(children: [
                    const Text('Show Only Packaged Products'),
                    Checkbox(
                      value: viewOnlyPackagedValue,
                      onChanged: (value) {
                        setState(() {
                          viewOnlyPackagedValue = value!;
                          _changeCheckBoxValue('view_packaged_only', value);
                        });
                      },
                    ),
                  ])
                ],
              ),
              Column(children: [
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: 'Icons made by: ',
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                      text: 'Flat Icons',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://www.flaticon.com/authors/flat-icons');
                        })
                ])),
              ])
            ]),
      )),
    );
  }
}
