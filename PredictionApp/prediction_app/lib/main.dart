import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House Price Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PredictionForm(),
    );
  }
}

class PredictionForm extends StatefulWidget {
  @override
  _PredictionFormState createState() => _PredictionFormState();
}

class _PredictionFormState extends State<PredictionForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, double> _formData = {
    'longitude': 0.0,
    'latitude': 0.0,
    'housing_median_age': 0.0,
    'total_rooms': 0.0,
    'total_bedrooms': 0.0,
    'population': 0.0,
    'households': 0.0,
    'median_income': 0.0,
  };
  String _predictionResult = '';

  Future<void> getPrediction() async {
    var url = Uri.parse('https://y2t3fast-api-heroku-3a60c3764e79.herokuapp.com/predict/');
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json"
      },
      body: json.encode(_formData),
    );
    if (response.statusCode == 200) {
      setState(() {
        _predictionResult = json.decode(response.body)['predicted_median_house_value'].toString();
      });
    } else {
      setState(() {
        _predictionResult = 'Error: ${response.reasonPhrase}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('House Price Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              ..._formData.keys.map((key) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: key.replaceAll('_', ' ').capitalize(),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _formData[key] = double.tryParse(value ?? "") ?? 0.0;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    getPrediction();
                  }
                },
                child: Text('Predict'),
              ),
              SizedBox(height: 30),
              Text(
                _predictionResult,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
