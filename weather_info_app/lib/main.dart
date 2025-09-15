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

  // Today
  String city = '—';
  String temp = '—';
  String condition = '—';

  // 7-day
  List<Map<String, String>> forecast = [];

  void _fetchToday() {
    final c = _cityCtrl.text.trim();
    if (c.isEmpty) return;
    setState(() {
      city = c;
      temp = '${15 + _rng.nextInt(16)} °C';
      condition = _conditions[_rng.nextInt(_conditions.length)];
    });
  }

  void _fetch7Day() {
    final c = _cityCtrl.text.trim();
    if (c.isEmpty) return;
    setState(() {
      city = c;
      forecast = List.generate(7, (i) {
        return {
          'day': 'Day ${i + 1}',
          'temp': '${15 + _rng.nextInt(16)} °C',
          'condition': _conditions[_rng.nextInt(_conditions.length)],
        };
      });
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _fetchToday,
                          child: const Text('Fetch Today'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _fetch7Day,
                          child: const Text('Fetch 7-Day'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('City: $city', style: const TextStyle(fontSize: 16)),
                  Text('Temp: $temp', style: const TextStyle(fontSize: 16)),
                  Text('Condition: $condition', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            // 7-DAY TAB
            Padding(
              padding: const EdgeInsets.all(16),
              child: forecast.isEmpty
                  ? const Center(child: Text('Tap "Fetch 7-Day" on Today tab'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('7-Day Forecast for $city',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: forecast.length,
                            itemBuilder: (context, i) {
                              final d = forecast[i];
                              return Card(
                                child: ListTile(
                                  leading: Text(d['day']!),
                                  title: Text(d['temp']!),
                                  subtitle: Text(d['condition']!),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
