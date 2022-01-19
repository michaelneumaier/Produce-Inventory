import 'package:flutter/material.dart';
import 'package:orderguide/models/inventory_controller.dart';

class ClearCountsButton extends StatelessWidget {
  const ClearCountsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Clear Counts'),
      onPressed: () => clearCounts(),
    );
  }
}
