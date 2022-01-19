import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/widgets/review_page_view.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final productsFuture = InventoryData().readProducts();

  dynamic currentInventory = [];

  void refreshInventoryWidget() {
    log('refresh');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Review Inventory'),
        ),
        body: const ReviewListView()
        //  Center(
        //     child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //       Expanded(
        //         child: FutureBuilder(
        //             future: productsFuture,
        //             builder: (context, AsyncSnapshot snapshot) {
        //               if (snapshot.hasError) log(snapshot.error.toString());
        //               if (snapshot.hasData) {
        //                 snapshot.data.forEach((element) {
        //                   // if (element['count'] > 0) {
        //                   //   item_count++;
        //                   //   _products.add(element);
        //                   // }
        //                   // if (element['count'] == 0)
        //                   //   snapshot.data
        //                   //       .removeWhere((item) => item['id'] == element['id']);
        //                 });
        //               }

        //               return snapshot.hasData
        //                   ? ReviewListView(
        //                       snapshot: snapshot, refresh: refreshInventoryWidget)
        //                   : const Center(
        //                       child: CircularProgressIndicator(),
        //                     );
        //             }),
        //       ),
        // Wrap(children: [
        //   ElevatedButton(
        //       child: const Text('Clear Counts'),
        //       style: ElevatedButton.styleFrom(primary: Colors.grey),
        //       onPressed: () {
        //         showDialog(
        //             context: context,
        //             builder: (BuildContext context) {
        //               return AlertDialog(
        //                 title: const Text(
        //                     'Are you sure you want to clear inventory counts?'),
        //                 actions: <Widget>[
        //                   TextButton(
        //                     onPressed: () => Navigator.pop(context, 'Cancel'),
        //                     child: const Text('Cancel'),
        //                   ),
        //                   TextButton(
        //                     onPressed: () {
        //                       clearCounts()
        //                           .then((value) => refreshInventoryWidget());
        //                       Navigator.pop(context, 'OK');
        //                     },
        //                     child: const Text('Clear'),
        //                   ),
        //                 ],
        //               );
        //             });
        //       }),
        //   const SizedBox(
        //     width: 20,
        //   ),
        //   AddProductWidget(
        //     refresh: refreshInventoryWidget,
        //   ),
        // ])
        //])
        );
  }
}
