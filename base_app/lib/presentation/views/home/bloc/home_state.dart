import 'package:flutter/material.dart';

import '../../../../domain/domain.dart';

@immutable
abstract class HomeState {
  final Weather? weather;
  const HomeState({this.weather});
}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLErrorState extends HomeState {}

class HomeLoadedState extends HomeState {
  const HomeLoadedState({required Weather? weather}) : super(weather: weather);
}

  // final bool isAcceptPermission;

 

 
 