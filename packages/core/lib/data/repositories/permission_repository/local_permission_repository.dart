import '../../../domain/domain.dart';
import '../../data.dart';
import '../repositories.dart';

///
/// Local implementation of [PermissionRepository]
///
class LocalPermissionRepository implements PermissionRepository {
  /// Device permission client
  final DevicePermission devicePermission;

  /// Creates a new [LocalPermissionRepository]
  LocalPermissionRepository({required this.devicePermission});

  @override
  Future<AppPermissionStatus> check(AppPermission appPermission) async {
    final status = await devicePermission.checkStatus(
      AppPermissionModel(appPermission).toDevicePermissionType(),
    );

    return DevicePermissionStatusModel(status).toEntity();
  }

  @override
  Future<AppPermissionStatus> request(AppPermission appPermission) async {
    final status = await devicePermission.request(
      AppPermissionModel(appPermission).toDevicePermissionType(),
    );

    return DevicePermissionStatusModel(status).toEntity();
  }

  @override
  Future<bool> openSettings() async {
    return await devicePermission.openSettings();
  }
}
