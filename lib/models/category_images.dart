import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Categories extends StatelessWidget {
  Categories({Key? key}) : super(key: key);

  final categories = [
    'Apples',
    'Pears',
    'Citrus',
    'Stone Fruit',
    'Grapes',
    'Berries',
    'Melons',
    'Tropical Fruit',
    'Tomatoes',
    'Avocados',
    'Potatoes',
    'Onions',
    'Peppers',
    'Dry Vegetables',
    'Wet Vegetables',
  ];
  // final categoriesWithImages = [
  //   {
  //     'Apples': [
  //       {
  //         'name': 'Apples',
  //         'icon': FontAwesomeIcons.appleAlt,
  //         'color': Colors.red[700],
  //       }
  //     ],
  //     'Citrus': [
  //       {
  //         'name': 'Citrus',
  //         'icon': FontAwesomeIcons.lemon,
  //         'color': Colors.yellow,
  //       }
  //     ],
  //     'Stone Fruit': [
  //       {
  //         'name': 'Stone Fruit',
  //         'icon': FontAwesomeIcons.appleAlt,
  //         'color': Colors.purple,
  //       }
  //     ],
  //     'Tropical Fruit': [
  //       {
  //         'name': 'Tropical Fruit',
  //         'icon': FontAwesomeIcons.seedling,
  //         'color': Colors.green,
  //       }
  //     ],
  //     'Tomatoes': [
  //       {
  //         'name': 'Tomatoes',
  //         'icon': FontAwesomeIcons.leaf,
  //         'color': Colors.red[300],
  //       }
  //     ],
  //     'Potatoes': [
  //       {
  //         'name': 'Potatoes',
  //         'icon': FontAwesomeIcons.circle,
  //         'color': Colors.brown[100],
  //       }
  //     ],
  //     'Onions': [
  //       {
  //         'name': 'Onions',
  //         'icon': FontAwesomeIcons.circle,
  //         'color': Colors.yellow[100],
  //       }
  //     ],
  //     'Wet Vegetables': [
  //       {
  //         'name': 'Wet Vegetables',
  //         'icon': FontAwesomeIcons.carrot,
  //         'color': Colors.orange[300],
  //       }
  //     ],
  //     'Peppers': [
  //       {
  //         'name': 'Peppers',
  //         'icon': FontAwesomeIcons.pepperHot,
  //         'color': Colors.red[600],
  //       }
  //     ],
  //   }
  // ];
  final categoriesWithImages = [
    {
      'name': 'Apples',
      'icon': FontAwesomeIcons.appleAlt,
      'color': Colors.red[700],
      'image': 'assets/icons/apple.png',
    },
    {
      'name': 'Pears',
      'icon': FontAwesomeIcons.appleAlt,
      'color': Colors.red[700],
      'image': 'assets/icons/pear.png',
    },
    {
      'name': 'Citrus',
      'icon': FontAwesomeIcons.lemon,
      'color': Colors.yellow,
      'image': 'assets/icons/citrus.png',
    },
    {
      'name': 'Stone Fruit',
      'icon': FontAwesomeIcons.appleAlt,
      'color': Colors.purple,
      'image': 'assets/icons/peach.png',
    },
    {
      'name': 'Grapes',
      'icon': FontAwesomeIcons.appleAlt,
      'color': Colors.purple,
      'image': 'assets/icons/grape.png',
    },
    {
      'name': 'Berries',
      'icon': FontAwesomeIcons.appleAlt,
      'color': Colors.purple,
      'image': 'assets/icons/berries.png',
    },
    {
      'name': 'Melons',
      'icon': FontAwesomeIcons.seedling,
      'color': Colors.green,
      'image': 'assets/icons/melon.png',
    },
    {
      'name': 'Tropical Fruit',
      'icon': FontAwesomeIcons.seedling,
      'color': Colors.green,
      'image': 'assets/icons/tropical.png',
    },
    {
      'name': 'Tomatoes',
      'icon': FontAwesomeIcons.leaf,
      'color': Colors.red[300],
      'image': 'assets/icons/tomato.png',
    },
    {
      'name': 'Avocados',
      'icon': FontAwesomeIcons.leaf,
      'color': Colors.red[300],
      'image': 'assets/icons/avocado.png',
    },
    {
      'name': 'Potatoes',
      'icon': FontAwesomeIcons.solidCircle,
      'color': Colors.brown[100],
      'image': 'assets/icons/potato.png',
    },
    {
      'name': 'Onions',
      'icon': FontAwesomeIcons.solidCircle,
      'color': Colors.yellow[100],
      'image': 'assets/icons/onion.png',
    },
    {
      'name': 'Peppers',
      'icon': FontAwesomeIcons.pepperHot,
      'color': Colors.red[600],
      'image': 'assets/icons/pepper.png',
    },
    {
      'name': 'Dry Vegetables',
      'icon': FontAwesomeIcons.carrot,
      'color': Colors.green,
      'image': 'assets/icons/cucumber.png',
    },
    {
      'name': 'Wet Vegetables',
      'icon': FontAwesomeIcons.carrot,
      'color': Colors.orange[300],
      'image': 'assets/icons/lettuce.png',
    },
  ];

  getCategories() {
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
