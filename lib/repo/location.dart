

import 'package:geolocator/geolocator.dart';

class LocationRepo{

  Future<Position> getLocation() async {
      final a = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return a;
  }

  Future<bool> isEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<bool> hasPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

}