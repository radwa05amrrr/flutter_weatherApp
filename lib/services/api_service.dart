import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/config/api_config.dart'; // هنا

class ApiService {
  final String _apiKey = openWeatherApiKey;

  Future<WeatherModel> fetchWeather(String city) async {
    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      {
        'q': city,
        'appid': _apiKey,
        'units': 'metric',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('City not found');
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
