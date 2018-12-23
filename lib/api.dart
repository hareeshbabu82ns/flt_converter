import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

import 'model/unit.dart';

class Api {
  final HttpClient _httpClient = HttpClient();
  final String _forex_base_url = 'data.fixer.io';
  final String _apiKey = '';
  final String _supportedCurrencies = 'INR,CAD,USD,CHF,EUR';

  Future<List<Unit>> getUnits(String category) async {
    switch (category) {
      case 'Currency':
        {
          final uri = Uri.http(_forex_base_url, '/api/latest', {
            'access_key': _apiKey,
            'symbols': _supportedCurrencies,
          });
          final units = await _fetchCurrencyUnits(uri);
          if (units == null) {
            print('Error retrieving units.');
            return null;
          }
          return units;
        }
      default:
        return null;
    }
  }

  _fetchCurrencyUnits(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.OK) {
        return null;
      }
      final response = await httpResponse.transform(utf8.decoder).join();
      final jsonData = json.decode(response);
      return _parseCurrencyUnits(jsonData);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  List<Unit> _parseCurrencyUnits(Map<String, dynamic> jsonMap) {
    final List<Unit> units = [];
    if (jsonMap['success'] != true) return null;
    // add base unit
    units.add(Unit(name: jsonMap['base'], conversion: 1.0));

    // add supported units
    jsonMap['rates'].forEach((String key, dynamic value) {
      if (key == jsonMap['base']) return;
      units.add(Unit(name: key, conversion: value));
    });

    return units;
  }
}
