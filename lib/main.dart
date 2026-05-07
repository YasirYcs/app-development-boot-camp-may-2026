import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/index.dart';
import 'screens/index.dart';
import 'services/index.dart';
import 'utils/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  final hiveService = HiveService();
  await hiveService.initHive();

  runApp(
    MultiProvider(
      providers: [
        // Create ExpenseProvider as a singleton
        ChangeNotifierProvider(
          create: (_) =>
              ExpenseProvider(hiveService)
                ..initializeExpenses(), // Load expenses on startup
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MExpenses',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/splash': (context) => const SplashScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
