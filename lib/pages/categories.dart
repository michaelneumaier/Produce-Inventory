import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/widgets/add_category.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  void refreshCategoriesWidget() {
    log('refresh');
    setState(() {
      InventoryData().read();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: null,
              builder: (context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          //print(snapshot.data[0]);
                          //final categories = snapshot.data['categories'];
                          return ListTile(
                            title: Text(snapshot.data[index]["name"]),
                            trailing: IconButton(
                              onPressed: () {
                                removeCategory(snapshot.data[index]['id'],
                                    refreshCategoriesWidget);
                              },
                              icon: const Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                            ),
                          );
                        })
                    : const CircularProgressIndicator();
              },
            ),
          ),
          AddCategoryWidget(
            refresh: refreshCategoriesWidget,
          )
        ],
      ),
    );
  }
}
