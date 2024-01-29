import 'package:core/core.dart';
import 'package:flutter/material.dart';

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
        builder: (context, state) => HomePage(cityArgument: state.extra as String?),
      ),
      GoRoute(
        path: '/location',
        name: '/location',
        builder: (context, state) => LocationPage(isFromHome: state.extra as bool),
      ),
      GoRoute(
        path: '/error',
        name: '/error',
        builder: (context, state) => ErrorPage(onTryAgain: state.extra as VoidCallback),
      ),
    ],
  );
}
