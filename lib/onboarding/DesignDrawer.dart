import 'package:flutter/material.dart';

class Vector8Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -88,
      top: -14,
      child: Container(
        width: 350,
        height: 164,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8E4FF), // اللون الأول
              Color(0xFFE7EDFF), // اللون الثاني
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white), // إطار أبيض
          borderRadius: BorderRadius.circular(200), // حواف دائرية
        ),
      ),
    );
  }
}
