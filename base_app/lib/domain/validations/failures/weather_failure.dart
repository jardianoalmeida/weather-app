/// Class that represent all Weather domain failures
class WeatherFailure {
  const WeatherFailure._({this.message = ''});

  final String message;

  ///  Server Failure
  factory WeatherFailure.server({String message = ''}) => WeatherFailure._(message: message);

  /// Creates [WeatherFailure] that is unexpected by the application
  factory WeatherFailure.unexpected() => const WeatherFailure._();
}
