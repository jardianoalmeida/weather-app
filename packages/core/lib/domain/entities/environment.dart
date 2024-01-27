/// Base app environment variables
class Environment {
  /// Platform base URL
  final String baseUrl;

  /// App name
  final String appName;

  /// Creates an [Environment]
  const Environment({
    required this.appName,
    required this.baseUrl,
  });
}
