import 'package:flutter/material.dart';

@immutable
abstract class SplashState {}

class SplashInitialState extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashLoadedState extends SplashState {
  final bool isAcceptPermission;

  SplashLoadedState({required this.isAcceptPermission});
}
