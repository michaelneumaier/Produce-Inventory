//import 'dart:developer';
//import 'dart:html';
//import 'dart:io';
//import 'dart:async';
//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:orderguide/models/inventory_controller.dart';

import 'package:orderguide/pages/inventory.dart';
import 'package:orderguide/pages/options.dart';
import 'package:orderguide/pages/review.dart';
import 'package:orderguide/pages/scan.dart';
import 'package:orderguide/widgets/add_product.dart';
import 'package:orderguide/widgets/edit_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:flutter/services.dart';
//import 'package:path_provider/path_provider.dart';

//import 'models/inventory_controller.dart';
void main() {
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
                        //setEditProducts: arguments['setEditProducts'],
                        //setCategory: arguments['setCategory'],
                      ));
            case '/edit-product':
              return MaterialPageRoute(
                  builder: (context) => EditProductBottomSheet(
                        refresh: arguments['refresh'],
                        id: arguments['id'],
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
  late PageController _pageController;
  static const _inventoryPage = InventoryPage();
  static const List<Widget> _pages = <Widget>[
    _inventoryPage,
    //CategoriesPage(),
    ReviewPage(),
    ScanPage(),
    //OptionsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        _inventoryPage.refresh();
      }
      //Navigator.pop(context);
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  Future<void> _getPrefs() async {
    MyApp.sharedPreferences = await SharedPreferences.getInstance();
  }

  // void setImageFilePath() async {
  //   final _dirPath = await localPath();
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.
  // }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _getPrefs().whenComplete(() => localPath().then(
        (value) => MyApp.sharedPreferences.setString('image_path', value)));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ), //_pages.elementAt(_selectedIndex),
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
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.settings),
            //   label: 'Options',
            // ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
