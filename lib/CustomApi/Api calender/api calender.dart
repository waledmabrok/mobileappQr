import 'dart:convert';

import 'package:http/http.dart' as http;

import 'modelcalender.dart';

class AttendanceService {
  Future<List<Attendance>> fetchAttendance(
      int employeeId, int month, int year) async {
    try {
      final response = await http.get(Uri.parse(
          'https://demos.elboshy.com/attendance/wp-json/attendance/v1/calendar?employee_id=$employeeId' +
              (month != 0 ? '&month=$month' : '') +
              (year != 0 ? '&year=$year' : '')));

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          List<dynamic> data = json.decode(response.body);
          return data.map((item) => Attendance.fromJson(item)).toList();
        } else {
          throw Exception('No data available for the selected month');
        }
      } else {
        throw Exception(
            'Failed to load attendance data. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load attendance data: $e');
    }
  }
}
