import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherDetailsPage extends StatefulWidget {
  final String city;
  final WeatherModel weatherData;
  final Function(String) addToFavorites;

  const WeatherDetailsPage({
    super.key,
    required this.city,
    required this.weatherData,
    required this.addToFavorites,
  });

  @override
  State<WeatherDetailsPage> createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPage> {
  String _unit = 'metric'; // metric = °C, imperial = °F

  @override
  void initState() {
    super.initState();
    _loadUnit();
  }

  Future<void> _loadUnit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _unit = prefs.getString('unit') ?? 'metric';
    });
  }

  double _convertTemp(double tempC) {
    if (_unit == 'imperial') {
      return tempC * 9 / 5 + 32;
    }
    return tempC;
  }

  String get _unitLabel => _unit == 'imperial' ? '°F' : '°C';

  @override
  Widget build(BuildContext context) {
    final w = widget.weatherData;
    final temp = _convertTemp(w.temperature);
    final feels = _convertTemp(w.feelsLike);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.city} Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              widget.addToFavorites(widget.city);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.city} added to favorites')),
              );
            },
            tooltip: 'Add to favorites',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  w.city,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  w.weatherDescription,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  '${temp.toStringAsFixed(1)}$_unitLabel',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Feels like: ${feels.toStringAsFixed(1)}$_unitLabel',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          _infoRow('Humidity', '${w.humidity}%'),
          _infoRow('Wind speed', '${w.windSpeed} m/s'),
          _infoRow('Sunrise', w.sunriseTime),
          _infoRow('Sunset', w.sunsetTime),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
