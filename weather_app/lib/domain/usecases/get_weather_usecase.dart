import 'package:core/core.dart';

import '../domain.dart';

abstract class IGetWeatherUsecase {
  Future<Either<WeatherFailure, Weather>> call(String city);
}

class GetWeatherUsecase implements IGetWeatherUsecase {
  final IWeatherRepository _repository;

  GetWeatherUsecase(this._repository);
  @override
  Future<Either<WeatherFailure, Weather>> call(String city) {
    return _repository.getWeather(city);
  }
}
