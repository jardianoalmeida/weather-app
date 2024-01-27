/// Device permission type
class DevicePermissionType {
  /// Permission identifier
  final int value;

  /// Available for iOS. Default true
  final bool ios;

  /// Available for Android. Default true
  final bool android;

  const DevicePermissionType._(
    this.value, {
    this.ios = true,
    this.android = true,
  });

  /// Location permission
  static const DevicePermissionType location = DevicePermissionTypeWithService._(0);

  /// Location when is use permission
  static const DevicePermissionType locationWhenInUse = DevicePermissionTypeWithService._(1);

  /// Location always permission
  static const DevicePermissionType locationAlways = DevicePermissionTypeWithService._(2);

  /// iOS App tracking transparency permission
  static const DevicePermissionType appTrackingTransparency = DevicePermissionType._(3, android: false);

  /// Camera permission
  static const DevicePermissionType camera = DevicePermissionTypeWithService._(4);

  /// Storage permission
  static const DevicePermissionType storage = DevicePermissionTypeWithService._(5);
}

/// Device permission associated with OS service
class DevicePermissionTypeWithService extends DevicePermissionType {
  const DevicePermissionTypeWithService._(super.value) : super._();
}
