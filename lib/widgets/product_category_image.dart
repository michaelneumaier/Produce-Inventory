import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orderguide/models/category_images.dart';
import 'package:orderguide/models/image_controller.dart';

class ProductCategoryImage extends StatefulWidget {
  final String? category;
  final String? upc;

  const ProductCategoryImage(this.category, [this.upc]);

  @override
  State<ProductCategoryImage> createState() => _ProductCategoryImageState();
}

class _ProductCategoryImageState extends State<ProductCategoryImage> {
  var upcWithZeroes = '';

  final categoriesWithImages = Categories().categoriesWithImages;

  var imageUrl = 'https://www.kroger.com/product/images/medium/front/';

  var imageUrlCompleted = false;

  Widget networkImage() {
    if (widget.upc != null) {
      if (imageUrlCompleted == false) {
        var upcZeroes = 13;
        final upcLength = widget.upc.toString().length;
        final zeroesToAdd = upcZeroes - upcLength;
        for (var i = 0; i < zeroesToAdd; i++) {
          imageUrl = imageUrl + '0';
        }
        imageUrl = imageUrl + widget.upc!;
        imageUrlCompleted = true;
      }
      //print(imageUrl);
      return CachedNetworkImage(imageUrl: imageUrl);

      // return Image(
      //   fit: BoxFit.contain,
      //   height: 50,
      //   width: 50,
      //   image: NetworkImage(
      //     imageUrl,
      //     // maxWidth: 50,
      //     // maxHeight: 50,
      //   ),
      // );
    } else {
      return Container();
    }
  }

  late Future imageExistsFuture;
  late Future saveImageFuture;
  late Future loadImageFilePathFuture;
  late String upc = '';
  //var imageExists = null;
  //@override
  // void initState() {
  //   print(widget.upc);
  //   if (widget.upc != null) {
  //     upc = widget.upc;
  //     if (imageUrlCompleted == false) {
  //       var upcZeroes = 13;
  //       final upcLength = widget.upc.toString().length;
  //       final zeroesToAdd = upcZeroes - upcLength;
  //       for (var i = 0; i < zeroesToAdd; i++) {
  //         imageUrl = imageUrl + '0';
  //         upcWithZeroes = upcWithZeroes + '0';
  //       }
  //       imageUrl = imageUrl + widget.upc;
  //       upcWithZeroes = upcWithZeroes + widget.upc;
  //       imageUrlCompleted = true;
  //     }
  //     // imageExistsFuture = _getImageExistsFuture();

  //     // loadImageFilePathFuture = _getLoadImageFilePathFuture();
  //     // saveImageFuture = _getSaveImageFuture();
  //     // if (imageExists == true) {
  //     //   //print(imageExists);
  //     // } else if (imageExists == false) {}
  //   }
  //   super.initState();
  // }

  // _getImageExistsFuture() async {
  //   return imageExists(upcWithZeroes);
  // }

  // _getLoadImageFilePathFuture() async {
  //   return loadImageFilePath(upcWithZeroes);
  // }

  // _getSaveImageFuture() async {
  //   return saveImage(upcWithZeroes);
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.upc != null) {
      if (imageUrlCompleted == false) {
        var upcZeroes = 13;
        final upcLength = widget.upc!.length;
        final zeroesToAdd = upcZeroes - upcLength;
        for (var i = 0; i < zeroesToAdd; i++) {
          imageUrl = imageUrl + '0';
          upcWithZeroes = upcWithZeroes + '0';
        }
        imageUrl = imageUrl + widget.upc!;
        upcWithZeroes = upcWithZeroes + widget.upc!;
        imageUrlCompleted = true;
      }
      //log('not loading image path from json');
      //print(imageExists);
      // if (imageExists == true) {
      //   return FutureBuilder(
      //       future: loadImageFilePath(upcWithZeroes),
      //       builder: (context, snapshot) {
      //         if (snapshot.hasData) {
      //           return Image.file(
      //             snapshot.data as File,
      //             width: 80,
      //             height: 80,
      //           );
      //           // snapshot.data as Widget;
      //         } else {
      //           return const SizedBox(
      //             width: 80,
      //             height: 80,
      //             child: CircularProgressIndicator(),
      //           );
      //         }
      //         //return Image(image: NetworkImage(snapshot.data.toString()));
      //       });
      // }
      return FutureBuilder(
          future: imageExists(upcWithZeroes),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.toString() == 'false') {
                //imageExists = false;

                return FutureBuilder(
                    future: saveImage(upcWithZeroes),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == 'false') {
                          final product = categoriesWithImages.firstWhere(
                              (element) => element['name'] == widget.category);
                          return Image.asset(
                            product['image'] as String,
                            //scale: 11,
                            width: 80,
                            height: 80,
                          );
                        }
                        return Image(
                            image: NetworkImage(imageUrl),
                            width: 80,
                            height: 80);
                      } else {
                        //print('loading image');
                        return const SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(),
                        );
                      }
                    });
              } else if (snapshot.data == true) {
                //imageExists = true;
                //print('file exists!');
                return FutureBuilder(
                    future: loadImageFilePath(upcWithZeroes),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.file(
                          snapshot.data as File,
                          width: 80,
                          height: 80,
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
                    });
              }
            } else {
              return const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data == false) {
              //imageExists = false;
              if (snapshot.hasData) {
                return FutureBuilder(
                    future: saveImage(upcWithZeroes),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == 'false') {
                          final product = categoriesWithImages.firstWhere(
                              (element) => element['name'] == widget.category);
                          return Image.asset(
                            product['image'] as String,
                            //scale: 11,
                            width: 80,
                            height: 80,
                          );
                        }
                        return Image(
                            image: NetworkImage(imageUrl),
                            width: 80,
                            height: 80);
                      } else {
                        //print('loading image');
                        return const SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(),
                        );
                      }
                    });
              } else {
                return const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(),
                );
              }
            } else if (snapshot.data.toString() == 'true') {
              //imageExists = true;
              //print('file exists!');
              return FutureBuilder(
                  future: loadImageFilePath(upcWithZeroes),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.file(
                        snapshot.data as File,
                        width: 80,
                        height: 80,
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
                  });
            }

            if (snapshot.data != '200') {
              final product = categoriesWithImages
                  .firstWhere((element) => element['name'] == widget.category);
              return Image.asset(
                product['image'] as String,
                //scale: 11,
                width: 80,
                height: 80,
              );
            } else {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 80,
                  height: 80,
                ),
              );
            }
          });
      //return networkImage();
      // ;
      // return FaIcon(
      //   product['icon'] as IconData,
      //   color: product['color'] as Color,
      // );

    } else {
      final product = categoriesWithImages
          .firstWhere((element) => element['name'] == widget.category);
      return Image.asset(
        product['image'] as String,
        scale: 15,
      );
    }
  }
}
