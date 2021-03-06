import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MyLocation {
  static Future<LatLng> getLatLng() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return LatLng(39.47061165396297, -0.37643521614850756);
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return LatLng(39.47061165396297, -0.37643521614850756);
      }
    }

    _locationData = await location.getLocation();

    return LatLng(_locationData.latitude!, _locationData.longitude!);
  }
}
