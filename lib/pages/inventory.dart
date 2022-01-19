import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orderguide/models/category_images.dart';

import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/widgets/products_drawer.dart';
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
    //log('refresh');
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

  void setMainCategory(String category) {
    setState(() {
      setCategory = category;
    });
  }

  @override
  void initState() {
    //log('inventory page init state');
    _categories = Categories().categories;
    inventoryFuture = InventoryData().readProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ProductsListViewDrawer(),
        onDrawerChanged: (isOpened) {
          if (isOpened == false) {
            setState(() {});
          }
        },
        appBar: AppBar(
          title: const FittedBox(
              fit: BoxFit.contain, child: Text('Produce Inventory')),
          actions: [
            if (editProducts == false)
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                              'Are you sure you want to clear inventory counts?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                clearCounts().whenComplete(() {
                                  refreshInventoryWidget(false, true);
                                });
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        );
                      });
                },
                child: const Text(
                  'Clear Counts',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            if (editProducts == true)
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-products', arguments: {
                      'refresh': refreshInventoryWidget,
                      //'setEditProducts': setEditProductsBool,
                      //'setCategory': categoryFilter
                    }).whenComplete(() {
                      //setEditProductsBool(true);
                    });
                  },
                  icon: const Icon(Icons.add)),
            // AddProductWidget(
            //   refresh: widget.refresh,
            //   type: 'icon',
            // ),

            IconButton(
              onPressed: () => setState(() {
                if (editProducts == false) {
                  editProducts = true;
                  refreshInventoryWidget(true, true);
                } else {
                  editProducts = false;
                  refreshInventoryWidget(false, true);
                  //resetEditProductsListViewKey();
                }
              }),
              icon: !editProducts
                  ? const Icon(Icons.edit)
                  : const Icon(Icons.check),
            ),
          ],
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Expanded(
                child: FutureBuilder(
                    future: inventoryFuture,
                    builder: (context, AsyncSnapshot snapshot) {
                      //if (snapshot.hasError) log(snapshot.error.toString());
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ProductsListView(
                            categories: _categories,
                            snapshot: snapshot,
                            refresh: refreshInventoryWidget,
                            editProducts: editProducts,
                            setCategory: setCategory,
                            setCategoryFunction: setMainCategory
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
            ])));
  }
}
