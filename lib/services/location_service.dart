import 'package:geolocator/geolocator.dart';

class LocationService {
  // Method to get the current location of the device
  static Future<Position> getCurrentLocation() async {
    // Check if location services are enabled on the device
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }
    // Check the current location permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }

    // Once permissions are granted, get the current location and return it
    return await Geolocator.getCurrentPosition();
  }

 // Method to calculate the distance between two geographical points
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
      // Use the Geolocator instance to calculate the distance between the two points
    return GeolocatorPlatform.instance.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
