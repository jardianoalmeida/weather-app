import 'package:core/core.dart';

import '../../domain/entities/forecast.dart';
import 'status_model.dart';

class ForecastModel {
  final int maxTemp;
  final int minTemp;
  final StatusModel status;
  final DateTime day;

  ForecastModel({
    required this.maxTemp,
    required this.minTemp,
    required this.status,
    required this.day,
  });

  factory ForecastModel.fromJson(dynamic map) {
    return ForecastModel(
      day: DateTime.parse(map['date']),
      maxTemp: map['day']['maxtemp_c']?.toInt() ?? 0,
      minTemp: map['day']['mintemp_c']?.toInt() ?? 0,
      status: StatusModel.fromJson(map['day']['condition']),
    );
  }

  Forecast toEntity() {
    return Forecast(
      maxTemp: maxTemp,
      minTemp: minTemp,
      status: status.toEntity(),
      day: day.dayName,
    );
  }
}
