///
/// Status enum for device permissions
///
enum DevicePermissionStatus {
  /// User granted access to the permission
  granted,

  /// User denied access to the permission
  denied,

  /// User denied access to the permission and request to not ask again
  permanentlyDenied,

  /// Service related to the permission is disabled
  serviceDisabled,
}
