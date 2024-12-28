/*
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';  // أضف هذه المكتبة

class LoginService {
  Future<Map<String, dynamic>> login(String username, String password,String wifi) async {
    try {
      final response = await http.post(
        Uri.parse('https://demos.elboshy.com/attendance/wp-json/attendance/v1/login'),
        body: {
          'username': username,
          'password': password,
          "wifi":wifi

        },

      );

      if (response.statusCode == 200) {print(wifi);
        print(response.body);
        var responseBody = json.decode(response.body);

        // تحقق إذا كانت الاستجابة ناجحة
        if (responseBody['status'] == 'success') {
          // حفظ الـ user_id في SharedPreferences
          await _saveUserId(responseBody['user_id'].toString());

          return responseBody;
        } else {
          return {'status': 'error', 'message': 'حدث خطأ أثناء تسجيل الدخول. يرجى المحاولة لاحقًا.'};
        }
      } else {
        return {'status': 'error', 'message': 'حدث خطأ أثناء تسجيل الدخول. يرجى المحاولة لاحقًا.'};
      }
    } catch (e) {print("Response: $e");  // طباعة الاستجابة

    return {'status': 'error', 'message': 'حدث خطأ أثناء الاتصال بالخادم. يرجى المحاولة لاحقًا.'};
    }
  }

  // دالة لحفظ الـ user_id في SharedPreferences
  Future<void> _saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);  // حفظ الـ user_id
    print("User ID Saved: $userId");  // طباعة الـ user_id للتأكد
  }
}
*/
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';  // أضف هذه المكتبة

class LoginService {
  Future<Map<String, dynamic>> login(String username, String password, String wifi) async {
    try {
      final response = await http.post(
        Uri.parse('https://demos.elboshy.com/attendance/wp-json/attendance/v1/login'),
        body: {
          'username': username,
          'password': password,
          "wifi": wifi
        },
      );

      if (response.statusCode == 200) {
        print(wifi);
        print(response.body);
        var responseBody = json.decode(response.body);

        // تحقق إذا كانت الاستجابة ناجحة
        if (responseBody['status'] == 'success') {
          // حفظ الـ user_id في SharedPreferences
          String userId = responseBody['user_id'].toString();
          await _saveUserId(userId);

          // إجراء طلب آخر للحصول على بيانات المستخدم
          await _fetchUserData(userId);

          return responseBody;
        } else {
          return {'status': 'error', 'message': 'حدث خطأ أثناء تسجيل الدخول. يرجى المحاولة لاحقًا.'};
        }
      } else {
        return {'status': 'error', 'message': 'حدث خطأ أثناء تسجيل الدخول. يرجى المحاولة لاحقًا.'};
      }
    } catch (e) {
      print("Response: $e");  // طباعة الاستجابة

      return {'status': 'error', 'message': 'حدث خطأ أثناء الاتصال بالخادم. يرجى المحاولة لاحقًا.'};
    }
  }

  // دالة لحفظ الـ user_id في SharedPreferences
  Future<void> _saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);  // حفظ الـ user_id
    print("User ID Saved: $userId");  // طباعة الـ user_id للتأكد
  }

  // دالة للحصول على بيانات المستخدم بناءً على الـ user_id
  Future<void> _fetchUserData(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('https://demos.elboshy.com/attendance/wp-json/attendance/v1/employee?id=$userId'),
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        // حفظ بيانات المستخدم في SharedPreferences
        await _saveUserData(responseBody);

        print("User Data: ${responseBody}");  // طباعة البيانات لتأكيد العملية
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // دالة لحفظ بيانات المستخدم في SharedPreferences
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', userData['name'] ?? '');
    await prefs.setString('user_email', userData['email'] ?? '');
    await prefs.setString('user_phone', userData['phone'] ?? '');
    await prefs.setString('user_position', userData['position'] ?? '');
    await prefs.setString('user_department', userData['department'] ?? '');
    await prefs.setString('user_hire_date', userData['hire_date'] ?? '');
    await prefs.setString('user_specialization', userData['specialization'] ?? '');
    await prefs.setString('user_address', userData['address'] ?? '');
    await prefs.setString('user_emergency_contact', userData['emergency_contact'] ?? '');
    await prefs.setInt('user_leave_balance', userData['leave_balance'] ?? 0);
    await prefs.setInt('user_salary', userData['salary'] ?? 0);
    await prefs.setInt('user_total_allowances', userData['total_allowances'] ?? 0);
    await prefs.setInt('user_total_deductions', userData['total_deductions'] ?? 0);
    await prefs.setString('user_loan_status', userData['loan_status'] ?? 'No loans');
    await prefs.setString('user_profile_picture', userData['profile_picture'] ?? '');

    print("User Data Saved");
  }
}
