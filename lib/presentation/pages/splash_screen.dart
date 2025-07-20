import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // todo: carregar do usecase provider e dar push screen

    return Material(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
            child: Text(
          "Goodbuy",
          style: Theme.of(context).textTheme.headlineLarge,
        )),
      ),
    );
  }
}
