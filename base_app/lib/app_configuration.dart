import 'package:core/core.dart';

import 'presentation/views/details/detail_page.dart';
import 'presentation/views/home/home_page.dart';
import 'presentation/views/location/location_page.dart';
import 'presentation/views/splash/splash_page.dart';

///
/// App configurations
///
class AppConfiguration {
  AppConfiguration._();

  static const _package = 'base_app';
  static late EnvironmentReader _reader;

  /// App configurations singleton instance
  static final instance = AppConfiguration._();

  Environment? _environment;

  /// Get current environment variables
  Environment get environment => _environment ??= _read();

  ///
  /// Set flavor configuration
  ///
  Future<void> load() async {
    _reader = EnvironmentReader(_package);
    await _reader.load();
  }

  Environment _read() {
    return Environment(
      appName: Flavor.instance.type.title,
      baseUrl: _reader.read(EnvDictionary.baseApiUrl),
    );
  }

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
        builder: (context, state) => const LocationPage(),
      ),
      GoRoute(
        path: '/location',
        builder: (context, state) => const DetailPage(),
      ),
    ],
  );
}
