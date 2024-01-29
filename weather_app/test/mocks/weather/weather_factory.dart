import 'package:weather_app/data/data.dart';
import 'package:weather_app/domain/domain.dart';

class WeatherFactory {
  static Weather makeEntity() => makeModel().toEntity();

  
  static WeatherModel makeModel() => WeatherModel(
        forecastDays: [],
        current: ForecastModel(day: DateTime.now(), maxTemp: 20, minTemp: 17, status: StatusModel(description: '', image: '')),
        location: 'Curitiba',
        tempCurrent: 17,
      );
}
