import 'package:core/core.dart';

import '../domain.dart';

abstract class IWeatherRepository {
  Future<Either<WeatherFailure, Weather>> getWeather(String city);
}
