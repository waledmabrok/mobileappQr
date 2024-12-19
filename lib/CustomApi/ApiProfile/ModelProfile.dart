// profile_view_model.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiProfileService.dart';


class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  String name = '';
  String address = '';
  String email = '';
  String phone = '';
  String id = '';
  bool isLoading = false;
  String errorMessage = '';

  Future<void> loadUserData() async {
    try {
      isLoading = true;
      notifyListeners();

      int userId = await _profileService.getUserId();
      if (userId == 0) throw Exception('User ID is not found');

      var data = await _profileService.getUserData(userId);
      name = data['name'];
      email = data['email'];
      phone = data['phone'] ?? '';
      address = data['position'] ?? ''; // Use 'position' for address
      id = data['id'].toString();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
