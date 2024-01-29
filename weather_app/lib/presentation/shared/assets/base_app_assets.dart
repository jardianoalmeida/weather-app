import 'package:flutter/material.dart';

import 'assets.dart';

///
/// Utility class to access base app assets.
///
abstract class BaseAppAssets {
  static AssetImage get logo => 'splash_logo.jpg'.baseAppImage;
}
