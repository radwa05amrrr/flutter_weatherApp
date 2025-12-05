import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _unit = 'metric'; // metric = °C, imperial = °F
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUnit();
  }

  Future<void> _loadUnit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _unit = prefs.getString('unit') ?? 'metric';
      _isLoading = false;
    });
  }

  Future<void> _updateUnit(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unit', value);
    setState(() {
      _unit = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value == 'metric'
              ? 'Temperature unit set to Celsius (°C)'
              : 'Temperature unit set to Fahrenheit (°F)',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text(
              'Temperature unit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile<String>(
            title: const Text('Celsius (°C)'),
            value: 'metric',
            groupValue: _unit,
            onChanged: (value) {
              if (value != null) _updateUnit(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Fahrenheit (°F)'),
            value: 'imperial',
            groupValue: _unit,
            onChanged: (value) {
              if (value != null) _updateUnit(value);
            },
          ),
        ],
      ),
    );
  }
}
