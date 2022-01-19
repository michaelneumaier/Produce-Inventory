//import 'dart:developer';
//import 'dart:html';
//import 'dart:io';
//import 'dart:async';
//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:orderguide/pages/categories.dart';
//import 'package:flutter/services.dart';
import 'package:orderguide/pages/inventory.dart';
import 'package:orderguide/pages/options.dart';
import 'package:orderguide/pages/review.dart';
import 'package:orderguide/pages/scan.dart';
import 'package:orderguide/widgets/add_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:flutter/services.dart';
//import 'package:path_provider/path_provider.dart';

//import 'models/inventory_controller.dart';
void main() async {
  //MyApp.sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static late SharedPreferences sharedPreferences;
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Produce Order Guide',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const MyHomePage(title: 'Produce Order Guide'),
        supportedLocales: const [Locale('en')],
        localizationsDelegates: const [
          FormBuilderLocalizations.delegate,
        ],
        onGenerateRoute: (settings) {
          final arguments = settings.arguments as Map;
          switch (settings.name) {
            case '/add-products':
              return MaterialPageRoute(
                  builder: (context) => AddProductBottomSheet(
                        refresh: arguments['refresh'],
                        setEditProducts: arguments['setEditProducts'],
                        setCategory: arguments['setCategory'],
                      ));
          }
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    InventoryPage(),
    //CategoriesPage(),
    ReviewPage(),
    ScanPage(),
    OptionsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      //Navigator.pop(context);
      _selectedIndex = index;
    });
  }

  void _getPrefs() async {
    MyApp.sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Inventory',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.category),
            //   label: 'Categories',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fact_check),
              label: 'Review',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Options',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
