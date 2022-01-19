import 'dart:developer';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:orderguide/models/category_images.dart';
import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/widgets/product_category_image.dart';

class AddProductWidget extends StatefulWidget {
  final Function refresh;
  final String type;

  const AddProductWidget({Key? key, required this.refresh, required this.type})
      : super(key: key);

  @override
  _AddProductWidgetState createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  final categories = Categories().getCategories();

  @override
  Widget build(BuildContext context) {
    onPressed() => showBottomSheet(
        context: context,
        builder: (context) => AddProductBottomSheet(
              refresh: widget.refresh,
            ));

    return Container(
        child: widget.type == "icon"
            ? IconButton(
                onPressed: () => onPressed(), icon: const Icon(Icons.add))
            : ElevatedButton(
                child: const Text('Add Product'),
                onPressed: () => onPressed(),
              ));
  }
}

class AddProductBottomSheet extends StatefulWidget {
  final Function refresh;
  //final Function? setEditProducts;
  //final String? setCategory;
  const AddProductBottomSheet({
    Key? key,
    required this.refresh,
    //this.setEditProducts, this.setCategory
  }) : super(key: key);

  @override
  _AddProductBottomSheetState createState() => _AddProductBottomSheetState();
}

class _AddProductBottomSheetState extends State<AddProductBottomSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  final categoriesWithImages = Categories().categoriesWithImages;
  //final _dropdownMenu = <Widget>[];
  // categoryDropdown() {
  //   FutureBuilder(
  //     future: _categories,
  //     builder: (context, AsyncSnapshot snapshot) {
  //       if (snapshot.hasData) {
  //         return Container();
  //       } else
  //         return CircularProgressIndicator();
  //     },
  //   );
  //   // return FormBuilderDropdown(name: 'category', items: <DropdownMenuItem>[]);
  //   // return _categories.then((value) {
  //   //   List.generate(value.length, (index) {
  //   //     DropdownMenuItem(child: Text(value[index]['name']));
  //   //   });
  //   // });
  // }
  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      //log(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return '';
    return barcodeScanRes;
  }

  @override
  void initState() {
    super.initState();

    // InventoryData().readCategories().then((value) {
    //   _categories = value;
    //   print(_categories.toString());
    //   //print(_categories);
    // });
    // _categories = FutureBuilder(
    //     future: InventoryData().readCategories(),
    //     builder: (context, AsyncSnapshot snapshot) {
    //       return FormBuilderDropdown(
    //         name: 'category',
    //         items: snapshot.data.map((item) {
    //           return DropdownMenuItem(child: Text('category'));
    //           //   return DropdownMenuItem(
    //           //       value: item['id'], child: Text(item['name'].toString()));
    //         }),
    //       );
    // if (snapshot.hasError) print(snapshot.error);
    // if (snapshot.hasData) {
    //   //print(snapshot.data);
    // }
    // return snapshot.hasData
    //     ? DropdownMenuItem(
    //         child: Text(snapshot.data['name']),
    //         value: snapshot.data['id'],
    //       )

    //     // ProductsListView(
    //     //   categories: _categories,
    //     //   snapshot: snapshot,
    //     //   refresh: refreshInventoryWidget)
    //     : const DropdownMenuItem(
    //         child: Text('loading'),
    //       );
    //});
  }

  final upcController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //print(widget.categories);
    //log(widget.setCategory!);
    final categoryValues = categoriesWithImages;
    //print(categoryValues);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FormBuilder(
                key: _formKey,
                //autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    const Text('Add Product',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    FormBuilderTextField(
                      name: 'name',
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 1,
                          child: FormBuilderTextField(
                            controller: upcController,
                            name: 'upc',
                            decoration: const InputDecoration(labelText: 'UPC'),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                              FormBuilderValidators.numeric(context),
                            ]),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(13),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ElevatedButton(
                                onPressed: () {
                                  scanBarcodeNormal().then((value) {
                                    setState(() {
                                      upcController.text = '';
                                      if (value != '-1') {
                                        upcController.text = value;
                                      }

                                      //_formKey.currentState?.value['upc'] = value;
                                      //scannedBarcode = value;
                                    });
                                  });
                                },
                                child: const Text('Scan Barcode')),
                          ),
                        )
                      ],
                    ),

                    //_categories
                    FormBuilderDropdown(
                      name: 'category',
                      hint: const Text('Select Category'),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(context)]),
                      //items: [DropdownMenuItem(child: Text('Apples'))],
                      // items: widget.categories
                      //     .map((e) => DropdownMenuItem(
                      //           child: Text(e.toString()),
                      //           value: e.toString(),
                      //         ))
                      //     .toList(),
                      items: categoryValues
                          .map((e) => DropdownMenuItem(
                              value: e['name'],
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 30,
                                      child: ProductCategoryImage(
                                          e['name'].toString()),
                                      // child: FaIcon(
                                      //   e['icon'] as IconData,
                                      //   color: e['color'] as Color,
                                      // ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      e['name'].toString(),
                                    ),
                                  ])))
                          .toList(),
                      // items: widget.categories
                      //     .map((e) => DropdownMenuItem(
                      //         value: e['name'], child: Text(e['name'])))
                      //     .toList(),
                    ),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Expanded(
                  child: ElevatedButton(
                      child: const Text('Cancel'),
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                      onPressed: () => Navigator.pop(context)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      _formKey.currentState?.save();
                      if (_formKey.currentState!.validate()) {
                        addProduct(
                          _formKey.currentState!.value['category'],
                          _formKey.currentState!.value['name'],
                          _formKey.currentState!.value['upc'],
                          widget.refresh,
                          //widget.setCategory
                        ).whenComplete(() {
                          //_formKey.currentState!.reset();
                          Navigator.pop(context);
                        });

                        //print(_formKey.currentState!.value);

                      } else {
                        //log('Form not valid');
                      }
                    },
                  ),
                ),
                // Wrap(
                //   children: [FaIcon(categoriesWithImages.entries.firstWhere((element) => element == )['icon'] as IconData)],
                // )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
