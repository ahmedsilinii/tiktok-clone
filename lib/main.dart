import 'package:flutter/material.dart';
import 'package:tiktok_clone/core/constants/constants.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Feed App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
