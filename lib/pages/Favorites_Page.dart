import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/services/api_service.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/pages/weather_details_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ApiService _apiService = ApiService();
  List<String> _favorites = [];
  Map<String, WeatherModel?> _weatherDataMap = {};
  bool _isLoading = false;
  String _unit = 'metric';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadUnit();
    await _loadFavorites();
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

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('favorites') ?? [];

    setState(() {
      _favorites = stored;
      _isLoading = true;
      _weatherDataMap = {};
    });

    for (final city in stored) {
      try {
        final weather = await _apiService.fetchWeather(city);
        if (!mounted) return;
        setState(() {
          _weatherDataMap[city] = weather;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _weatherDataMap[city] = null;
        });
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromFavorites(String city) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites.remove(city);
      _weatherDataMap.remove(city);
    });
    await prefs.setStringList('favorites', _favorites);
  }

  void _onCityTap(String city, WeatherModel? weather) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            if (weather != null)
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('View weather details'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeatherDetailsPage(
                        city: city,
                        weatherData: weather,
                        addToFavorites: (_) {},
                      ),
                    ),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Remove from favorites',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _removeFromFavorites(city);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? const Center(child: Text('No favorite cities added yet'))
              : ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final city = _favorites[index];
                    final weather = _weatherDataMap[city];

                    String subtitle;
                    if (weather == null) {
                      subtitle = 'Loading weather...';
                    } else {
                      final temp = _convertTemp(weather.temperature);
                      subtitle =
                          'Temp: ${temp.toStringAsFixed(1)}$_unitLabel • ${weather.weatherDescription}';
                    }

                    return ListTile(
                      leading: const Icon(Icons.location_city),
                      title: Text(city),
                      subtitle: Text(subtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _onCityTap(city, weather),
                    );
                  },
                ),
    );
  }
}
