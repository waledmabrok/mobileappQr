import 'package:flutter/cupertino.dart';

class AttendanceColumn extends StatelessWidget {
  final String clockIn;
  final String label;
  final IconData icon;

  const AttendanceColumn({
    super.key,
    required this.clockIn,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Icon(icon, size: screenWidth * 0.04,color:Color(0xff99989a) ,),
        const SizedBox(height: 4),
        Text(
          clockIn,
          style: TextStyle(fontSize: screenWidth * 0.03,fontWeight: FontWeight.bold,color: Color(0xff373739)), // ضبط حجم النص بناءً على عرض الشاشة
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: screenWidth * 0.030,fontWeight: FontWeight.bold,color:Color(
              0xff959496)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}