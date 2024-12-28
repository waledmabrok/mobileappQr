import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


Future<void> performApiCall({
  required String url, // API URL
  required String method, // HTTP method (GET, POST, PUT, DELETE)
  Map<String, dynamic>? bodyData, // Body data for POST or PUT requests
  Map<String, String>? headers, // Headers for the request
  bool parseResponse = false, // Do you need to parse the response?
  Function(dynamic)? onSuccess, // Callback when API call is successful
  Function()? onError, // Callback when API call fails
  Function()? onLoading,
  BuildContext? context,
}) async {
  try {
    // Display loading state if provided
    if (onLoading != null) {
      onLoading();
    }

    // Initialize bodyData if it's null
    bodyData ??= {};

    // Get the app language from SharedPreferences
    // Get the app language from SharedPreferences or fallback to device language
    final prefs = await SharedPreferences.getInstance();
    String? appLanguage = prefs.getString('languageCode');

    if (appLanguage == null || appLanguage.isEmpty) {
      // If no language stored, use the device's default language
      appLanguage = WidgetsBinding.instance.window.locale.languageCode;
      // Optionally save the device language in SharedPreferences for future requests
      await prefs.setString('languageCode', appLanguage);
    }

    final token = prefs.getString('auth_token');
    bodyData['language'] = appLanguage;
    headers ??= {};
    headers['Authorization'] = 'Bearer $token';
    headers['Content-Type'] = 'application/json';
    // Print body data for debugging
    print("Body data before sending: $bodyData");
    print("Headers data before sending: $headers");
    print("token data before sending: $token");

    // Choose the right HTTP method
    late http.Response response;
    switch (method) {
      case 'POST':
        response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(bodyData),
        );
        break;
      case 'GET':
        response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
        break;
      case 'PUT':
        response = await http.put(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(bodyData),
        );
        break;
      case 'DELETE':
        response = await http.delete(
          Uri.parse(url),
          headers: headers,
        );
        break;
      default:
        throw Exception('Unsupported HTTP method');
    }

    // Handle the response
    if (response.statusCode == 200) {
      if (parseResponse && onSuccess != null) {
        // Try to decode the response
        dynamic jsonResponse;
        try {
          jsonResponse = jsonDecode(response.body);
        } catch (e) {
          jsonResponse =
              response.body; // If parsing fails, treat as plain String
        }

        // Pass the response to onSuccess
        onSuccess(jsonResponse);
      } else if (onSuccess != null) {
        onSuccess(response.body); // Treat as a raw string if no parsing needed
      }
    } else if (response.statusCode == 401) {
      if (context != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        await prefs.remove('user_id');

        print('Unauthorized access detected. Navigating to login page.');
        /* Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
              (route) => false,
        );*/
      }
      throw Exception('Unauthorized access');
    } else {
      if (onError != null) {
        onError();
      }
      throw Exception(
          'Failed to perform API call with status code: ${response.body}');
    }
  } catch (e) {
    print('Error during API call: $e');
    if (onError != null) {
      onError();
    }
  }
}