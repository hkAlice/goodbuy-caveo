import 'package:flutter/material.dart';
import 'package:goodbuy/presentation/pages/splash_screen.dart';

class GoodBuyApp extends StatelessWidget {
  const GoodBuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoodBuy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const SplashScreen(),
    );
  }
}