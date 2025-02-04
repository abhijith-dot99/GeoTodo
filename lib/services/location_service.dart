import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return GeolocatorPlatform.instance.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
