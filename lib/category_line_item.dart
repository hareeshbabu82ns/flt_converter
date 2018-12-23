import 'package:flutter/material.dart';
import './converter_screen.dart';

import 'model/category.dart';
import 'model/unit.dart';

class CategoryLineItem extends StatelessWidget {
  static const _height = 100.0;
  static const _radius = BorderRadius.all(Radius.circular(50.0));
  static const _iconSize = 60.0;
  static const _iconWithColor = 70.0;
  static const _textSize = 24.0;

  final Category category;

  CategoryLineItem(this.category);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: _height,
        child: InkWell(
          borderRadius: _radius,
          highlightColor: category.color[50],
          splashColor: category.color[100],
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (context) {
                  return ConverterScreen(
                    name: category.categoryText,
                    color: category.color,
                    units: category.units,
                  );
                }),
              ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Image.asset(category.iconLocation),
                ),
                Center(
                  child: Text(
                    category.categoryText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display1.copyWith(
                        // color: Colors.grey[700],
                        fontSize: _textSize,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
