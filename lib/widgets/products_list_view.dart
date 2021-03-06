import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:orderguide/main.dart';
import 'package:orderguide/models/category_images.dart';
import 'package:orderguide/models/image_controller.dart';
import 'package:orderguide/models/inventory_controller.dart';
import 'package:orderguide/models/products.dart';
import 'package:orderguide/models/upc.dart';
import 'package:orderguide/widgets/alert_box.dart';
import 'package:orderguide/widgets/plus_minus_button.dart';
import 'package:orderguide/widgets/product_category_image.dart';
import 'package:orderguide/widgets/product_dialog.dart';

class ProductsListView extends StatefulWidget {
  final List categories;

  final AsyncSnapshot snapshot;
  final bool? editProducts;
  final String? setCategory;
  final Function refresh;
  final Function setCategoryFunction;

  const ProductsListView(
      {Key? key,
      required this.categories,
      required this.snapshot,
      required this.refresh,
      this.editProducts,
      this.setCategory,
      required this.setCategoryFunction})
      : super(key: key);

  @override
  _ProductsListViewState createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  final _formKey = GlobalKey<FormBuilderState>();
  final categoriesWithImages = Categories().categoriesWithImages;
  bool editProducts = false;

  String categoryFilter = 'all';
  final viewProductsInventoryKey =
      const PageStorageKey('View Products Listview Key');
  final editProductsListViewKey =
      const PageStorageKey('Edit Products Listview Key');
  final viewProductsScrollController = ScrollController();
  final editProductsScrollController = ScrollController();
  // var showOrganicOnly = MyApp.sharedPreferences.getBool('view_organic_only');

  void setEditProductsBool(bool truth) {
    //print('seteditproducts to true');
    editProducts = truth;
    setState(() {
      editProducts = truth;
    });
  }

  @override
  void initState() {
    if (widget.editProducts != null) {
      editProducts = widget.editProducts!;
    }
    if (widget.setCategory != null) {
      //log('set categoryfilter to ' + widget.setCategory!);
      categoryFilter = widget.setCategory!;
    }
    //print('products list view init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = MyApp.sharedPreferences.getString('image_path');
    int currentVisibleIndex = -1;
    final viewOrganicOnly =
        MyApp.sharedPreferences.getBool('view_organic_only');
    final viewPackagedOnly =
        MyApp.sharedPreferences.getBool('view_packaged_only');
    const allProductsDropdownItem = DropdownMenuItem(
        value: 'all',
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'All Products',
            textScaleFactor: 1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
    final categoryDropdownItems = categoriesWithImages
        .map((e) => DropdownMenuItem(
            value: e['name'],
            child:
                Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              const SizedBox(width: 5),
              SizedBox(
                width: 40,
                height: 30,
                child: ProductCategoryImage(e['name'].toString()),
                // child: FaIcon(
                //   e['icon'] as IconData,
                //   color: e['color'] as Color,
                // ),
              ),
              const SizedBox(width: 5),
              Text(
                e['name'].toString(),
                textScaleFactor: 1,
              ),
            ])))
        .toList();
    // final categoryDropDownItems = List.generate(
    //     widget.categories.length,
    //     (index) => DropdownMenuItem(
    //         child: ProductCategoryImage(widget.categories[index])));
    //print(widget.snapshot.data.toString());

