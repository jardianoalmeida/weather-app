import 'package:core/core.dart';

 
import 'presentation/presentation.dart';

///
/// App configurations
///
class AppConfiguration {
  AppConfiguration._();

  /// App configurations singleton instance
  static final instance = AppConfiguration._();

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/location',
        name: '/location',
        builder: (context, state) => const LocationPage(),
      ),
      GoRoute(
        path: '/error',
        name: '/error',
        builder: (context, state) => const LocationPage(),
      ),
    ],
  );
}
