import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../ FieldsMachine/customCardinHome/MainCardInhome.dart';
import '../ FieldsMachine/setup/MainColors.dart';
import '../CustomNavbar/Drawer.dart';
import '../MainHome/CustomFilter.dart';

import '../Request permission/Requst-Permission_Main.dart';
import '../onboarding/Activities/Main_Activities.dart';

import '../onboarding/Request_money/Request_money_main.dart';
import '../onboarding/Requests_Main/Requests.dart';
import '../onboarding/Statistics/StatisticsMain.dart';

import '../onboarding/Summary/main_Summary.dart';

import '../onboarding/navgate.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'CustomMainHome/Leave.dart';

class AttendanceScreen5 extends StatefulWidget {
  const AttendanceScreen5({super.key});

  @override
  State<AttendanceScreen5> createState() => _AttendanceScreen5State();
}

final _advancedDrawerController = AdvancedDrawerController();
String userName = '';
String userProfilePicture = '';
String user_position = '';
bool _isContainerVisible = true;
bool isSelected = false;

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

    return CustomAdvancedDrawer(
      controller: _advancedDrawerController,
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  forceMaterialTransparency: true,
                  shadowColor: Colors.white,
                  forceElevated: false,
                  toolbarHeight: 80,
                  floating: true,
                  // snap: true,
                  backgroundColor: Colors.white,
                  elevation: 2,
                  flexibleSpace: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          bottom: 5, end: 20, start: 20, top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              InkWell(
                                overlayColor:
                                    WidgetStatePropertyAll(Colors.white),
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(index2: 3),
                                    ),
                                    (route) => false,
                                  );
                                },
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
                                          radius: 25,
                                          backgroundImage:
                                              NetworkImage(userProfilePicture),
                                        )
                                      : Icon(Icons.person, size: 35),
                                ),
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                // الوظيفة
                                Text(
                                  user_position,
                                  style: GoogleFonts.balooBhaijaan2(
                                    fontWeight: FontWeight.w400,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    /*  color: Colorss.Secondtext2,*/
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
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomNotificationWidget(
                            isSelected: isSelected,
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
                            isSelected: isSelected,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainSummary(),
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
                            isSelected: isSelected,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PermissionRequestMain(),
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
                            isSelected: isSelected,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Request_money_Main(),
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
                            isSelected: isSelected,
                            onTap: () {
                              _advancedDrawerController.showDrawer();
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 20, bottom: 10, start: 20, end: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "الحضور اليوم",
                                            style: GoogleFonts.balooBhaijaan2(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
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
                                                      const PieChartSample2(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shadowColor: Colors.transparent,
                                              overlayColor: Colors.white,
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 0),
                                            ),
                                            label: Text(
                                              "كل الاحصائيات",
                                              style: GoogleFonts.balooBhaijaan2(
                                                color: Colorss.mainColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
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
                                              "icon": FontAwesomeIcons.f,
                                              "iconColor": Colors.blue,
                                              "svg":
                                                  "assets/Customhome/login-svgrepo-com.svg",
                                            },
                                            {
                                              "data": "07:00 مساءً",
                                              "title": "الخروج",
                                              "subtitle": "الانصراف",
                                              "icon": FontAwesomeIcons
                                                  .rightFromBracket,
                                              "iconColor": Colors.green,
                                              "svg":
                                                  "assets/Customhome/logout-svgrepo-com.svg",
                                            },
                                            {
                                              "data": "00:30 دقيقة",
                                              "title": "وقت الراحة",
                                              "subtitle": "متوسط",
                                              "icon": FontAwesomeIcons.clock,
                                              "iconColor": Colors.orange,
                                              "svg":
                                                  "assets/Customhome/break-coffee-pause-svgrepo-com.svg",
                                            },
                                            {
                                              "data": "28 يومًا",
                                              "title": "عدد الأيام",
                                              "subtitle": "أيام العمل",
                                              "icon":
                                                  FontAwesomeIcons.calendarAlt,
                                              "iconColor": Colors.purple,
                                              "svg":
                                                  "assets/Calender/calendar-svgrepo-com.svg",
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
                                                bgColor: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                                textColor: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                icon: card["icon"] as IconData,
                                                iconColor:
                                                    card["iconColor"] as Color,
                                                svgIconPath:
                                                    (card["svg"] as String?) ??
                                                        "",
                                                // التأكد من أنها String
                                              ),
                                            ),
                                        ],
                                      ),
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RequestsMain(),
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
                                      LeaveCard(
                                        requestType: "إجازة",
                                        requestTitle: "إجازة - 15 Apr 2023",
                                        status: "مقبول",
                                        details: {
                                          'detail1Label': "عدد أيام ",
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
                                          'detail2Label': "الرصيد المتبقي",
                                          'detail2Value': "2000 جنيه",
                                          'approvedBy': "السيسي",
                                        },
                                      ),
                                      LeaveCard(
                                        requestType: "إذن خروج",
                                        requestTitle: "إذن خروج - 5 May 2023",
                                        status: "المراجعة",
                                        details: {
                                          'detail1Label': "المده المتبقية",
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

            // If not visible, return an empty widget
          ],
        ),
      ),
    );
  }
}

class ActivityScreenContent extends StatefulWidget {
  @override
  State<ActivityScreenContent> createState() => _ActivityScreenContentState();
}

class _ActivityScreenContentState extends State<ActivityScreenContent> {
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
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Main_Activities(),
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
          iconColor: Colorss.mainColor,
          svgIconPath: 'assets/Customhome/login-svgrepo-com.svg',
        ),
        const SizedBox(height: 10),
        _buildActivityItem(
          icon: FontAwesomeIcons.clock,
          title: "بدء الراحة",
          time: "12:30 مساءً",
          date: "17 أبريل 2023",
          status: "في الموعد",
          iconColor: Colorss.mainColor,
          svgIconPath: 'assets/Customhome/break-coffee-pause-svgrepo-com.svg',
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
    required String svgIconPath,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(15),
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
              child: /* Icon(
                icon,
                color: iconColor,
                size: 13,
              ),*/
                  Padding(
                padding: const EdgeInsets.all(6.0),
                child: SvgPicture.asset(
                  svgIconPath,
                  colorFilter: ColorFilter.mode(
                    Colorss.mainColor, // لون الأيقونة
                    BlendMode.srcIn,
                  ),
                  width: 20,
                  height: 20,
                ),
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
                      color: Theme.of(context).colorScheme.onPrimary,
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
                    color: Theme.of(context).colorScheme.onPrimary,
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
