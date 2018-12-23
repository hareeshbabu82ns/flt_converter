import 'package:flutter/material.dart';
import 'unit.dart';

class Category {
  final IconData iconData;
  final String categoryText;
  final ColorSwatch color;
  final List<Unit> units;

  Category({this.iconData, this.categoryText, this.color, this.units});
}
