import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:orderguide/models/inventory_controller.dart';

class AddCategoryWidget extends StatefulWidget {
  Function refresh;

  AddCategoryWidget({Key? key, required this.refresh}) : super(key: key);

  @override
  _AddCategoryWidgetState createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ElevatedButton(
      child: const Text('Add Category'),
      onPressed: () {
        showBottomSheet(
            context: context,
            builder: (context) =>
                AddCategoryBottomSheet(refresh: widget.refresh));
        //addProduct('apples', 'Pink Lady', '4130', widget.refresh);
      },
    ));
  }
}

class AddCategoryBottomSheet extends StatefulWidget {
  Function refresh;
  AddCategoryBottomSheet({Key? key, required this.refresh}) : super(key: key);

  @override
  _AddCategoryBottomSheetState createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
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
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ])),
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
                      //print(_formKey.currentState!.value);
                      // addCategory(
                      //     _formKey.currentState!.value["name"], widget.refresh);
                      Navigator.pop(context);
                    } else {
                      print('Form not valid');
                    }
                  },
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
