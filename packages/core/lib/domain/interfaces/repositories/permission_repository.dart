import '../../domain.dart';

///
/// Datasource for app permission requests
///
abstract class PermissionRepository {
  /// Check permission status for an [appPermission]
  Future<AppPermissionStatus> check(AppPermission appPermission);

  /// Request user permission for an [appPermission]
  Future<AppPermissionStatus> request(AppPermission appPermission);

  /// Open app settings
  Future<bool> openSettings();
}
