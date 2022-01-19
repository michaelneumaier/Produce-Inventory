import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:orderguide/models/category_images.dart';
import 'package:orderguide/models/inventory_controller.dart';

class EditProductWidget extends StatefulWidget {
  Function refresh;
  final id;
  final products;
  final parentContext;

  EditProductWidget(
      {Key? key,
      required this.refresh,
      required this.id,
      this.products,
      required this.parentContext})
      : super(key: key);

  @override
  _EditProductWidgetState createState() => _EditProductWidgetState();
}

class _EditProductWidgetState extends State<EditProductWidget> {
  late var _categories;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final categories = Categories().getCategories();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IconButton(
      //child: const Text('Add Product'),
      icon: Icon(Icons.edit),
      color: Colors.grey[600],
      onPressed: () {
        showBottomSheet(
            elevation: 2,
            context: widget.parentContext,
            builder: (context) => EditProductBottomSheet(
                  categories: categories,
                  refresh: widget.refresh,
                  id: widget.id,
                  products: widget.products,
                ));
        //addProduct('apples', 'Pink Lady', '4130', widget.refresh);
      },
    ));
  }
}

class EditProductBottomSheet extends StatefulWidget {
  final id;
  final refresh;
  final List products;
  final List categories;
  const EditProductBottomSheet(
      {Key? key,
      required this.categories,
      this.refresh,
      required this.id,
      required this.products})
      : super(key: key);

  @override
  _EditProductBottomSheetState createState() => _EditProductBottomSheetState();
}

class _EditProductBottomSheetState extends State<EditProductBottomSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  final categoriesWithImages = Categories().categoriesWithImages;
  late final _categories;
  final _dropdownMenu = <Widget>[];

  @override
  Widget build(BuildContext context) {
    //print(widget.categories);
    final currentProduct =
        widget.products.firstWhere((element) => element['id'] == widget.id);
    final categoryValues = categoriesWithImages;
    print(categoryValues);
    return SafeArea(
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
                  FormBuilderTextField(
                    name: 'name',
                    initialValue: currentProduct['name'],
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'upc',
                    initialValue: currentProduct['upc'],
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

                  //_categories
                  FormBuilderDropdown(
                    name: 'category',
                    hint: Text('Select Category'),
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
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: FaIcon(
                                      e['icon'] as IconData,
                                      color: e['color'] as Color,
                                    ),
                                  ),
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
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () => Navigator.pop(context)),
              ),
              SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    _formKey.currentState?.save();
                    if (_formKey.currentState!.validate()) {
                      updateProduct(
                          widget.id,
                          _formKey.currentState!.value['category'],
                          _formKey.currentState!.value['name'],
                          _formKey.currentState!.value['upc'],
                          widget.refresh);

                      //print(_formKey.currentState!.value);
                      _formKey.currentState!.reset();
                      Navigator.pop(context);
                    } else {
                      print('Form not valid');
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
    );
  }
}
