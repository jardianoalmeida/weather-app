// ignore: depend_on_referenced_packages
import 'package:fl_geocoder/fl_geocoder.dart' as geo;
import 'package:location/location.dart';

/// Utility method to build an [Location] instance
Future<List<geo.Result>> locationBuilder() async {
  var location = await Location().getLocation();

  final geocoder = geo.FlGeocoder('AIzaSyDifFEnop3OBO50K0ovtbna0YSZHhp7uLg');

  var coordinates = geo.Location(location.latitude ?? 0.0, location.longitude ?? 0.0);

  final results = await geocoder.findAddressesFromLocationCoordinates(location: coordinates);

  return results;
}
