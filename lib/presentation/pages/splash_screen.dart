import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodbuy/presentation/pages/main_screen.dart';
import 'package:goodbuy/shared/providers.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(productsProvider, (previous, next) {
      next.when(
        data: (data) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        },
        loading: () {},
        error: (error, stackTrace) {
          // todo: no exception, continuar para mainscreen com status de falha
          throw Exception('nao gostou');
        },
      );
    });

    return Material(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
            child: Text('Goodbuy',
              style: Theme.of(context).textTheme.headlineLarge,
            )
        ),
      ),
    );
  }
}
