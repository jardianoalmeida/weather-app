import 'package:flutter/material.dart';

@immutable
abstract class HomeEvent {}

class SetHome extends HomeEvent {}

class SetInital extends HomeEvent {
  final String? city;
  SetInital({this.city});
}
