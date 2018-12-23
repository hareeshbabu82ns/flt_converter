import 'package:flutter/material.dart';
import 'unit.dart';

class Category {
  final String iconLocation;
  final String categoryText;
  final ColorSwatch color;
  final List<Unit> units;

  Category({this.iconLocation, this.categoryText, this.color, this.units});
}
