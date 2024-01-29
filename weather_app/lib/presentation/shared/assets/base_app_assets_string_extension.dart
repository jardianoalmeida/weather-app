import 'package:flutter/material.dart';

///
/// [String] extension to access baseapp assets
///
extension BaseAppAssetsStringExtension on String {
  ///
  /// Get a local image asset
  ///
  AssetImage get baseAppImage {
    return AssetImage('assets/images/$this');
  }
}
