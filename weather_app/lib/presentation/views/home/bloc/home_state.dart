import 'package:flutter/material.dart';

import '../../../../domain/domain.dart';

@immutable
abstract class HomeState {
  final Weather? weather;
  const HomeState({this.weather});
}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {}

class HomeLoadedState extends HomeState {
  const HomeLoadedState({required super.weather});
}
