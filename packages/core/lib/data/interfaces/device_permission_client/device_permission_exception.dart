import 'package:dependencies/dependencies.dart';

///
/// Device permission exception
///
class DevicePermissionException extends Equatable implements Exception {
  /// Error cause
  final String? cause;

  /// Creates a new [DevicePermissionException]
  const DevicePermissionException({this.cause});

  @override
  List<Object?> get props => [cause];
}
