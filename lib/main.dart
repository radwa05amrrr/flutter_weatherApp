import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/favorites_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
      routes: {
        '/favorites': (context) =>  FavoritesPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
