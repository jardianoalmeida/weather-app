import '../../../domain/domain.dart';
import '../../interfaces/interfaces.dart';

///
/// [AppPermission] mapping to repository usage
///
class AppPermissionModel {
  /// Permission to request
  final AppPermission permission;

  /// Creates a new [AppPermissionModel]
  AppPermissionModel(this.permission);

  /// Convert [AppPermission]
  DevicePermissionType toDevicePermissionType() {
    switch (permission) {
      case AppPermission.appTrackingTransparency:
        return DevicePermissionType.appTrackingTransparency;
      case AppPermission.location:
        return DevicePermissionType.location;
      case AppPermission.locationAlways:
        return DevicePermissionType.locationAlways;
      case AppPermission.locationWhenInUse:
        return DevicePermissionType.locationWhenInUse;
      case AppPermission.camera:
        return DevicePermissionType.camera;
      case AppPermission.storage:
        return DevicePermissionType.storage;
    }
  }
}
