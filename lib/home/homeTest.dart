import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../ FieldsMachine/customCardinHome/MainCardInhome.dart';
import '../ FieldsMachine/setup/MainColors.dart';
import '../ FieldsMachine/setup/background.dart';
import '../MainHome/CustomFilter.dart';
import '../onboarding/Profile/Wallet/Wallet.dart';
import '../onboarding/Profile/Wallet/opponent.dart';
import '../onboarding/Statistics/StatisticsMain.dart';
import '../onboarding/Summary/Sammary1.dart';
import '../onboarding/calender.dart';
import '../onboarding/home1.dart';
import '../onboarding/navgate.dart';
import '../onboarding/notification.dart';
import 'Attend2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'CustomMainHome/Leave.dart';

class AttendanceScreen5 extends StatefulWidget {
  const AttendanceScreen5({super.key});

  @override
  State<AttendanceScreen5> createState() => _AttendanceScreen5State();
}

String userName = '';
String userProfilePicture = '';
String user_position = '';
bool _isContainerVisible = true;

class _AttendanceScreen5State extends State<AttendanceScreen5> {
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'غير معروف';
      userProfilePicture = prefs.getString('user_profile_picture') ?? '';

      user_position = prefs.getString('user_position') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkLastShownTimestamp();
  }

  _checkLastShownTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastShownTimestamp = prefs.getInt('lastShownTimestamp');

    // Get the current timestamp
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    if (lastShownTimestamp == null ||
        currentTimestamp - lastShownTimestamp > 24 * 60 * 60 * 1000) {
      // Show the container if 24 hours have passed
      setState(() {
        _isContainerVisible = true;
      });
    } else {
      setState(() {
        _isContainerVisible = false;
      });
    }
  }

  // Update the timestamp when the container is shown
  _updateTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'lastShownTimestamp', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat('MMMM', 'ar').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                forceMaterialTransparency: true,
                shadowColor: Colors.white,
                forceElevated: false,
                toolbarHeight: 70,
                floating: true,
                // snap: true,
                backgroundColor: Colors.white,
                elevation: 2,
                flexibleSpace: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                        bottom: 10, end: 20, start: 20, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
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
                            //  mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // الاسم
                              Text(
                                userName,
                                style: GoogleFonts.balooBhaijaan2(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // الوظيفة
                              Text(
                                user_position,
                                style: GoogleFonts.balooBhaijaan2(
                                  fontWeight: FontWeight.w400,
                                  color: Colorss.Secondtext2,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          overlayColor: WidgetStatePropertyAll(Colors.white),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(index2: 1),
                              ),
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: Colorss.BorderColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Icon(
                                  Icons.notification_important_outlined,
                                  size: 22,
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomNotificationWidget(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PieChartSample2(),
                              ),
                            );
                          },
                          iconPath:
                              "assets/Customhome/statistics-graph-stats-analytics-business-data-svgrepo-com.svg",
                          // مسار الأيقونة
                          label: 'الاحصائيات', // النص الذي يظهر أسفل الأيقونة
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        CustomNotificationWidget(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeaveRequestPage(),
                              ),
                            );
                          },
                          iconPath:
                              "assets/Customhome/calendar-svgrepo-com.svg",
                          // مسار الأيقونة
                          label: 'الاجازات', // النص الذي يظهر أسفل الأيقونة
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
                              "assets/Customhome/permissions-svgrepo-com.svg",
                          // مسار الأيقونة
                          label: 'الاذونات', // النص الذي يظهر أسفل الأيقونة
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        CustomNotificationWidget(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiscountsPage(),
                              ),
                            );
                          },
                          iconPath:
                              "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                          // مسار الأيقونة
                          label: 'السٌلَف', // النص الذي يظهر أسفل الأيقونة
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        CustomNotificationWidget(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiscountsPage(),
                              ),
                            );
                          },
                          iconPath:
                              "assets/SvgProfile/wallet-minus-svgrepo-com.svg",
                          // مسار الأيقونة
                          label: 'الاقساط', // النص الذي يظهر أسفل الأيقونة
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
                              "assets/SvgNavbar/back-svgrepo-com.svg", // مسار الأيقونة
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
                        padding: const EdgeInsetsDirectional.only(
                            top: 0, bottom: 10),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "الحضور اليوم",
                                          style: GoogleFonts.balooBhaijaan2(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            // الانتقال إلى صفحة الإحصائيات
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CurrentMonthStatistics(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shadowColor: Colors.transparent,
                                            overlayColor: Colors.white,
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 0),
                                          ),
                                          label: Text(
                                            "احصائيات ${currentMonth}",
                                            style: GoogleFonts.balooBhaijaan2(
                                              color: Colorss.mainColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          icon: Icon(
                                            FontAwesomeIcons.calendar,
                                            color: Colorss.mainColor,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        for (var card in [
                                          {
                                            "data": "10:20 صباحًا",
                                            "title": "الدخول",
                                            "subtitle": "في الموعد",
                                            "icon":
                                                FontAwesomeIcons.rightToBracket,
                                            "iconColor": Colors.blue,
                                          },
                                          {
                                            "data": "07:00 مساءً",
                                            "title": "الخروج",
                                            "subtitle": "الانصراف",
                                            "icon": FontAwesomeIcons
                                                .rightFromBracket,
                                            "iconColor": Colors.green,
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
                                            "icon":
                                                FontAwesomeIcons.calendarAlt,
                                            "iconColor": Colors.purple,
                                          },
                                        ])
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                25,
                                            child: AttendanceCard1(
                                              data: card["data"] as String,
                                              // Explicit casting
                                              title: card["title"] as String,
                                              subtitle:
                                                  card["subtitle"] as String,
                                              bgColor: Colors.white,
                                              textColor: Colors.black,
                                              icon: card["icon"] as IconData,
                                              iconColor:
                                                  card["iconColor"] as Color,
                                            ),
                                          ),
                                      ],
                                    ),

                                    /*  GridView.builder(
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
                                    ),*/
                                    const SizedBox(height: 20),
                                    ActivityScreenContent(),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ملخص الطلبات",
                                          style: GoogleFonts.balooBhaijaan2(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // Action for "عرض الكل"
                                          },
                                          child: Text(
                                            "عرض الكل",
                                            style: GoogleFonts.balooBhaijaan2(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colorss.mainColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    LeaveCard(
                                      requestType: "إجازة",
                                      requestTitle: "إجازة - 15 Apr 2023",
                                      status: "مقبول",
                                      details: {
                                        'detail1Label': "عدد أيام الإجازة",
                                        'detail1Value': "3 أيام",
                                        'detail2Label': "نوع الإجازة",
                                        'detail2Value': "اعتيادي",
                                        'approvedBy': "البوب",
                                      },
                                    ),
                                    LeaveCard(
                                      requestType: "سلفة",
                                      requestTitle: "سلفة - 5000 جنيه",
                                      status: "مرفوض",
                                      details: {
                                        'detail1Label': "طريقة الدفع",
                                        'detail1Value': "قسط",
                                        'detail2Label': "الرصيد بعد السلفة",
                                        'detail2Value': "2000 جنيه",
                                        'approvedBy': "السيسي",
                                      },
                                    ),
                                    LeaveCard(
                                      requestType: "إذن خروج",
                                      requestTitle: "إذن خروج - 5 May 2023",
                                      status: "المراجعة",
                                      details: {
                                        'detail1Label': "مدة العمل المتبقية",
                                        'detail1Value': "4 ساعات",
                                        'detail2Label': "الرصيد المتبقي",
                                        'detail2Value': "3 ساعات",
                                        'approvedBy': "",
                                      },
                                    ),
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
          /*   if (_isContainerVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 110,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to the AttendanceScreen when the container is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceScreen(),
                          ),
                        );

                        // Update the timestamp when the container is tapped
                        _updateTimestamp();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colorss.mainColor.withOpacity(0.93),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            " تسجيل الحضور ",
                            style: GoogleFonts.balooBhaijaan2(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isContainerVisible = false; // Hide the container
                          });

                          // Update the timestamp when the container is closed manually
                          _updateTimestamp();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
          // If not visible, return an empty widget
        ],
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
                  color: Colorss.mainColor,
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

class CurrentMonthStatistics extends StatelessWidget {
  const CurrentMonthStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "إحصائيات الشهر الحالي",
          style: GoogleFonts.balooBhaijaan2(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          "صفحة إحصائيات الشهر الحالي",
          style: GoogleFonts.balooBhaijaan2(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
