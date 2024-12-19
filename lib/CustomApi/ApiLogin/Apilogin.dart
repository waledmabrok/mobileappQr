import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';  // أضف هذه المكتبة

class LoginService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://demos.elboshy.com/attendance/wp-json/attendance/v1/login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
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
