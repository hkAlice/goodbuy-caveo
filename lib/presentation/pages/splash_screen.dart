import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Text("Goodbuy", style: Theme.of(context).textTheme.headlineLarge,)
        ),
      ),
    );
  }
}
