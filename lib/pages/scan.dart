import 'package:flutter/material.dart';
import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/widgets/scan_list_view.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late List products;

  @override
  void initState() {
    super.initState();
    InventoryData().readProducts().then((value) => products = value);
  }

  readProducts() {
    InventoryData().readProducts().then((value) => products = value);
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
      ),
      body: const ScanListView(),
    );
  }
}
