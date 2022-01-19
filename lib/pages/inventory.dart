import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orderguide/models/category_images.dart';

import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/widgets/products_list_view.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late List _categories;
  bool editProducts = false;
  dynamic currentInventory = [];
  //late var viewProductsListViewKey;
  late String setCategory = 'all';
  late Future inventoryFuture;
  void refreshInventoryWidget(
      [bool? keepEditProducts, bool? fullRefersh, String? category]) {
    log('refresh');
    //inventoryFuture = InventoryData().readProducts();
    setState(() {
      if (keepEditProducts != null) {
        editProducts = keepEditProducts;
      }
      if (category != null) {
        setCategory = category;
      }
      if (fullRefersh == true) {
        inventoryFuture = InventoryData().readProducts();
      }
    });
  }

  @override
  void initState() {
    log('inventory page init state');
    _categories = Categories().categories;
    inventoryFuture = InventoryData().readProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future: inventoryFuture,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) log(snapshot.error.toString());
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ProductsListView(
                      categories: _categories,
                      snapshot: snapshot,
                      refresh: refreshInventoryWidget,
                      editProducts: editProducts,
                      setCategory: setCategory,
                      // viewProductsListViewKey: ,
                      // editProductsListViewKey:
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // return snapshot.hasData
                  //     ? ProductsListView(
                  //         categories: _categories,
                  //         snapshot: snapshot,
                  //         refresh: refreshInventoryWidget)
                  //     : const Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                }),
          ),
        ]));
  }
}
