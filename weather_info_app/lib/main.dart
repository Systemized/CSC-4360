import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Info',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _cityCtrl = TextEditingController();
  final _rng = Random();
  final _conditions = const ['Sunny', 'Cloudy', 'Rainy', 'Windy', 'Stormy'];

  String city = '—';
  String temp = '—';
  String condition = '—';

  void _fetchToday() {
    final c = _cityCtrl.text.trim();
    if (c.isEmpty) return;
    setState(() {
      city = c;
      temp = '${15 + _rng.nextInt(16)} °C';
      condition = _conditions[_rng.nextInt(_conditions.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weather Info'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Today', icon: Icon(Icons.wb_sunny)),
              Tab(text: '7-Day', icon: Icon(Icons.calendar_view_week)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TODAY TAB
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _cityCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Enter City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _fetchToday,
                    child: const Text('Fetch Today'),
                  ),
                  const SizedBox(height: 16),
                  Text('City: $city', style: const TextStyle(fontSize: 16)),
                  Text('Temp: $temp', style: const TextStyle(fontSize: 16)),
                  Text('Condition: $condition', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            // 7-DAY TAB (placeholder for now)
            const Center(child: Text('7-day forecast coming in feature branch')),
          ],
        ),
      ),
    );
  }
}
