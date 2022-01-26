import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:orderguide/models/category_images.dart';
import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/widgets/product_category_image.dart';

class EditProductWidget extends StatefulWidget {
  final Function refresh;
  final int id;
  final List products;
  final BuildContext parentContext;

  const EditProductWidget(
      {Key? key,
      required this.refresh,
      required this.id,
      required this.products,
      required this.parentContext})
      : super(key: key);

  @override
  _EditProductWidgetState createState() => _EditProductWidgetState();
}

class _EditProductWidgetState extends State<EditProductWidget> {
  final categories = Categories().getCategories();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      //child: const Text('Add Product'),
      icon: const Icon(Icons.edit),
      color: Colors.grey[600],
      onPressed: () {
        showBottomSheet(
            elevation: 2,
            context: widget.parentContext,
            builder: (context) => EditProductBottomSheet(
                  //categories: categories,
                  refresh: widget.refresh,
                  id: widget.id,
                  //products: widget.products,
                ));
        //addProduct('apples', 'Pink Lady', '4130', widget.refresh);
      },
    );
  }
}

class EditProductBottomSheet extends StatefulWidget {
  final int id;
  final Function refresh;
  final Function? setEditProducts;
  final String? setCategory;
  //final List products;
  //final List categories;
  const EditProductBottomSheet({
    Key? key,
    //required this.categories,
    required this.refresh,
    required this.id,
    this.setEditProducts,
    this.setCategory,
    //required this.products
  }) : super(key: key);

  @override
  _EditProductBottomSheetState createState() => _EditProductBottomSheetState();
}

class _EditProductBottomSheetState extends State<EditProductBottomSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  final categoriesWithImages = Categories().categoriesWithImages;
  final upcController = TextEditingController();
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

  final inventoryFuture = InventoryData().readProducts();
  @override
  Widget build(BuildContext context) {
    //print(widget.categories);
    // final currentProduct =
    //     widget.products.firstWhere((element) => element['id'] == widget.id);
    final categoryValues = categoriesWithImages;
    //log(categoryValues.toString());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder(
              future: inventoryFuture,
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData == false) {
                  return const CircularProgressIndicator();
                } else {
                  //final snapshotData = snapshot.data;
                  final currentProduct = snapshot.data
                      ?.firstWhere((element) => element['id'] == widget.id);
                  upcController.text = currentProduct['upc'];
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FormBuilder(
                        key: _formKey,
                        //autovalidateMode: AutovalidateMode.always,
                        child: Column(
                          children: [
                            const Text('Edit Product',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            FormBuilderTextField(
                              name: 'name',
                              initialValue: currentProduct['name'],
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
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
                                    //initialValue: currentProduct['upc'],
                                    decoration:
                                        const InputDecoration(labelText: 'UPC'),
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
                              initialValue: currentProduct['category'],
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
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
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
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey),
                              onPressed: () => Navigator.pop(context)),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () {
                              _formKey.currentState?.save();
                              if (_formKey.currentState!.validate()) {
                                updateProduct(
                                    widget.id,
                                    _formKey.currentState!.value['category'],
                                    _formKey.currentState!.value['name'],
                                    _formKey.currentState!.value['upc'],
                                    widget.refresh,
                                    widget.setCategory);

                                //print(_formKey.currentState!.value);
                                _formKey.currentState!.reset();
                                Navigator.pop(context);
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
                  );
                }
              }),
        ),
      ),
    );
  }
}
