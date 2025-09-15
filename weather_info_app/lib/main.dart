import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Info App',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const WeatherInfoPage(),
    );
  }
}

class WeatherInfoPage extends StatefulWidget {
  const WeatherInfoPage({super.key});

  @override
  State<WeatherInfoPage> createState() => _WeatherInfoPageState();
}

class _WeatherInfoPageState extends State<WeatherInfoPage> {
  final TextEditingController _cityController = TextEditingController();

  // Step 3: Simulated weather state (not yet displayed)
  String? _simCity;
  int? _simTempC;
  String? _simCondition;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _simulateFetchWeather() {
    final city = _cityController.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter a city')));
      return;
    }
    final rand = Random();
    final temp = 15 + rand.nextInt(16); // 15..30
    const conditions = ['Sunny', 'Cloudy', 'Rainy'];
    final condition = conditions[rand.nextInt(conditions.length)];

    setState(() {
      _simCity = city;
      _simTempC = temp;
      _simCondition = condition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City Name',
                hintText: 'Enter city',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _simulateFetchWeather,
              child: const Text('Fetch Weather'),
            ),
            const SizedBox(height: 24),
            // Step 4 will display these values
            const Text('City: —', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Temperature: — °C', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Condition: —', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
