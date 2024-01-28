import 'package:flutter/material.dart';

import '../../core.dart';

///
/// ThemeData factory
///
class ThemeFactory extends ChangeNotifier {
  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool('isDark') ?? false;

    _theme = !isDark ? _buildLight() : _theme = _buildDark();

    prefs.setBool('isDark', _theme == ThemeData.dark());
    notifyListeners();
  }

  ThemeData _theme = _buildLight();

  ThemeData get theme => _theme;

  void toogleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool('isDark') ?? false;

    _theme = isDark ? _buildLight() : _theme = _buildDark();

    prefs.setBool('isDark', _theme == ThemeData.dark());

    notifyListeners();
  }

  /// Get/Create a light [ThemeData] instance.
  ///
  /// If the current ThemeData is null, a new instance is created, otherwise,
  /// the current instance is returned.
  static ThemeData _buildLight() {
    return ThemeData(
      primarySwatch: Colors.red,
    ).copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          // backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: const BorderSide(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  /// Get/Create a dark [ThemeData] instance.
  ///
  /// If the current ThemeData is null, a new instance is created, otherwise,
  /// the current instance is returned.
  static ThemeData _buildDark() {
    return ThemeData.dark();
  }
}
