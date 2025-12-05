import 'package:intl/intl.dart';

class WeatherModel {
  final String city;
  final double temperature;
  final String weatherDescription;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int sunrise;
  final int sunset;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.weatherDescription,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
  });

  String get sunriseTime => _formatTime(sunrise);
  String get sunsetTime => _formatTime(sunset);

  String _formatTime(int time) {
    try {
      final dateTime =
          DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true);
      final format = DateFormat('HH:mm');
      return format.format(dateTime.toLocal());
    } catch (_) {
      return 'N/A';
    }
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'] ?? '',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      weatherDescription: json['weather'][0]['description'] ?? '',
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
    );
  }
}
