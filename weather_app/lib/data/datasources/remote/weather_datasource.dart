import 'dart:async';

import 'package:core/core.dart';

import '../../data.dart';

abstract class IWeatherDatasource {
  Future<WeatherModel> getWeather(String city);
}

class WeatherDatasource implements IWeatherDatasource {
  final IHttpClient _client;
  static const String _key = '5edf1a09a41f4b068f7152606220609';

  WeatherDatasource(this._client);

  @override
  Future<WeatherModel> getWeather(String city) async {
    final response = await _client.get(
      'forecast.json',
      query: {
        'days': 3,
        'aqi': 'yes',
        'lang': 'pt',
        'alerts': 'no',
        'q': city,
        'key': _key,
      },
    );

    return WeatherModel.fromJson(response.data);
  }
}
