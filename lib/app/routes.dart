import 'package:go_router/go_router.dart';
import 'package:goodbuy/presentation/pages/main_screen.dart';
import 'package:goodbuy/presentation/pages/splash_screen.dart';

final router = GoRouter(
  initialLocation: '/splashscreen',
  routes: [
    GoRoute(
      path: '/splashscreen',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
    ),
  ],
);