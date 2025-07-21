import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goodbuy/shared/providers.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(productsProvider, (previous, next) {
      next.when(
        data: (data) async {
          context.go('/main');
        },
        loading: () {},
        error: (error, stackTrace) async {
          context.go('/main');
        },
      );
    });

    return Material(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
            child: Text('Goodbuy',
              style: Theme.of(context).textTheme.headlineLarge!.apply(color: Colors.white),
            )
        ),
      ),
    );
  }
}
