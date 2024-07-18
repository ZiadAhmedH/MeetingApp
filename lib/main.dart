import 'package:flutter/material.dart';
import 'package:meeting_app/views/HomePage.dart';
import 'package:meeting_app/views/splashScreen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meeting App',
      home: SplashScreen(),
    );
  }
}

