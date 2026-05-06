import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://restcountries.com/v3.1';

  static Future<List<String>> fetchAllCountries() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<String> countries = data.map((country) => country['name']['common'] as String).toList();
        countries.sort();
        return countries;
      }
      throw Exception('Failed to load countries');
    } catch (e) {
      return _getFallbackCountries();
    }
  }

  static List<String> _getFallbackCountries() {
    return ['United States', 'United Kingdom', 'Canada', 'Australia', 'Germany', 'France'];
  }
}