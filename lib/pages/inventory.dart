import 'package:flutter/material.dart';
import 'package:orderguide/main.dart';
import 'package:orderguide/models/category_images.dart';

import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/widgets/products_drawer.dart';
import 'package:orderguide/widgets/products_list_view.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  static final _inventoryPageStateConst = _InventoryPageState();
  void refresh() {
    _inventoryPageStateConst.refreshInventoryWidget(null, true);
  }

  @override
  _InventoryPageState createState() => _inventoryPageStateConst;
}

class _InventoryPageState extends State<InventoryPage>
    with AutomaticKeepAliveClientMixin<InventoryPage> {
  @override
  bool get wantKeepAlive => true;

  late List _categories;
  bool editProducts = false;
  bool rebuildFuture = false;
  dynamic currentInventory = [];
  //late var viewProductsListViewKey;
  late String setCategory = 'all';
  late Future inventoryFuture;
  ProductsListView? inventoryFutureSnapshot;

  void refreshInventoryWidget(
      [bool? keepEditProducts, bool? fullRefresh, String? category]) {
    //log('refresh');
    //inventoryFuture = InventoryData().readProducts();
    setState(() {
      if (keepEditProducts != null) {
        editProducts = keepEditProducts;
      }
      if (fullRefresh == true) {
        inventoryFuture = InventoryData().readProducts();
      }
      if (category != null) {
        setCategory = category;
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
    super.build(context);
    return Scaffold(
        drawer: const ProductsListViewDrawer(),
        onDrawerChanged: (isOpened) {
          if (isOpened == false) {
            setState(() {
              if (MyApp.sharedPreferences.getBool('loaded_new_inventory') ==
                  true) {
                inventoryFuture = InventoryData().readProducts();
                MyApp.sharedPreferences.setBool('loaded_new_inventory', false);
              }
            });
          }
        },
        appBar: AppBar(
          title: const FittedBox(
              fit: BoxFit.contain,
              child: Text('Produce Inventory', style: TextStyle(fontSize: 18))),
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
                  style: TextStyle(color: Colors.white, fontSize: 12),
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
                  rebuildFuture = true;
                } else {
                  editProducts = false;

                  refreshInventoryWidget(false, true);
                  rebuildFuture = true;
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
                        //inventoryFutureSnapshot = null;
                        inventoryFutureSnapshot = ProductsListView(
                            categories: _categories,
                            snapshot: snapshot,
                            refresh: refreshInventoryWidget,
                            editProducts: editProducts,
                            setCategory: setCategory,
                            setCategoryFunction: setMainCategory
                            // viewProductsListViewKey: ,
                            // editProductsListViewKey:
                            );

                        return inventoryFutureSnapshot!;
                      } else if (snapshot.connectionState ==
                          ConnectionState.active) {
                        if (inventoryFutureSnapshot != null) {
                          return inventoryFutureSnapshot!;
                        }
                      }

                      if (inventoryFutureSnapshot != null) {
                        print('snapshot not null');
                        if (rebuildFuture == true) {
                          rebuildFuture = false;
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return inventoryFutureSnapshot!;
                      }
                      return const Center(child: CircularProgressIndicator());

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
