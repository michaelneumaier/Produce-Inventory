import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ScanListTile extends StatelessWidget {
  final index;
  final item_count;
  final product;
  const ScanListTile(
      @required this.product, @required this.index, @required this.item_count);

  generateBarcode(upc) {
    return BarcodeWidget(
      data: upc.toString(),
      barcode: Barcode.code128(),
      width: 200,
      height: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isOrganic = false;
    if (product["upc"][0] == "9") isOrganic = true;
    final count = product["count"];
    final countDouble;
    bool isDouble = false;
    bool isInteger(num value) => (value % 1) == 0;

    if (isInteger(count) == true) {
      countDouble = count.toDouble().toStringAsFixed(0);
    } else {
      isDouble = true;
      countDouble = count.toDouble();
    }
    String countString;
    if (count == 0.5) {
      countString = '0.5 Case';
    } else if (count == 1.0) {
      countString = '1 Case';
    } else {
      countString = '$countDouble Cases';
    }
    print(isOrganic);

    //print(countDouble.toString());
    return Container(
      color: index % 2 == 0
          ? isOrganic
              ? Colors.lightGreen[100]
              : Colors.grey[100]
          : isOrganic
              ? Colors.lightGreen[200]
              : Colors.blueGrey[50],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              countString,
              style: const TextStyle(fontSize: 50),
              textAlign: TextAlign.end,
            ),
            Wrap(
              children: [
                isOrganic
                    ? const Text(
                        'Organic',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    : const Text(''),
                Text(
                  product['name'],
                  style: const TextStyle(fontSize: 30),
                ),
              ],
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
            ),
            const SizedBox(height: 50),
            generateBarcode(product['upc']),
            Text(
              '$index of $item_count',
              style: const TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
