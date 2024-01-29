import '../../core.dart';

///
/// Location definition
///
abstract class ILocationAdapter {
  Future<String?> getLocation();
  Future<bool> checkLocationPermission();
}

///
/// Implementation of [ILocationAdapter]
///
class LocationAdapter implements ILocationAdapter {
  /// Check location permission
  @override
  Future<bool> checkLocationPermission() async {
    try {
      final isGranted = await Geolocator.checkPermission();
      if (!_accept(isGranted)) {
        final permission = await Geolocator.requestPermission();
        return _accept(permission);
      }
      return _accept(isGranted);
    } catch (e) {
      return false;
    }
  }

  bool _accept(LocationPermission permission) {
    return permission == LocationPermission.always ||
        permission == LocationPermission.unableToDetermine ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<String?> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      return placemarks[0].locality ?? 'Cidade Desconhecida';
    } catch (e) {
      Log.e('Erro ao obter localização: $e');
      return null;
    }
  }
}
