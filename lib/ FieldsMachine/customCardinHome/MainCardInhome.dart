import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceCard1 extends StatelessWidget {
  final String data;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color textColor;
  final IconData icon;
  final Color iconColor;

  const AttendanceCard1({
    Key? key,
    required this.data,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.textColor,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: bgColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.blue,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  title,
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600], // لون العنوان
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              data,
              style: GoogleFonts.balooBhaijaan2(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: GoogleFonts.balooBhaijaan2(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
