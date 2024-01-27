import 'package:dependencies/dependencies.dart';

///
/// Wrapper for permission_handler.
///
class PermissionHandler {
  /// Call to [permission_handler] `Permission.status`
  Future<PermissionStatus> checkStatus(Permission permission) async {
    return await permission.status;
  }

  /// Call to [permission_handler] `Permission.request()`
  Future<PermissionStatus> request(Permission permission) async {
    return await permission.request();
  }

  /// Call to [permission_handler] `PermissionWithService.serviceStatus`
  Future<ServiceStatus> checkService(PermissionWithService permission) async {
    return await permission.serviceStatus;
  }

  /// Call to [permission_handler] `openAppSettings()`
  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
