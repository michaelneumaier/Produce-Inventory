import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/widgets/scan_list_tile.dart';

class ScanListView extends StatefulWidget {
  const ScanListView({Key? key}) : super(key: key);

  @override
  _ScanListViewState createState() => _ScanListViewState();
}

class _ScanListViewState extends State<ScanListView> {
  final scanListFuture = InventoryData().readProducts();
  @override
  Widget build(BuildContext context) {
    var itemCount = 0;
    var _products = [];
    return FutureBuilder(
        future: scanListFuture,
        builder: (context, AsyncSnapshot snapshot) {
          //if (snapshot.hasError) log(snapshot.error.toString());
          if (snapshot.hasData) {
            snapshot.data.forEach((element) {
              if (element['count'] > 0 && element['visible'] != false) {
                itemCount++;
                _products.add(element);
              }
              // if (element['count'] == 0)
              //   snapshot.data
              //       .removeWhere((item) => item['id'] == element['id']);
            });
            //print(snapshot.data);
          }
          return snapshot.hasData
              ? itemCount == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'No products were counted.',
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Icon(
                            Icons.air,
                            size: 150,
                            color: Colors.blueGrey[50],
                          ),
                          const SizedBox(height: 100)
                        ],
                      ),
                    )
                  : PageView.builder(
                      itemBuilder: (BuildContext context, index) {
                        if (index == itemCount) {
                          return Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Finished Scanning!',
                                  style: TextStyle(
                                    fontSize: 30,
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Icon(
                                Icons.done_all_sharp,
                                size: 40,
                              )
                            ],
                          ));
                        }
                        return ScanListTile(
                            _products[index], index + 1, itemCount);
                      },
                      scrollDirection: Axis.vertical,
                      itemCount: itemCount + 1,
                      allowImplicitScrolling: false,
                    )
              // ? ListView.builder(
              //     itemCount: itemCount,
              //     itemExtent: 500,
              //     itemBuilder: (BuildContext context, int index) {
              //       //print(_products[index]);
              //       // return ListTile(
              //       //   title: Text(_products[index]['name']),
              //       // );
              //       return ScanListTile(_products[index]);
              //     })
              : const CircularProgressIndicator();
        });
    // ListView.builder(
    //     itemCount: itemCount,
    //     itemBuilder: (BuildContext context, int index) {
    //       return ListTile(
    //         title: Text(_products[index]['name'].toString()),
    //       );
    //     });
  }
}
