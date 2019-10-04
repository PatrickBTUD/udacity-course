// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the color and units to not be null.
  const ConverterRoute({
    @required this.color,
    @required this.units,
  })  : assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  // Set some variables, such as for keeping track of the user's input
  // value and units

  Unit _fromValue;
  Unit _toValue;
  double _inputValue;
  String _outputValue = '';
  List<DropdownMenuItem> _unitMenuItems;
  bool _showInputError = false;

  @override
  void initState() {
    super.initState();
    _setDefaultValues();
    _setMenuItems();
  }

  void _setDefaultValues(){
    setState(() {
      _fromValue = widget.units[0];
      _toValue = widget.units[1];
    });
  }

  void _setMenuItems(){
    var unitItems = new List<DropdownMenuItem>();
    for(var unit in widget.units){
      unitItems.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          )
        )
      ));
    }
    setState(() {
      _unitMenuItems = unitItems;
    });
  }


  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void _inputChanged(String input){
    setState(() {
      if(input == null || input.isEmpty){
        _outputValue = "";
      } else {
        //check for any wrong entered numbers
        try {
          final inputToDouble = double.parse(input);
          _showInputError = false;
          _inputValue = inputToDouble;
          _updateConversion();
        } on Exception catch (e) {
          print(e.toString());
          _showInputError = true;
        }
      }
    });
  }

  void _updateConversion() {
    setState(() {
      _outputValue =
          _format(_inputValue * (_toValue.conversion / _fromValue.conversion));
    });
  }

  Unit _getUnit(String unitName) {
    return widget.units.firstWhere(
          (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  Widget _createDropdown(String currentValue, ValueChanged<dynamic> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentValue,
              items: _unitMenuItems,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    // Create the 'input' group of widgets. This is a Column that
    // includes the input value, and 'from' unit [Dropdown].

    final input = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            style: Theme.of(context).textTheme.title,
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.display1,
              labelText: 'Input',
              errorText: _showInputError ? 'Wrong number entered...' : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.0)
              )
            ),
            //only allow numbers as input values -> show number keyboard
            keyboardType: TextInputType.number,
            onChanged: _inputChanged,
          ),
          _createDropdown(_fromValue.name, _updateFromConversion),
        ],
      ),
    );

    // Create a compare arrows icon.
    final arrowIcon = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    // TODO: Create the 'output' group of widgets. This is a Column that
    // includes the output value, and 'to' unit [Dropdown].

    final output = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            child: Text(
              _outputValue,
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          _createDropdown(_toValue.name, _updateToConversion),
        ],
      ),
    );

    // Return the input, arrows, and output widgets, wrapped in a Column.
    final layout = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        input,
        arrowIcon,
        output,
      ],
    );

    return Padding(
      padding: _padding,
      child: layout,
    );
  }
}
