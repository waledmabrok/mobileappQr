import 'package:geolocator/geolocator.dart';

class LocationManager {
  double targetLatitude;
  double targetLongitude;
  double allowedDistance;

  LocationManager(this.targetLatitude, this.targetLongitude, this.allowedDistance);

  Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print("Error fetching current location: $e");
      return null;
    }
  }

  double calculateDistance(double targetLat, double targetLong, double currentLat, double currentLong) {
    return Geolocator.distanceBetween(targetLat, targetLong, currentLat, currentLong);
  }
}
