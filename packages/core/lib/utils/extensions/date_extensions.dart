import 'package:dependencies/dependencies.dart';

///
/// Extension for DateTime utilities
///
extension DateTimeExtensions on DateTime {
  ///
  /// Format
  /// Examples Using the US Locale:
  /// Pattern                           Result
  /// ----------------                  -------
  /// DateFormat.yMd()                 -> 7/10/1996
  /// DateFormat('yMd')                -> 7/10/1996
  /// DateFormat.yMMMMd('en_US')       -> July 10, 1996
  /// DateFormat.jm()                  -> 5:08 PM
  /// DateFormat.yMd().add_jm()        -> 7/10/1996 5:08 PM
  /// DateFormat.Hm()                  -> 17:08 // force 24 hour time
  /// See more examples here: https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
  ///
  String format([String pattern = 'dd/MM/yyyy', String? locale]) {
    return DateFormat(pattern, locale).format(this);
  }

  String get dayName {
    return switch (weekday) {
      1 => 'Segunda-feira',
      2 => 'Terça-feira',
      3 => 'Quarta-feira',
      4 => 'Quinta-feira',
      5 => 'Sexta-feira',
      6 => 'Sábado',
      7 => 'Domingo',
      _ => 'Outro dia',
    };
  }
}
