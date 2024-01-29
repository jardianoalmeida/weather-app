import 'status.dart';

class Forecast {
  final int maxTemp;
  final int minTemp;
  final Status status;
  final String day;

  Forecast({
    required this.maxTemp,
    required this.minTemp,
    required this.status,
    required this.day,
  });
}
