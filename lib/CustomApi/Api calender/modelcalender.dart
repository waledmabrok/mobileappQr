/*
class Attendance {
  final String date;
  final String checkInTime;
  final String checkOutTime;
  final String totalTime;
  final String status;

  Attendance({
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.totalTime,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      date: json['date'] ?? '',
      checkInTime: json['check_in_time'] ?? '',
      checkOutTime: json['check_out_time'] ?? '',
      totalTime: json['total_time'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
*/
class Attendance {
  Date date;
  String checkInTime;
  String checkOutTime;
  String totalTime;
  String status;

  Attendance({
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.totalTime,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      date: Date.fromJson(json['date']),
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      totalTime: json['total_time'],
      status: json['status'],
    );
  }
}

class Date {
  String day;
  String dayName;

  Date({
    required this.day,
    required this.dayName,
  });

  factory Date.fromJson(Map<String, dynamic> json) {
    return Date(
      day: json['day'],
      dayName: json['day_name'],
    );
  }
}

