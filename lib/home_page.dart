import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text(widget.title)),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchRandomNumber(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('Press button to start.');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return Text(
                  '${snapshot.data}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        tooltip: 'Fetch',
        onPressed: () => setState(() {}),
      ),
    );
  }
}

Future<String> fetchRandomNumber() async {
  final response = await http
      .get(Uri.parse('https://www.randomnumberapi.com/api/v1.0/random'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body)[0].toString();
  } else {
    throw Exception('Failed to load data.');
  }
}
