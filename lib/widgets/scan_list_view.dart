import 'package:flutter/material.dart';
import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/widgets/scan_list_tile.dart';

class ScanListView extends StatefulWidget {
  const ScanListView({Key? key}) : super(key: key);

  @override
  _ScanListViewState createState() => _ScanListViewState();
}

class _ScanListViewState extends State<ScanListView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final scanListFuture = InventoryData().readProducts();
  @override
  Widget build(BuildContext context) {
    var item_count = 0;
    var _products = [];
    return FutureBuilder(
        future: scanListFuture,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            snapshot.data.forEach((element) {
              if (element['count'] > 0 && element['visible'] != false) {
                item_count++;
                _products.add(element);
              }
              // if (element['count'] == 0)
              //   snapshot.data
              //       .removeWhere((item) => item['id'] == element['id']);
            });
            //print(snapshot.data);
          }
          return snapshot.hasData
              ? item_count == 0
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
                        return ScanListTile(
                            _products[index], index + 1, item_count);
                      },
                      scrollDirection: Axis.vertical,
                      itemCount: item_count,
                      allowImplicitScrolling: false,
                    )
              // ? ListView.builder(
              //     itemCount: item_count,
              //     itemExtent: 500,
              //     itemBuilder: (BuildContext context, int index) {
              //       //print(_products[index]);
              //       // return ListTile(
              //       //   title: Text(_products[index]['name']),
              //       // );
              //       return ScanListTile(_products[index]);
              //     })
              : CircularProgressIndicator();
        });
    // ListView.builder(
    //     itemCount: item_count,
    //     itemBuilder: (BuildContext context, int index) {
    //       return ListTile(
    //         title: Text(_products[index]['name'].toString()),
    //       );
    //     });
  }
}
