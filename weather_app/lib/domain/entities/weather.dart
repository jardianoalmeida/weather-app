import 'forecast.dart';

class Weather {
  final Forecast current;
  final String location;
  final List<Forecast> forecastDays;
  final int tempCurrent;

  Weather({
    required this.current,
    required this.location,
    required this.forecastDays,
    required this.tempCurrent,
  });
}
