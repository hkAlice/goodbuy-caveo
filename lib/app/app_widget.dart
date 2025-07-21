import 'package:flutter/material.dart';
import 'package:goodbuy/presentation/pages/splash_screen.dart';

class GoodBuyApp extends StatelessWidget {
  const GoodBuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoodBuy',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
            TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
            TargetPlatform.iOS:     CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux:   OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS:   FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashScreen(),
    );
  }
}