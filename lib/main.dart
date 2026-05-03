import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MExpenseApp());
}

class MExpenseApp extends StatelessWidget {
  const MExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MExpense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF57C6B8),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}