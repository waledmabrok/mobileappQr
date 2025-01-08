import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../ FieldsMachine/setup/MainColors.dart';
import '../ FieldsMachine/setup/background.dart';
import '../MainHome/CustomFilter.dart';
import '../onboarding/calender.dart';
import '../onboarding/navgate.dart';
import '../onboarding/notification.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            forceMaterialTransparency: false,
            shadowColor: Colors.white,
            forceElevated: false,
            toolbarHeight: 70,
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 2,
            flexibleSpace: Padding(
              padding: const EdgeInsetsDirectional.only(
                  bottom: 10, end: 20, start: 20, top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: userProfilePicture.isNotEmpty
                            ? CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(userProfilePicture),
                              )
                            : Icon(Icons.person, size: 35),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "اهلا ${userName}  ",
                          style: GoogleFonts.balooBhaijaan2(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'قم بتسجيل حضورك الان',
                          style: GoogleFonts.balooBhaijaan2(
                            fontWeight: FontWeight.w400,
                            color: Colorss.Secondtext2,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colorss.BorderColor)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(Icons.notification_important_outlined),
                      ))
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 3),
                          ),
                        );
                      },
                      iconPath: "assets/SvgProfile/wallet-svgrepo-com.svg",
                      // مسار الأيقونة
                      label: 'المحفظه', // النص الذي يظهر أسفل الأيقونة
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 3),
                          ),
                        );
                      },
                      iconPath: "assets/SvgNotifi/wallet-svgrepo-com.svg",
                      // مسار الأيقونة
                      label: 'طلب سلفه', // النص الذي يظهر أسفل الأيقونة
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 3),
                          ),
                        );
                      },
                      iconPath:
                          "assets/SvgProfile/wallet-receive-svgrepo-com2.svg",
                      // مسار الأيقونة
                      label: ' الرواتب', // النص الذي يظهر أسفل الأيقونة
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 3),
                          ),
                        );
                      },
                      iconPath:
                          "assets/SvgProfile/wallet-minus-svgrepo-com.svg",
                      // مسار الأيقونة
                      label: 'الخصومات', // النص الذي يظهر أسفل الأيقونة
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 0),
                          ),
                        );
                      },
                      iconPath: "assets/SvgNavbar/Notifi.svg", // مسار الأيقونة
                      label: 'الاشعارات', // النص الذي يظهر أسفل الأيقونة
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 0),
                          ),
                        );
                      },
                      iconPath:
                          "assets/SvgNavbar/Calender.svg", // مسار الأيقونة
                      label: 'المحفظه', // النص الذي يظهر أسفل الأيقونة
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.only(top: 0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xfff8f8f8),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                top: 20, bottom: 10, start: 20, end: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "الحضور اليومي",
                                  style: GoogleFonts.balooBhaijaan2(
                                    color: Colors.black,
                                    fontSize: 18,
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
                                    childAspectRatio: 1.2,
                                  ),
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    final List<Map<String, dynamic>> cards = [
                                      {
                                        "data": "10:20 صباحًا",
                                        "title": "الدخول",
                                        "subtitle": "في الموعد",
                                        "icon": FontAwesomeIcons.rightToBracket,
                                        "iconColor":
                                            Colorss.BackgroundContainer,
                                      },
                                      {
                                        "data": "07:00 مساءً",
                                        "title": "الخروج",
                                        "subtitle": "الانصراف",
                                        "icon":
                                            FontAwesomeIcons.rightFromBracket,
                                        "iconColor":
                                            Colorss.BackgroundContainer,
                                      },
                                      {
                                        "data": "00:30 دقيقة",
                                        "title": "وقت الراحة",
                                        "subtitle": "متوسط",
                                        "icon": FontAwesomeIcons.clock,
                                        "iconColor":
                                            Colorss.BackgroundContainer,
                                      },
                                      {
                                        "data": "28 يومًا",
                                        "title": "عدد الأيام",
                                        "subtitle": "أيام العمل",
                                        "icon": FontAwesomeIcons.calendarAlt,
                                        "iconColor":
                                            Colorss.BackgroundContainer,
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
                  ),
                ),
              ],
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
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 13,
                    weight: 0.1,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colorss.Secondtext2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              data,
              style: GoogleFonts.balooBhaijaan2(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: GoogleFonts.balooBhaijaan2(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colorss.Secondtext2,
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
              style: GoogleFonts.balooBhaijaan2(
                fontSize: 20,
                fontWeight: FontWeight.w800,
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
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colorss.BackgroundContainer,
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
          iconColor: Colorss.BackgroundContainer,
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          icon: FontAwesomeIcons.clock,
          title: "بدء الراحة",
          time: "12:30 مساءً",
          date: "17 أبريل 2023",
          status: "في الموعد",
          iconColor: Colorss.BackgroundContainer,
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
        /* boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],*/
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 13,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.balooBhaijaan2(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    date,
                    style: GoogleFonts.balooBhaijaan2(
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
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  status,
                  style: GoogleFonts.balooBhaijaan2(
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
