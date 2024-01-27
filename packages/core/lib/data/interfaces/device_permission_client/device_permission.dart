import 'device_permission_exception.dart';
import 'device_permission_status.dart';
import 'device_permission_type.dart';

///
/// Device permission handler
///
abstract class DevicePermission {
  ///
  /// Check status of [permission]. Returns a [DevicePermissionStatus] or [DevicePermissionException].
  ///
  /// If the [DevicePermissionType] is associated with a service, check if service is enabled
  ///
  Future<DevicePermissionStatus> checkStatus(DevicePermissionType permission);

  ///
  /// Request for user to allow access to [permission]. Returns a [DevicePermissionStatus] or [DevicePermissionException].
  ///
  Future<DevicePermissionStatus> request(DevicePermissionType permission);

  ///
  /// Open app settings
  ///
  Future<bool> openSettings();
}
