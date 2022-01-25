import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:orderguide/models/image_controller.dart';
import 'package:orderguide/models/upc.dart';
import 'package:orderguide/widgets/product_category_image.dart';

class ScanListTile extends StatefulWidget {
  final int index;
  final num itemCount;
  final Map product;
  const ScanListTile(this.product, this.index, this.itemCount);

  @override
  State<ScanListTile> createState() => _ScanListTileState();
}

class _ScanListTileState extends State<ScanListTile> {
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
    if (widget.product["upc"][0] == "9") isOrganic = true;
    final count = widget.product["count"];
    final dynamic countDouble;
    bool isInteger(num value) => (value % 1) == 0;

    if (isInteger(count) == true) {
      countDouble = count.toDouble().toStringAsFixed(0);
    } else {
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

    final fullUpc = createFullUpc(widget.product['upc']);
    bool hasImage;
    print(widget.product['image']);
    if (widget.product['image'] == '') {
      hasImage = false;
    } else if (widget.product['image'] == null) {
      hasImage = false;
    } else {
      hasImage = true;
    }
    //log(isOrganic.toString());

    //print(countDouble.toString());
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.index % 2 == 0
                ? isOrganic
                    ? Colors.lightGreen.shade300
                    : Colors.blueGrey.shade300
                : isOrganic
                    ? Colors.lightGreen.shade200
                    : Colors.blueGrey.shade200,
            width: 5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.shade200,
              blurRadius: 10,
            )
          ],
          color: widget.index % 2 == 0
              ? isOrganic
                  ? Colors.lightGreen[100]
                  : Colors.blueGrey[100]
              : isOrganic
                  ? Colors.lightGreen[50]
                  : Colors.blueGrey[50],
        ),
        // color: index % 2 == 0
        //     ? isOrganic
        //         ? Colors.lightGreen[100]
        //         : Colors.grey[100]
        //     : isOrganic
        //         ? Colors.lightGreen[200]
        //         : Colors.blueGrey[50],
        child: Center(
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    countString,
                    style: const TextStyle(fontSize: 50),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: hasImage
                    ? Container(
                        foregroundDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        //color: Colors.black,
                        child: FutureBuilder(
                          future: loadImageFilePath(fullUpc),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              //return Container();
                              return FittedBox(
                                fit: BoxFit.contain,
                                child: Container(
                                  decoration: BoxDecoration(
                                      //color: Colors.black,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      snapshot.data as File,

                                      //width: 300,
                                      //height: 300,
                                      //fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              );
                              // snapshot.data as Widget;
                            } else {
                              return const SizedBox(
                                width: 80,
                                height: 80,
                                child: CircularProgressIndicator(),
                              );
                            }
                            //return Image(image: NetworkImage(snapshot.data.toString()));
                          },
                        ),
                      )
                    : ProductCategoryImage(
                        widget.product['category'], widget.product['upc']),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Wrap(
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
                          widget.product['name'],
                          style: const TextStyle(fontSize: 50),
                        ),
                      ],
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.vertical,
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: generateBarcode(
                        widget.product['upc'],
                      ))),
              //const Expanded(child: SizedBox(height: 50)),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(10),
                  //color: Colors.white,
                  child: Text(
                    '${widget.index} of ${widget.itemCount}',
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
