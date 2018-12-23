import 'package:flutter/material.dart';

import 'categories_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.blue[700],
              displayColor: Colors.grey[600],
            ),
        primaryColor: Colors.green[500],
        textSelectionHandleColor: Colors.purple[500],
      ),
      home: CategoriesScreen(),
    );
  }
}
