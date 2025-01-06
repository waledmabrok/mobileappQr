import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../setup/MainColors.dart';

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Color(0xFF487FDB),
              Color(0xFF9684E1),
            ],
            stops: [0.1667, 1.9756],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Icon(
            icon,
            size: screenWidth * 0.042,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
              fontSize: screenWidth * 0.030,
              fontWeight: FontWeight.bold,
              color: Colorss.SecondText),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          clockIn,
          style: TextStyle(
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ],
    );
  }
}
