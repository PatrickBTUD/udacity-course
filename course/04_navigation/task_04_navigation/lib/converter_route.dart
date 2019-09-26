// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:task_04_navigation/unit.dart';

/// Converter screen where users can input amounts to convert.
///
/// Currently, it just displays a list of mock units.
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatelessWidget {
  /// Units for this [Category].
  final List<Unit> units;
  final String categoryName;
  final Color categoryColor;

  /// This [ConverterRoute] requires the color and units to not be null.
  // Pass in the [Category]'s color
  const ConverterRoute({
    @required this.categoryName,
    @required this.units,
    @required this.categoryColor,
  }) : assert(categoryName != null),
    assert(units != null),
    assert(categoryColor != null);

  @override
  Widget build(BuildContext context) {
    //init the AppBar with same color as category and name
    final appBar = AppBar(
      elevation: 0.0,
      title: Text(
        categoryName,
        style: TextStyle(
          color: Colors.black,
          fontSize: 30.0,
        ),
      ),
      centerTitle: true,
      backgroundColor: categoryColor,
    );

    // Here is just a placeholder for a list of mock units
    final unitWidgets = units.map((Unit unit) {
      return Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        // Set the color for this Container according to the category
        color: categoryColor,
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      );
    }).toList();

    //create a Scaffold widget with the Appbar at the top and list of units
    return Scaffold(
      appBar: appBar,
      body: ListView(
        children: unitWidgets
      ),
    );
  }
}
