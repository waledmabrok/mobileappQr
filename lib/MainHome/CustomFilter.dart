import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNotificationWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final String label;

  const CustomNotificationWidget({
    Key? key,
    required this.onTap,
    required this.iconPath,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xffe9e9ea),
            width: 0.50,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              color: const Color(0xFF3D48AB),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                label,
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
