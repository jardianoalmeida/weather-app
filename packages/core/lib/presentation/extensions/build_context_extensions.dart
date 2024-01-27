import 'package:flutter/widgets.dart';

///
/// Extensions for [BuildContext] class
///
extension BuildContextExtesions on BuildContext {
  ///
  /// Get [MediaQueryData] from current context
  ///
  MediaQueryData get mediaQuery {
    return MediaQuery.of(this);
  }

  ///
  /// Get current screen width, based on current context
  ///
  double get screenWidth {
    return mediaQuery.size.width;
  }

  ///
  /// Get current screen height, based on current context
  ///
  double get screenHeight {
    return mediaQuery.size.height;
  }

  ///
  /// Get a fraction of the total available width.
  /// [widthFactor] must be greater than 0.0.
  ///
  double fractionallyScreenWidth(double widthFactor) {
    assert(widthFactor > 0.0);

    return screenWidth * widthFactor;
  }

  ///
  /// Get a fraction of the total available height.
  /// [heightFactor] must be greater than 0.0.
  ///
  double fractionallyScreenHeight(double heightFactor) {
    assert(heightFactor > 0.0);

    return screenHeight * heightFactor;
  }
}
