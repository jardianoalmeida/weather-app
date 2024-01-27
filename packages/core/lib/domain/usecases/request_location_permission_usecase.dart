import '../../core.dart';
import '../failures/location_failure.dart';

/// Use case to request the camera permission
abstract class IRequestLocationPermissionUsecase {
  /// An object method to execute the usecase
  Future<Either<LocationFailure, bool>> call();
}

/// Concrete implementation of the [IRequestLocationPermissionUsecase]
class RequestLocationPermissionUsecase implements IRequestLocationPermissionUsecase {
  final PermissionRepository _repository;

  /// Creates new instance of [RequestLocationPermissionUsecase]
  RequestLocationPermissionUsecase(this._repository);

  @override
  Future<Either<LocationFailure, bool>> call() async {
    return const Right(true);
  }
}
