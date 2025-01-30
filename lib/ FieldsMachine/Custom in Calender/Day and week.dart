import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return DateFormat('EEEE d MMMM yyyy', 'ar')
        .format(DateTime.parse(dateString));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Text(
              weekday,
              /*.length > 3 ? weekday.substring(0, 3) : weekday,*/
              style: GoogleFonts.balooBhaijaan2(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                //  color: Color(0xff8c8c8c),
              ),
            ),

            const SizedBox(width: 2), // المسافة بين اليوم واليوم الأسبوعي
            Row(
              children: [
                Text(
                  '$day',
                  style: GoogleFonts.balooBhaijaan2(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
/*
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.all(Radius.circular(10)),
border: Border.all(color: Color(0xffd1d1d1), width: 1),
),*/
