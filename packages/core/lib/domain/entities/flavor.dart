import '../../core.dart';

///
/// List of available app flavors
///
enum FlavorType {
  /// Development flavor
  dev,

  /// Homolog flavor
  hml,

  /// Production flavor
  prod;
}

/// FlavorType extensions
extension FlavorTypeName on FlavorType {
  /// Returns a tittle associated with the current [FlavorType]
  String get title {
    switch (this) {
      case FlavorType.dev:
        return 'Test dev';
      case FlavorType.hml:
        return 'Test hml';
      default:
        return 'Test';
    }
  }
}

///
/// Current app flavor definition.
///
/// If no flavor is set with [setCurrent], [FlavorType.prod] will be used as default.
///
class Flavor {
  Flavor._();

  /// Get current singleton instance
  static Flavor instance = Flavor._();

  FlavorType? _type;

  /// Set current app flavor
  set type(FlavorType type) => _type = type;

  FlavorType getFlavor() {
    const flavorStr = String.fromEnvironment('FLUTTER_APP_FLAVOR');

    return switch (flavorStr) {
      'dev' => FlavorType.dev,
      'stg' => FlavorType.hml,
      _ => FlavorType.prod,
    };
  }

  /// Get current [FlavorType]
  FlavorType get type {
    if (_type == null) {
      Log.d('No flavor was defined. PROD will be used as default!!');
    }

    return _type ?? FlavorType.prod;
  }
}
