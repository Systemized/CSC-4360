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
        body: const TabBarView(
          children: [
            Center(child: Text('Today tab - coming soon')),
            Center(child: Text('7-Day tab - coming soon')),
          ],
        ),
      ),
    );
  }
}
