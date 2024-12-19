// profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  Future<Map<String, dynamic>> getUserData(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('https://demos.elboshy.com/attendance/wp-json/attendance/v1/employee/1'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0; // Get user_id from SharedPreferences
  }
}
