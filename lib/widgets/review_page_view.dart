import 'package:flutter/material.dart';
import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/models/products.dart';
import 'package:orderguide/widgets/product_category_image.dart';

class ReviewListView extends StatefulWidget {
  const ReviewListView({Key? key}) : super(key: key);

  @override
  _ReviewListViewState createState() => _ReviewListViewState();
}

class _ReviewListViewState extends State<ReviewListView> {
  final productsFuture = InventoryData().readProducts();
  var itemCount = 0;
  var products = [];
  bool productsCounted = false;
  void refreshInventoryWidget() {
    //log('refresh');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: productsFuture,
        builder: (context, AsyncSnapshot snapshot) {
          //if (snapshot.hasError) log(snapshot.error.toString());
          if (snapshot.hasData) {
            snapshot.data.forEach((element) {
              if (element['count'] > 0 &&
                  element['visible'] != false &&
                  productsCounted == false) {
                itemCount++;
                products.add(element);
              }
              // if (element['count'] == 0)
              //   snapshot.data
              //       .removeWhere((item) => item['id'] == element['id']);
            });
            productsCounted = true;
            //log(itemCount.toString());
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
                  : ListView(
                      children: List.generate(itemCount, (index) {
                        //Start Product Instantiation

                        //log(itemCount.toString());
                        var snapshotData = products[index];
                        bool? isVisible;
                        if (snapshotData['visible'] != null) {
                          isVisible = snapshotData['visible'];
                        } else {
                          isVisible = true;
                        }
                        final count = snapshotData['count'] as num;
                        bool hasImage = false;
                        if (snapshotData['image'] != null) {
                          hasImage = true;
                        }
                        Product product = Product(
                            id: snapshotData['id'] as int,
                            category: snapshotData['category'],
                            name: snapshotData['name'],
                            image: hasImage ? snapshotData['image'] : '',
                            upc: snapshotData['upc'] as String,
                            count: count.toDouble(),
                            visible: isVisible!);
                        //End Product Instantiation
                        //print(index);

                        return Card(
                          child: ListTile(
                            horizontalTitleGap: 0,
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            tileColor: index.isEven
                                ? product.isOrganic
                                    ? Colors.lightGreen[100]
                                    : Colors.grey[100]
                                : product.isOrganic
                                    ? Colors.lightGreen[200]
                                    : Colors.grey[200],
                            key: ValueKey(index),
                            leading: ProductCategoryImage(product.category),
                            //leading: Text(widget.snapshot.data[index]["category"]),
                            title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name),
                                  Wrap(spacing: 20, children: [
                                    Text(
                                      product.upc,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    product.isOrganic
                                        ? const Text(
                                            'Organic',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Container()
                                  ]),
                                ]),
                            trailing: Wrap(
                              spacing: -10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                // IconButton(
                                //   onPressed: () => showDialog(
                                //       context: context,
                                //       builder: (BuildContext context) => RemoveProductWidget(
                                //           widget.snapshot.data[index]["id"],
                                //           widget.snapshot.data[index]["name"],
                                //           widget.refresh)),
                                //   icon: const Icon(Icons.delete),
                                //   color: Theme.of(context).errorColor,
                                // ),
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    product.getCount,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });

    // Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Review Inventory'),
    //   ),
    //   body: itemCount == 0
    //       ? Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               const Text(
    //                 'No products were counted.',
    //                 style: TextStyle(fontSize: 24),
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               Icon(
    //                 Icons.air,
    //                 size: 150,
    //                 color: Colors.blueGrey[50],
    //               ),
    //               const SizedBox(height: 100)
    //             ],
    //           ),
    //         )
    //       : ListView(
    //           children: List.generate(itemCount, (index) {
    //             //Start Product Instantiation

    //             var snapshotData = widget.snapshot.data[index];
    //             bool? isVisible;
    //             if (snapshotData['visible'] != null) {
    //               isVisible = snapshotData['visible'];
    //             } else {
    //               isVisible = true;
    //             }
    //             final count = snapshotData['count'] as num;
    //             bool hasImage = false;
    //             if (snapshotData['image'] != null) {
    //               hasImage = true;
    //             }
    //             Product product = Product(
    //                 id: snapshotData['id'] as int,
    //                 category: snapshotData['category'],
    //                 name: snapshotData['name'],
    //                 image: hasImage ? snapshotData['image'] : '',
    //                 upc: snapshotData['upc'] as String,
    //                 count: count.toDouble(),
    //                 visible: isVisible!);
    //             //End Product Instantiation
    //             //print(index);

    //             return Card(
    //               child: ListTile(
    //                 horizontalTitleGap: 0,
    //                 contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    //                 tileColor:
    //                     index.isEven ? Colors.grey[100] : Colors.grey[200],
    //                 key: ValueKey(index),
    //                 leading: ProductCategoryImage(products[index]["category"]),
    //                 //leading: Text(widget.snapshot.data[index]["category"]),
    //                 title: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(products[index]["name"]),
    //                       Text(products[index]["upc"]),
    //                     ]),
    //                 trailing: Wrap(
    //                   spacing: -10,
    //                   crossAxisAlignment: WrapCrossAlignment.center,
    //                   children: [
    //                     // IconButton(
    //                     //   onPressed: () => showDialog(
    //                     //       context: context,
    //                     //       builder: (BuildContext context) => RemoveProductWidget(
    //                     //           widget.snapshot.data[index]["id"],
    //                     //           widget.snapshot.data[index]["name"],
    //                     //           widget.refresh)),
    //                     //   icon: const Icon(Icons.delete),
    //                     //   color: Theme.of(context).errorColor,
    //                     // ),
    //                     SizedBox(
    //                       width: 30,
    //                       child: Text(
    //                         product.getCount,
    //                         textAlign: TextAlign.center,
    //                         style: const TextStyle(fontSize: 18),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           }),
    //         ),
    // );
  }
}
