import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/weather.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Weather App',
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final TextEditingController queryController = TextEditingController();

  String _currentTemperature = '';

  Weather? _weather;

  bool _isLoading = false;



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  Future<void> search(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      final uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$query&appid=f51e5f9d0c8388ea7f4ae0fbc86fc2d1');
      final response = await http.get(uri);
      print(response);
      print(response.statusCode);
      final data = json.decode(response.body);
      print(data);
      final name = data['city'];
      print(name);

     setState(() {
           _currentTemperature = '$data';
        _isLoading = false;

        });
    }
       http.Response? response;
    try {
      final uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$query&appid=f51e5f9d0c8388ea7f4ae0fbc86fc2d1');
      response = await http.get(uri);
      if (response.statusCode == HttpStatus.ok) {
        final data = json.decode(response.body);
        setState(() {
          _weather = Weather.fromJson(data); // Weather /// TYPE SAFE
        }); // Map<String, dynamic> !!! NOT TYPE SAFE

      } else {
        throw Exception("Status: ${response.statusCode}");
      }
    } on FormatException catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response?.body}')));
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No Internet Connection!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather API Demo'),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: queryController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Query'),
              ),
            ),
          ),
          TextButton(
            child: const Text('Search'),
            onPressed: () {
              search(queryController.text);
            },
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Text(
              _currentTemperature,
              style: Theme.of(context).textTheme.headline1,
            ),
        ],
      )),
    );
  }
}