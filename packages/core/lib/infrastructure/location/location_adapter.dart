// import 'dart:developer';

// import '../../core.dart' hide LocationData;
// import '../../domain/domain.dart' show LocationData;

// ///
// /// Location definition
// ///
// abstract class ILocationAdapter {
//   Future<LocationData?> getLocation();
//   Future<bool> checkLocationPermission();
// }

// ///
// /// Implementation of [ILocationAdapter]
// ///
// class LocationAdapter implements ILocationAdapter {
//   Location get location => Location();

//   IPermissionService get _permissionService => DM.get<IPermissionService>();

//   /// Check location permission
//   @override
//   Future<bool> checkLocationPermission() async {
//     try {
//       final response = await _permissionService.checkStatus(AppPermission.location);

//       return response == AppPermissionStatus.granted;
//     } on AppPermissionException catch (error) {
//       Log.e('Failed to open settings', error);
//       return false;
//     }
//   }

//   @override
//   Future<LocationData?> getLocation() async {
//     try {
//       final granted = await checkLocationPermission();
//       log('Error: $granted');
//       if (!granted) {
//         return null;
//       }

//       var locationData = await location.getLocation();

//       if (locationData.isNull) return null;
//       return LocationData(
//         latitude: locationData.latitude ?? .0,
//         longitude: locationData.longitude ?? .0,
//       );
//     } catch (e) {
//       log('Error: $e');
//       return null;
//     }
//   }
// }
