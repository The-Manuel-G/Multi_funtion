import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherModel extends ChangeNotifier {
  List<double> _temperatures = [];
  String _errorMessage = '';
  bool _isLoading = false;

  List<double> get temperatures => _temperatures;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> getWeather() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=18.7357&longitude=-70.1627&hourly=temperature_2m'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _temperatures = List<double>.from(jsonResponse['hourly']['temperature_2m'].take(24));
      } else {
        _errorMessage = 'Failed to get response from server';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
