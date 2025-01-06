import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../ FieldsMachine/setup/MainColors.dart';
import '../ FieldsMachine/setup/background.dart';
import 'Attend2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen5 extends StatefulWidget {
  const AttendanceScreen5({super.key});

  @override
  State<AttendanceScreen5> createState() => _AttendanceScreen5State();
}

String userName = '';
String userProfilePicture = '';

class _AttendanceScreen5State extends State<AttendanceScreen5> {
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'غير معروف'; // استرجاع الاسم
      userProfilePicture =
          prefs.getString('user_profile_picture') ?? ''; // استرجاع الصورة
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              top: 0, left: 0, child: SvgPicture.asset("assets/top_shap.svg")),
          Positioned(
              top: 247,
              right: 0,
              child: Container(
                child: SvgPicture.asset("assets/center_shap.svg"),
              )),
          Positioned(
              top: 382,
              left: 33,
              child: Container(
                child: SvgPicture.asset("assets/3right.svg"),
              )),
          Positioned(
              top: 382,
              right: 0,
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  child: SvgPicture.asset(
                    "assets/4center.svg",
                  ),
                ),
              )),
          Positioned(
              bottom: 18,
              left: 0,
              child: Container(
                child: SvgPicture.asset("assets/bottom_shap.svg"),
              )),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 20, top: 70, end: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "اهلا ${userName} 👋 ",
                              style: GoogleFonts.balooBhaijaan2(
                                color: Color(0xFF9684E1),
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'قم بتسجيل حضورك الان',
                              style: GoogleFonts.balooBhaijaan2(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff909090),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(35)),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30)),
                              ),
                              child: userProfilePicture.isNotEmpty
                                  ? CircleAvatar(
                                radius: 27,
                                backgroundImage:
                                NetworkImage(userProfilePicture),
                              )
                                  : Icon(Icons.person, size: 35),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            left: 4,
                            child: Container(
                              height: 14,
                              width: 14,
                              decoration: BoxDecoration(
                                color: Color(0xff5eb6a1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "الحضور اليومي",
                    style: GoogleFonts.cairo(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final List<Map<String, dynamic>> cards = [
                        {
                          "data": "10:20 صباحًا",
                          "title": "الدخول",
                          "subtitle": "في الموعد",
                          "icon": FontAwesomeIcons.rightToBracket,
                          "iconColor": Colors.blue,
                        },
                        {
                          "data": "07:00 مساءً",
                          "title": "الخروج",
                          "subtitle": "الانصراف",
                          "icon": FontAwesomeIcons.rightFromBracket,
                          "iconColor": Colors.red,
                        },
                        {
                          "data": "00:30 دقيقة",
                          "title": "وقت الراحة",
                          "subtitle": "متوسط",
                          "icon": FontAwesomeIcons.clock,
                          "iconColor": Colors.orange,
                        },
                        {
                          "data": "28 يومًا",
                          "title": "عدد الأيام",
                          "subtitle": "أيام العمل",
                          "icon": FontAwesomeIcons.calendarAlt,
                          "iconColor": Colors.green,
                        },
                      ];
                      final card = cards[index];
                      return _buildAttendanceCard(
                        card['data']!,
                        card['title']!,
                        card['subtitle']!,
                        Colors.white,
                        Colors.black,
                        card['icon']!,
                        card['iconColor']!,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ActivityScreenContent(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(String data, String title, String subtitle,
      Color bgColor, Color textColor, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              data,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "نشاطك",
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityScreen(),
                  ),
                );
              },
              child: Text(
                "عرض الكل",
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
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
          iconColor: Colors.blue,
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
                color: iconColor.withOpacity(0.2),
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
