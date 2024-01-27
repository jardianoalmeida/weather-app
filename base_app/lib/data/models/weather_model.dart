import '../../domain/domain.dart';
import 'forecast_model.dart';

class WeatherModel {
  final ForecastModel current;
  final String location;
  final int tempCurrent;
  final List<ForecastModel> forecastDays;

  WeatherModel({
    required this.current,
    required this.location,
    required this.tempCurrent,
    this.forecastDays = const [],
  });

  factory WeatherModel.fromJson(dynamic map) {
    final forecastDays = (map['forecast']['forecastday'] as List);
    forecastDays.removeAt(0);
    return WeatherModel(
      location: map['location']['name'] ?? '',
      tempCurrent: map['current']['temp_c']?.toInt() ?? 0,
      current: ForecastModel.fromJson((map['forecast']['forecastday'] as List).first),
      forecastDays: forecastDays.map(ForecastModel.fromJson).toList(),
    );
  }

  Weather toEntity() {
    return Weather(
      current: current.toEntity(),
      location: location,
      tempCurrent: tempCurrent,
      forecastDays: forecastDays.map((e) => e.toEntity()).toList(),
    );
  }
}
