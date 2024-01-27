import 'package:core/core.dart';

import '../../domain/domain.dart';
import '../datasources/remote/weather_datasource.dart';

class WeatherRepository implements IWeatherRepository {
  final IWeatherDatasource _datasource;

  WeatherRepository(this._datasource);

  @override
  Future<Either<WeatherFailure, Weather>> getWeather(String city) async {
    try {
      final response = await _datasource.getWeather(city);

      return Right(response.toEntity());
    } on IHttpException catch (e, s) {
      Log.e(e.toString(), e, s);
      return Left(WeatherFailure.server(message: e.message));
    } catch (e, s) {
      Log.e(e.toString(), e, s);

      return Left(WeatherFailure.unexpected());
    }
  }
}
