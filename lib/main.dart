import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../pages/home_page.dart';

void main() async {
  await setup();
  /// print("MAPBOX_ACCESS_TOKEN: ${dotenv.env['pk.eyJ1Ijoicm1hbm5uYW5hIiwiYSI6ImNtN2hrNnlmMzExcTcyaXM3bTd0Yjg4dXgifQ.dYu1M4988kKW1D9Ig3PLPQflut']}");
  runApp(const MyApp());
}

Future<void> setup() async {
  await dotenv.load(
    fileName: ".env",
  );
  MapboxOptions.setAccessToken(
    dotenv.env["MAPBOX_ACCESS_TOKEN"]!,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
