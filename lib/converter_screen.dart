import 'package:flutter/material.dart';

import 'model/unit.dart';

class ConverterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConverterScreen();
  }

  final String name;
  final Color color;
  final List<Unit> units;
  ConverterScreen({this.name, this.color, this.units});
}

class _ConverterScreen extends State<ConverterScreen> {
  static const _padding = 16.0;
  List<DropdownMenuItem> _unitMenuItems;
  Unit _fromValue, _toValue;
  double _inputValue, _outputValue;
  TextEditingController _inputValueCtrl = TextEditingController(),
      _outputValueCtrl = TextEditingController();
  bool _showValidationErrorInput = false, _showValidationErrorOutput = false;

  @override
  void initState() {
    super.initState();
    _buildDropdownMenuItems();
    _setDefaults();
  }

  void _setDefaults() {
    setState(() {
      _fromValue = widget.units[0];
      _toValue = widget.units[1];
    });
  }

  void _updateConversion({bool updateFrom = false, bool updateTo = false}) {
    setState(() {
      if (updateFrom) {
        _inputValueCtrl.text = _format(
            (double.parse(_outputValueCtrl.text) / _toValue.conversion) *
                _fromValue.conversion);
      } else if (updateTo) {
        _outputValueCtrl.text = _format(double.parse(_inputValueCtrl.text) *
            (_toValue.conversion / _fromValue.conversion));
      }
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

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromValue = widget.units.firstWhere((unit) => unit.name == unitName);
      _updateConversion(updateTo: true);
    });
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toValue = widget.units.firstWhere((unit) => unit.name == unitName);
      _updateConversion(updateTo: true);
    });
  }

  void _updateInputValue(String value) {
    setState(() {
      if (value == null || value.isEmpty) {
        _outputValue = 0.0;
        _outputValueCtrl.text = '';
      } else {
        try {
          final double val = double.parse(value);
          _inputValue = val;
          _showValidationErrorInput = false;
          _updateConversion(updateTo: true);
        } on Exception catch (e) {
          _showValidationErrorInput = true;
        }
      }
    });
  }

  void _updateOutputValue(String value) {
    setState(() {
      if (value == null || value.isEmpty) {
        _inputValue = 0.0;
        _inputValueCtrl.text = '';
      } else {
        try {
          final double val = double.parse(value);
          _outputValue = val;
          _showValidationErrorOutput = false;
          _updateConversion(updateFrom: true);
        } on Exception catch (e) {
          _showValidationErrorOutput = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final convertBlock = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );
    final inputBlock = Padding(
      padding: EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _inputValueCtrl,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
                labelText: 'Input',
                labelStyle: Theme.of(context).textTheme.display1,
                errorText:
                    _showValidationErrorInput ? 'Invalid number entered' : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
            onChanged: _updateInputValue,
          ),
          _buildDropdown(
            context,
            _fromValue.name,
            _updateFromConversion,
          ),
        ],
      ),
    );

    final outputBlock = Padding(
      padding: EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _outputValueCtrl,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
                labelText: 'Output',
                labelStyle: Theme.of(context).textTheme.display1,
                errorText: _showValidationErrorOutput
                    ? 'Invalid number entered'
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
            onChanged: _updateOutputValue,
          ),
          _buildDropdown(
            context,
            _toValue.name,
            _updateToConversion,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Converter'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            inputBlock,
            convertBlock,
            outputBlock,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(context, currentValue, ValueChanged<dynamic> onChange) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
            color: Colors.grey[500],
            width: 1,
          )),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentValue,
              items: _unitMenuItems,
              style: Theme.of(context).textTheme.title,
              onChanged: onChange,
            ),
          ),
        ),
      ),
    );
  }

  void _buildDropdownMenuItems() {
    var items = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      items.add(
        DropdownMenuItem(
          value: unit.name,
          child: Container(
              child: Text(
            unit.name,
            softWrap: true,
          )),
        ),
      );
    }
    setState(() {
      _unitMenuItems = items;
    });
  }
}