    return Column(
      children: [
        FormBuilderDropdown(
          key: _formKey,
          name: 'category',
          initialValue: categoryFilter,
          items: [allProductsDropdownItem, ...categoryDropdownItems],
          onChanged: (e) {
            //print(e);
            setState(() {
              if (editProducts == true) {
                editProductsScrollController.jumpTo(0);
              }
              if (editProducts == false) {
                viewProductsScrollController.jumpTo(0);
              }
              categoryFilter = e.toString();
              widget.setCategoryFunction(e.toString());
            });
          },
        ),
        // Wrap(children: [
        //   ...List.generate(widget.categories.length,
        //       (index) => ProductCategoryImage(widget.categories[index]))
        // ]),
        editProducts == true
            ? Expanded(
                child: ReorderableListView(
                  cacheExtent: 1000,
                  scrollController: editProductsScrollController,
                  key: editProductsListViewKey,
                  onReorder: (oldIndex, newIndex) {
                    //print('reorder');
                    //print(oldIndex);
                    //print(newIndex);
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex = newIndex - 1;
                      }
                      //print(newIndex);
                      final element = widget.snapshot.data.removeAt(oldIndex);
                      //print(element.toString());
                      widget.snapshot.data.insert(newIndex, element);
                      writeJson(widget.snapshot.data);
                      //widget.refresh();
                    });
                  },
                  children: List.generate(widget.snapshot.data.length, (index) {
                    //Start Product Instantiation

                    var snapshotData = widget.snapshot.data[index];
                    bool? isVisible;

                    if (snapshotData['visible'] != null) {
                      isVisible = snapshotData['visible'];
                    } else {
                      isVisible = true;
                    }
                    final count = snapshotData['count'] as num;
                    bool hasImage = false;
                    if (snapshotData['image'] != null) {
                      hasImage = true;
                    }
                    bool isOrganic = false;
                    if (snapshotData['is_organic'] == true) {
                      isOrganic = true;
                    }

                    Product product = Product(
                        id: snapshotData['id'] as int,
                        category: snapshotData['category'],
                        name: snapshotData['name'],
                        image: hasImage ? snapshotData['image'] : '',
                        upc: snapshotData['upc'] as String,
                        organic: isOrganic,
                        count: count.toDouble(),
                        visible: isVisible!);
                    //End Product Instantiation
                    //print(index);

                    if ((categoryFilter == product.category ||
                        categoryFilter == 'all')) {
                      if (product.isOrganic == false &&
                          viewOrganicOnly == true) {
                        return Container(
                          key: ValueKey(index),
                        );
                      } else if (product.isPackaged == false &&
                          viewPackagedOnly == true) {
                        return Container(
                          key: ValueKey(index),
                        );
                      } else {
                        currentVisibleIndex++;
                        return Card(
                          key: ValueKey(index),
                          elevation: 1,
                          child: ListTile(
                            horizontalTitleGap: 0,
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 0, 5),
                            tileColor: currentVisibleIndex.isEven
                                ? product.isOrganic
                                    ? Colors.lightGreen[100]
                                    : Colors.grey[100]
                                : product.isOrganic
                                    ? Colors.lightGreen[200]
                                    : Colors.grey[200],

                            leading: SizedBox(
                              width: 30,
                              height: 30,
                              child: Checkbox(
                                value: isVisible,
                                onChanged: (value) {
                                  setState(() {
                                    toggleProductVisibility(
                                        product.id, widget.refresh);
                                    //product.visible = value;
                                    snapshotData['visible'] = value;
                                    isVisible = value;
                                    //log('toggle visible $value');
                                  });
                                },
                              ),
                            )
                            // ProductCategoryImage(
                            //     widget.snapshot.data[index]["category"])
                            ,
                            //leading: Text(widget.snapshot.data[index]["category"]),
                            title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      product.name,
                                      textScaleFactor: 1,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: Wrap(spacing: 20, children: [
                                      Text(
                                        product.upc,
                                        textScaleFactor: 1,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      product.isOrganic
                                          ? const Text(
                                              'Organic',
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Container()
                                    ]),
                                  ),
                                ]),
                            trailing: Wrap(
                              spacing: -10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/edit-product', arguments: {
                                        'id': product.id,
                                        'refresh': widget.refresh,
                                        'setEditProducts': setEditProductsBool,
                                        'setCategory': categoryFilter
                                      }).whenComplete(
                                          () => setEditProductsBool(true));
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          RemoveProductWidget(product.id,
                                              product.name, widget.refresh)),
                                  icon: const Icon(Icons.delete),
                                  color: Theme.of(context).errorColor,
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                                  child: Icon(Icons.reorder),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      return Container(key: ValueKey(index));
                    }
                  }),
                ),
              )
            : Expanded(
                child: ListView(
                  cacheExtent: 4000,
                  controller: viewProductsScrollController,
                  key: viewProductsInventoryKey,
                  children: List.generate(widget.snapshot.data.length, (index) {
                    //Start Product Instantiation
                    var snapshotData = widget.snapshot.data[index];
                    bool isVisible;
                    if (snapshotData['visible'] != null) {
                      isVisible = snapshotData['visible'];
                    } else {
                      isVisible = true;
                    }
                    final count = snapshotData['count'] as num;
                    bool hasImage;
                    if (snapshotData['image'] == '') {
                      hasImage = false;
                    } else if (snapshotData['image'] == null) {
                      hasImage = false;
                    } else {
                      hasImage = true;
                    }

                    bool isOrganic = false;
                    if (snapshotData['is_organic'] == true) {
                      isOrganic = true;
                    }

                    final product = Product(
                        id: snapshotData['id'] as int,
                        category: snapshotData['category'],
                        name: snapshotData['name'],
                        image: hasImage ? snapshotData['image'] : '',
                        upc: snapshotData['upc'] as String,
                        organic: isOrganic,
                        count: count.toDouble(),
                        visible: isVisible);
                    //End Product Instantiation
                    //bool isOrganic = false;

                    //bool isVisible = true;
                    String fullUpc = createFullUpc(product.upc);
                    //print(widget.snapshot.data[index]["image"]);
                    // if (widget.snapshot.data[index]["upc"][0] == "9") {
                    //   isOrganic = true;
                    // }
                    final imageFilePath = File('$imagePath/$fullUpc');
                    final imageFile = Image.file(
                      imageFilePath,
                      width: 80,
                      height: 80,
                    );

                    if ((categoryFilter == product.category ||
                            categoryFilter == 'all') &&
                        isVisible) {
                      if (product.isOrganic == false &&
                          viewOrganicOnly == true) {
                        return Container();
                      } else if (product.isPackaged == false &&
                          viewPackagedOnly == true) {
                        return Container();
                      } else {
                        currentVisibleIndex++;
                        return SizedBox(
                          //key: ValueKey(product.id),
                          height: 80,
                          child: GestureDetector(
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => ProductDialog(
                                        product: product,
                                      ));
                            },
                            child: Card(
                                color: currentVisibleIndex.isEven
                                    ? product.isOrganic
                                        ? Colors.lightGreen[50]
                                        : Colors.grey[100]
                                    : product.isOrganic
                                        ? Colors.lightGreen[100]
                                        : Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        color: Colors.blueGrey.shade200)),
                                elevation: 2,
                                child: Row(
                                  //mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                top: BorderSide(
                                                    style: BorderStyle.solid,
                                                    color: Colors
                                                        .blueGrey.shade200,
                                                    width: 1),
                                                left: BorderSide(
                                                    style: BorderStyle.solid,
                                                    color: Colors
                                                        .blueGrey.shade200,
                                                    width: 1),
                                                bottom: BorderSide(
                                                    style: BorderStyle.solid,
                                                    color: Colors
                                                        .blueGrey.shade200,
                                                    width: 1),
                                                right: BorderSide(
                                                    style: BorderStyle.solid,
                                                    color: Colors
                                                        .blueGrey.shade200,
                                                    width: 1)),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                        child: imageFilePath.existsSync()
                                            ? imageFile
                                            : ProductCategoryImage(
                                                product.category, product.upc),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            product.isOrganic
                                                ? const FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 0, 2),
                                                      child: Text(
                                                        'Organic',
                                                        textScaleFactor: 1,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  product.name,
                                                  textScaleFactor: 1,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            // const SizedBox(
                                            //   height: 5,
                                            // ),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child:
                                                  Wrap(spacing: 20, children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      product.upc,
                                                      textScaleFactor: 1,
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ]),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: FittedBox(
                                        alignment: Alignment.centerRight,
                                        fit: BoxFit.contain,
                                        child: Wrap(
                                          spacing: -10,
                                          alignment: WrapAlignment.end,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            PlusMinusButton(
                                                widget: widget,
                                                index: index,
                                                delta: Delta.half),
                                            PlusMinusButton(
                                              widget: widget,
                                              index: index,
                                              delta: Delta.minus,
                                            ),
                                            SizedBox(
                                              width: 30,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                //width: 34,
                                                child: Text(
                                                  product.getCount,
                                                  //widget.snapshot.data[index]["count"].toString(),
                                                  textAlign: TextAlign.center,
                                                  textScaleFactor: 1,
                                                  style: const TextStyle(
                                                      fontSize: 24),
                                                ),
                                              ),
                                            ),
                                            PlusMinusButton(
                                              widget: widget,
                                              index: index,
                                              delta: Delta.plus,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )

                                // ListTile(
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(10.0),
                                //   ),
                                //   horizontalTitleGap: 5,
                                //   contentPadding:
                                //       const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                //   tileColor: index.isEven
                                //       ? isOrganic
                                //           ? Colors.lightGreen[100]
                                //           : Colors.grey[100]
                                //       : isOrganic
                                //           ? Colors.lightGreen[200]
                                //           : Colors.grey[200],
                                //   key: ValueKey(index),
                                //   leading: Container(
                                //     decoration: BoxDecoration(
                                //         color: Colors.white,
                                //         border: Border(
                                //             top: BorderSide(
                                //                 style: BorderStyle.solid,
                                //                 color: Colors.blueGrey.shade200,
                                //                 width: 1),
                                //             left: BorderSide(
                                //                 style: BorderStyle.solid,
                                //                 color: Colors.blueGrey.shade200,
                                //                 width: 1),
                                //             bottom: BorderSide(
                                //                 style: BorderStyle.solid,
                                //                 color: Colors.blueGrey.shade200,
                                //                 width: 1),
                                //             right: BorderSide(
                                //                 style: BorderStyle.solid,
                                //                 color: Colors.blueGrey.shade200,
                                //                 width: 1)),
                                //         borderRadius: BorderRadius.only(
                                //             topLeft: Radius.circular(10),
                                //             bottomLeft: Radius.circular(10))),
                                //     height: double.infinity,
                                //     child: ProductCategoryImage(
                                //         widget.snapshot.data[index]["category"],
                                //         widget.snapshot.data[index]['upc']),
                                //   ),
                                //   //leading: Text(widget.snapshot.data[index]["category"]),
                                //   title: Column(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [
                                //         FittedBox(
                                //           fit: BoxFit.contain,
                                //           child: Text(
                                //             widget.snapshot.data[index]["name"],
                                //             style: const TextStyle(fontSize: 20),
                                //           ),
                                //         ),
                                //         const SizedBox(
                                //           height: 5,
                                //         ),
                                //         Wrap(spacing: 20, children: [
                                //           Text(
                                //             widget.snapshot.data[index]["upc"],
                                //             style: const TextStyle(fontSize: 14),
                                //           ),
                                //           isOrganic
                                //               ? const Text(
                                //                   'Organic',
                                //                   style: TextStyle(
                                //                       fontSize: 14,
                                //                       fontWeight:
                                //                           FontWeight.bold),
                                //                 )
                                //               : Container()
                                //         ]),
                                //       ]),
                                //   trailing: Wrap(
                                //     spacing: 0,
                                //     crossAxisAlignment: WrapCrossAlignment.center,
                                //     children: [
                                //       PlusMinusButton(
                                //           widget: widget,
                                //           index: index,
                                //           delta: Delta.Half),
                                //       PlusMinusButton(
                                //         widget: widget,
                                //         index: index,
                                //         delta: Delta.Minus,
                                //       ),
                                //       SizedBox(
                                //         width: 30,
                                //         child: FittedBox(
                                //           fit: BoxFit.scaleDown,
                                //           //width: 34,
                                //           child: Text(
                                //             countDouble.toString(),
                                //             //widget.snapshot.data[index]["count"].toString(),
                                //             textAlign: TextAlign.center,
                                //             style: const TextStyle(fontSize: 24),
                                //           ),
                                //         ),
                                //       ),
                                //       PlusMinusButton(
                                //         widget: widget,
                                //         index: index,
                                //         delta: Delta.Plus,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                ),
                          ),
                        );
                      }
                    } else {
                      return Container();
                    }
                  }),
                ),
              ),
      ],
    );
  }
}
