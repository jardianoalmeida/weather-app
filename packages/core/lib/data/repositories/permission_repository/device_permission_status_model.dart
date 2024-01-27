import '../../../domain/domain.dart';
import '../../interfaces/interfaces.dart';

///
/// [AppPermissionStatus] mapping for repository usage
///
class DevicePermissionStatusModel {
  /// Device permission status
  final DevicePermissionStatus status;

  /// Create a new [DevicePermissionStatusModel]
  DevicePermissionStatusModel(this.status);

  /// Convert to [AppPermissionStatus] entity
  AppPermissionStatus toEntity() {
    switch (status) {
      case DevicePermissionStatus.granted:
        return AppPermissionStatus.granted;
      case DevicePermissionStatus.denied:
        return AppPermissionStatus.denied;
      case DevicePermissionStatus.permanentlyDenied:
        return AppPermissionStatus.permanentlyDenied;
      case DevicePermissionStatus.serviceDisabled:
        return AppPermissionStatus.serviceDisabled;
    }
  }
}
