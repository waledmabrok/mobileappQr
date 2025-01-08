import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/svg.dart';
import '../ FieldsMachine/setup/background.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafc),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: SvgPicture.asset("assets/top_shap.svg"),
          ),
          Positioned(
            top: 247,
            right: 0,
            child: Container(
              child: SvgPicture.asset("assets/center_shap.svg"),
            ),
          ),
          Positioned(
            bottom: 18,
            left: 0,
            child: Container(
              child: SvgPicture.asset("assets/bottom_shap.svg"),
            ),
          ),
          Positioned(
            top: 382,
            left: 33,
            child: Container(
              child: SvgPicture.asset("assets/3right.svg"),
            ),
          ),
          Positioned(
            top: 382,
            right: 0,
            child: Opacity(
              opacity: 0.3,
              child: Container(
                child: SvgPicture.asset("assets/4center.svg"),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // الرجوع إلى الصفحة السابقة
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "نشاطك",
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildActivityItem(
                icon: FontAwesomeIcons.rightToBracket,
                title: "تسجيل الدخول",
                time: "10:00 صباحًا",
                date: "17 أبريل 2023",
                status: "في الموعد",
                iconColor: Color(0xff73abfd),
              ),
              const SizedBox(height: 10),
              _buildActivityItem(
                icon: FontAwesomeIcons.clock,
                title: "بدء الراحة",
                time: "12:30 مساءً",
                date: "17 أبريل 2023",
                status: "في الموعد",
                iconColor: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String time,
    required String date,
    required String status,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xffe9f2fe),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    date,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  status,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
