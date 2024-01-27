import 'package:flutter/material.dart';

/// A custom banner
class CustomBanner extends StatelessWidget {
  ///  The widget to show behind the banner.
  final Widget child;

  /// Message text
  final String message;

  /// Where to show the banner (e.g., the upper right corner).
  final BannerLocation location;

  /// Banner color
  final Color color;

  ///
  ///  Create new instance of [CustomBanner]
  ///
  const CustomBanner({
    super.key,
    required this.child,
    required this.message,
    this.location = BannerLocation.bottomStart,
    this.color = const Color(0xFF0586F6),
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        location: location,
        message: message,
        color: color,
        child: child,
      ),
    );
  }
}
