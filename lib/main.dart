import 'package:flutter/material.dart';
import 'package:tiktok_clone/core/constants/constants.dart';
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';

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
        scaffoldBackgroundColor: AppColors.backgroundColor,
        
      ),
      home: LoginScreen(),
    );
  }
}
