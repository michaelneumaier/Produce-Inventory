import 'package:flutter/material.dart';
import 'package:orderguide/models/inventory_controller.dart';

class RemoveProductWidget extends StatelessWidget {
  final int id;
  final String name;
  final Function refresh;

  // ignore: use_key_in_widget_constructors
  const RemoveProductWidget(this.id, this.name, this.refresh);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure you want to delete $name?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            removeProduct(id, refresh);
            Navigator.pop(context, 'OK');
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
