import 'package:network_info_plus/network_info_plus.dart';

class WiFiManager {
  Future<String?> getConnectedWifiName() async {
    NetworkInfo info = NetworkInfo();
    try {
      return await info.getWifiName();
    } catch (e) {
      print("Error checking Wi-Fi: $e");
      return null;
    }
  }
}
