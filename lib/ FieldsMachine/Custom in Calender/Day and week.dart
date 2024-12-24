import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class DayAndWeekdayColumn extends StatelessWidget {
  final String day;
  final String weekday;

  const DayAndWeekdayColumn({
    super.key,
    required this.day,
    required this.weekday,
  });
  String formatDate(String dateString) {
    return DateFormat(' d ', 'ar')
        .format(DateTime.parse(dateString));
    }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Color(0xffd1d1d1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [

            Text(
    '$day',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 2), // المسافة بين اليوم واليوم الأسبوعي
            Text(
              weekday.length > 3 ? weekday.substring(0, 3) : weekday,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Color(0xff8c8c8c),
              ),
            ),
          ],
        ),
      ),
    );
  }
}