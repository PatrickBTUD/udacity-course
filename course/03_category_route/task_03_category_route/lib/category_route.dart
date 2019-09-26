// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/material.dart';
import 'package:task_03_category_route/category.dart';

/// Category Route (screen).
///
/// This is the 'home' screen of the Unit Converter. It shows a header and
/// a list of [Categories].
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryRoute extends StatelessWidget {
  const CategoryRoute();

  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  static const _iconData = Icons.cake;

  @override
  Widget build(BuildContext context) {
    // Create a list of the eight Categories, using the names and colors
    // from above. Use a placeholder icon, such as `Icons.cake` for each
    // Category. We'll add custom icons later.

    List<Category> categoryList = List<Category>();
    //make sure the list have the same amount of elements
    if(_categoryNames.length != _baseColors.length){
      return Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Ooops, something went wrong!',
            style: TextStyle(color: Colors.black, fontSize: 40.0),
          )
        ),
      );
    }
    int index = 0;
    for (var name in _categoryNames) {
      categoryList.add(Category(name: name, color: _baseColors[index], iconLocation: _iconData));
      index += 1;
    }

    // Create a list view of the Categories
    final listView = Container(
      color: Colors.green[100],
      //adding horizontal padding the left and right
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: ListView(
        children: categoryList,
      ),
    );

    final appBar = AppBar(
      elevation: 0.0,
      backgroundColor: Colors.green[100],
      centerTitle: true,
      title: Text(
        'Unit Converter',
        style: TextStyle(color: Colors.black, fontSize: 30.0),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
