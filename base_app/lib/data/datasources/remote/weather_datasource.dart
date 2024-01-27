import 'dart:async';

import 'package:core/core.dart';

import '../../models/weather_model.dart';

abstract class IWeatherDatasource {
  FutureOr<WeatherModel> getWeather(String city);
}

class WeatherDatasource implements IWeatherDatasource {
  final IHttpClient _client;

  WeatherDatasource(this._client);

  @override
  FutureOr<WeatherModel> getWeather(String city) async {
    final response = await _client.get(
      'http://api.weatherapi.com/v1/forecast.json',
      query: {
        'days': 7,
        'aqi': 'yes',
        'lang': 'pt',
        'alerts': 'no',
        'q': 'curitiba',
        'key': '5edf1a09a41f4b068f7152606220609',
      },
    );

    return WeatherModel.fromJson(
      response.data,
    );
  }
}
