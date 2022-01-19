import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        child: Column(children: [
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
        ]),
      )),
    );
  }
}
