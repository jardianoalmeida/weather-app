import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/forecast.dart';

class DayTile extends StatelessWidget {
  final Forecast forecast;
  const DayTile({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            forecast.day,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Image.network(
            forecast.status.image,
            height: 30.0,
          ),
          Dimension.xxs.horizontal,
          Text(
            '${forecast.minTemp}°',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Dimension.md.horizontal,
          Container(
            width: 52,
            height: 4.0,
            color: Theme.of(context).primaryColorLight,
          ),
          Dimension.md.horizontal,
          Text(
            '${forecast.maxTemp}°',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
