import 'package:flutter/material.dart';
import 'package:orderguide/models/products.dart';
import 'package:orderguide/widgets/product_category_image.dart';

class ReviewListView extends StatefulWidget {
  final AsyncSnapshot snapshot;

  final Function refresh;

  const ReviewListView(
      {Key? key, required this.snapshot, required this.refresh})
      : super(key: key);

  @override
  _ReviewListViewState createState() => _ReviewListViewState();
}

class _ReviewListViewState extends State<ReviewListView> {
  @override
  Widget build(BuildContext context) {
    var itemCount = 0;
    var _products = [];
    widget.snapshot.data.forEach((element) {
      if (element['count'] > 0 && element['visible'] != false) {
        itemCount++;
        _products.add(element);
      }
      // if (element['count'] == 0)
      //   snapshot.data
      //       .removeWhere((item) => item['id'] == element['id']);
    });
    //print(widget.snapshot.data.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Inventory'),
      ),
      body: itemCount == 0
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

                var snapshotData = widget.snapshot.data[index];
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
                    contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    tileColor:
                        index.isEven ? Colors.grey[100] : Colors.grey[200],
                    key: ValueKey(index),
                    leading: ProductCategoryImage(_products[index]["category"]),
                    //leading: Text(widget.snapshot.data[index]["category"]),
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_products[index]["name"]),
                          Text(_products[index]["upc"]),
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
            ),
    );
  }
}
