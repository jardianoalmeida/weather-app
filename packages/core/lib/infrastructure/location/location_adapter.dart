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
    return await Permission.location.status.isGranted;
  }

  @override
  Future<String?> getLocation() async {
    try {
      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.high,
      // );

      List<Placemark> placemarks = await placemarkFromCoordinates(-25.4420485, -49.3459459);

      return placemarks[0].locality ?? 'Cidade Desconhecida';
    } catch (e) {
      Log.e('Erro ao obter localização: $e');
      return null;
    }
  }
}
