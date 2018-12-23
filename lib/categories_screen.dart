import 'package:flutter/material.dart';
import './category_line_item.dart';
import 'model/category.dart';
import 'model/unit.dart';

import 'dart:convert';
import 'dart:async';

class CategoriesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoriesScreenState();
  }
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var categories = [];
  @override
  void initState() {
    super.initState();
    // categories = _fetchCategories();
    _fetchLocalCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Converter'),
      ),
      body: _buildCategoriesView(),
    );
  }

  Widget _buildCategoriesView() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, int index) {
          return CategoryLineItem(categories[index]);
        },
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children:
            categories.map((category) => CategoryLineItem(category)).toList(),
      );
    }
  }

  Future<Null> _fetchLocalCategories() async {
    final json = await DefaultAssetBundle.of(context)
        .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(json);

    int _categoryIdx = 0;
    data.keys.forEach((String key) {
      final List<Unit> units =
          data[key].map<Unit>((data) => Unit.fromJson(data)).toList();
      final Category category = Category(
        categoryText: key,
        color: Colors.green,
        iconLocation: _icons[_categoryIdx],
        units: units,
      );
      _categoryIdx++;
      setState(() {
        categories.add(category);
      });
    });
  }

  static const _icons = <String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/mass.png',
    'assets/icons/time.png',
    'assets/icons/digital_storage.png',
    'assets/icons/power.png',
    'assets/icons/currency.png',
  ];
}
