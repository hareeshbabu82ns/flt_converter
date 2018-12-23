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

    data.keys.forEach((String key) {
      final List<Unit> units =
          data[key].map<Unit>((data) => Unit.fromJson(data)).toList();
      final Category category = Category(
        categoryText: key,
        color: Colors.green,
        iconData: Icons.cake,
        units: units,
      );
      setState(() {
        categories.add(category);
      });
    });
  }
}

List<Category> _fetchCategories() {
  final List<Category> categories = [];
  categories.add(
    Category(
      categoryText: "Length",
      iconData: Icons.cake,
      color: Colors.purple,
      units: _fetchUnits("Length"),
    ),
  );
  categories.add(Category(
    categoryText: "Area",
    iconData: Icons.cake,
    color: Colors.purple,
    units: _fetchUnits("Area"),
  ));
  categories.add(Category(
    categoryText: "Volume",
    iconData: Icons.cake,
    color: Colors.orange,
    units: _fetchUnits("Volume"),
  ));
  categories.add(Category(
    categoryText: "Mass",
    iconData: Icons.line_weight,
    color: Colors.blue,
    units: _fetchUnits("Mass"),
  ));
  categories.add(Category(
    categoryText: "Time",
    iconData: Icons.av_timer,
    color: Colors.yellow,
    units: _fetchUnits("Time"),
  ));
  categories.add(Category(
    categoryText: "Digital Storage",
    iconData: Icons.sd_storage,
    color: Colors.purple,
    units: _fetchUnits("Digital Storage"),
  ));
  categories.add(Category(
    categoryText: "Energy",
    iconData: Icons.cake,
    color: Colors.purple,
    units: _fetchUnits("Energy"),
  ));
  categories.add(Category(
    categoryText: "Currency",
    iconData: Icons.cake,
    color: Colors.purple,
    units: _fetchUnits("Currency"),
  ));
  return categories;
}

List<Unit> _fetchUnits(String forCategory) {
  return List<Unit>.generate(
    10,
    (int i) => Unit(
          name: '$forCategory ${++i}',
          conversion: i.toDouble(),
        ),
  );
}
