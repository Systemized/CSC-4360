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

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
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
              onPressed: () {
                // Will simulate in Step 3
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fetch Weather tapped')),
                );
              },
              child: const Text('Fetch Weather'),
            ),
            const SizedBox(height: 24),
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
