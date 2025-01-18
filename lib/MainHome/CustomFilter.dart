import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNotificationWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final String? label;

  const CustomNotificationWidget({
    Key? key,
    required this.onTap,
    required this.iconPath,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 75,
        decoration: BoxDecoration(
          border: label != null && label!.isNotEmpty
              ? Border.all(
                  color: const Color(0xffe9e9ea),
                  width: 0.50,
                )
              : null,
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
              color: Colors.black,
            ),
            if (label != null && label!.isNotEmpty) // تحقق من وجود نص
              const SizedBox(height: 10),
            if (label != null && label!.isNotEmpty)
              Center(
                child: Text(
                  label!,
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
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
