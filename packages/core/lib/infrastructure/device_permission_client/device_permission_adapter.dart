import 'dart:io';

import '../../core.dart';

///
/// [DevicePermission] implementation with `permission_handler` package
///
class DevicePermissionAdapter implements DevicePermission {
  /// Permission handler client
  final PermissionHandler permissionHandler;

  /// Creates a new [DevicePermissionAdapter]
  DevicePermissionAdapter({
    required this.permissionHandler,
  });

  Permission _devicePermissionTypeToPermission(DevicePermissionType type) {
    switch (type) {
      case DevicePermissionType.appTrackingTransparency:
        return Permission.appTrackingTransparency;
      case DevicePermissionType.location:
        return Permission.location;
      case DevicePermissionType.locationAlways:
        return Permission.locationAlways;
      case DevicePermissionType.locationWhenInUse:
        return Permission.locationWhenInUse;
      case DevicePermissionType.camera:
        return Permission.camera;
      case DevicePermissionType.storage:
        return Permission.storage;
      default:
        throw UnimplementedError('Permission $type not implemented!');
    }
  }

  ///
  /// Check if this permission is available in current platform.
  ///
  bool _isValidForCurrentPlatform(DevicePermissionType permission) {
    if (Platform.isIOS) {
      return permission.ios;
    }

    return permission.android;
  }

  @override
  Future<DevicePermissionStatus> checkStatus(
    DevicePermissionType permission,
  ) async {
    try {
      if (!_isValidForCurrentPlatform(permission)) {
        return DevicePermissionStatus.granted;
      }

      final permissionRequest = _devicePermissionTypeToPermission(permission);

      // TODO: Must be moved to request method: https://github.com/Baseflow/flutter-permission-handler/issues/669
      if (permissionRequest is PermissionWithService) {
        final serviceStatus = await permissionHandler.checkService(permissionRequest);
        if (serviceStatus == ServiceStatus.disabled) {
          return DevicePermissionStatus.serviceDisabled;
        }
      }

      final response = await permissionHandler.checkStatus(permissionRequest);

      return _convertPermissionStatus(response);
    } catch (error) {
      Log.e(error.toString());

      throw DevicePermissionException(cause: error.toString());
    }
  }

  @override
  Future<DevicePermissionStatus> request(
    DevicePermissionType permission,
  ) async {
    try {
      final permissionRequest = _devicePermissionTypeToPermission(permission);

      final response = await permissionHandler.request(permissionRequest);

      return _convertPermissionStatus(response);
    } catch (error) {
      Log.e(error.toString());

      throw DevicePermissionException(cause: error.toString());
    }
  }

  DevicePermissionStatus _convertPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return DevicePermissionStatus.granted;
      case PermissionStatus.permanentlyDenied:
        return DevicePermissionStatus.permanentlyDenied;
      default:
        return DevicePermissionStatus.denied;
    }
  }

  @override
  Future<bool> openSettings() async {
    try {
      return await permissionHandler.openSettings();
    } catch (error) {
      Log.e(error.toString());

      throw DevicePermissionException(cause: error.toString());
    }
  }
}
