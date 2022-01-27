import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:orderguide/models/products.dart';

import 'product_category_image.dart';

class ProductDialog extends StatelessWidget {
  final Product product;
  const ProductDialog({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          direction: Axis.vertical,
          children: [
            ProductCategoryImage(product.category, product.upc, 150, 150),
            SizedBox(
              width: 300,
              child: Text(
                product.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            if (product.isOrganic == true)
              const Text(
                'Organic',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarcodeWidget(
                data: product.upc.toString(),
                barcode: Barcode.code128(),
                width: 200,
                height: 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
