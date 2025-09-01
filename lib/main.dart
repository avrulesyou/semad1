import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigo,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _valueController = TextEditingController();
  String _fromUnit = 'meters';
  String _toUnit = 'feet';
  String _result = '';
  String _selectedUnitType = 'distance';

  // Complete conversion factors for all units
  final Map<String, Map<String, double>> _conversionFactors = {
    // Distance conversions
    'meters': {
      'feet': 3.28084,
      'kilometers': 0.001,
      'miles': 0.000621371,
      'centimeters': 100,
      'inches': 39.3701,
      'yards': 1.09361,
    },
    'feet': {
      'meters': 0.3048,
      'kilometers': 0.0003048,
      'miles': 0.000189394,
      'centimeters': 30.48,
      'inches': 12,
      'yards': 0.333333,
    },
    'kilometers': {
      'meters': 1000,
      'feet': 3280.84,
      'miles': 0.621371,
      'centimeters': 100000,
      'inches': 39370.1,
      'yards': 1093.61,
    },
    'miles': {
      'meters': 1609.34,
      'feet': 5280,
      'kilometers': 1.60934,
      'centimeters': 160934,
      'inches': 63360,
      'yards': 1760,
    },
    'centimeters': {
      'meters': 0.01,
      'feet': 0.0328084,
      'kilometers': 0.00001,
      'miles': 0.00000621371,
      'inches': 0.393701,
      'yards': 0.0109361,
    },
    'inches': {
      'meters': 0.0254,
      'feet': 0.0833333,
      'kilometers': 0.0000254,
      'miles': 0.0000157828,
      'centimeters': 2.54,
      'yards': 0.0277778,
    },
    'yards': {
      'meters': 0.9144,
      'feet': 3,
      'kilometers': 0.0009144,
      'miles': 0.000568182,
      'centimeters': 91.44,
      'inches': 36,
    },
    
    // Weight conversions
    'kilograms': {
      'pounds': 2.20462,
      'grams': 1000,
      'ounces': 35.274,
      'tons': 0.00110231,
    },
    'pounds': {
      'kilograms': 0.453592,
      'grams': 453.592,
      'ounces': 16,
      'tons': 0.0005,
    },
    'grams': {
      'kilograms': 0.001,
      'pounds': 0.00220462,
      'ounces': 0.035274,
      'tons': 0.00000110231,
    },
    'ounces': {
      'kilograms': 0.0283495,
      'pounds': 0.0625,
      'grams': 28.3495,
      'tons': 0.00003125,
    },
    'tons': {
      'kilograms': 907.185,
      'pounds': 2000,
      'grams': 907185,
      'ounces': 32000,
    },
  };

  List<String> _getUnits(String unitType) {
    if (unitType == 'distance') {
      return ['meters', 'feet', 'kilometers', 'miles', 'centimeters', 'inches', 'yards'];
    } else {
      return ['kilograms', 'pounds', 'grams', 'ounces', 'tons'];
    }
  }

  void _convert() {
    double value = double.tryParse(_valueController.text) ?? 0.0;
    if (value == 0.0 && _valueController.text.isNotEmpty) {
      setState(() {
        _result = 'Please enter a valid number';
      });
      return;
    }
    
    if (_conversionFactors.containsKey(_fromUnit) && _conversionFactors[_fromUnit]!.containsKey(_toUnit)) {
      double convertedValue = value * _conversionFactors[_fromUnit]![_toUnit]!;
      setState(() {
        _result = '${value.toStringAsFixed(2)} $_fromUnit = ${convertedValue.toStringAsFixed(4)} $_toUnit';
      });
    } else if (_fromUnit == _toUnit) {
      setState(() {
        _result = '${value.toStringAsFixed(2)} $_fromUnit (same unit)';
      });
    } else {
      setState(() {
        _result = 'Conversion not supported between $_fromUnit and $_toUnit';
      });
    }
  }

  void _onUnitTypeChanged(String? newType) {
    if (newType != null && newType != _selectedUnitType) {
      setState(() {
        _selectedUnitType = newType;
        // Reset to first available units for the new type
        List<String> units = _getUnits(newType);
        _fromUnit = units[0];
        _toUnit = units[1];
        _result = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measures Converter'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Unit Type Selector
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unit Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedUnitType,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        onChanged: _onUnitTypeChanged,
                        items: [
                          DropdownMenuItem(value: 'distance', child: Text('Distance')),
                          DropdownMenuItem(value: 'weight', child: Text('Weight')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Input Value
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Value',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _valueController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Value',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Unit Selection
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Convert From',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _fromUnit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _fromUnit = newValue!;
                            _result = '';
                          });
                        },
                        items: _getUnits(_selectedUnitType).map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                      ),
                      
                      SizedBox(height: 16),
                      
                      Text(
                        'Convert To',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _toUnit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _toUnit = newValue!;
                            _result = '';
                          });
                        },
                        items: _getUnits(_selectedUnitType).map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Convert Button
              ElevatedButton(
                onPressed: _convert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Convert',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Result
              if (_result.isNotEmpty)
                Card(
                  elevation: 4,
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      _result,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
