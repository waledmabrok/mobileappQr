import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ FieldsMachine/setup/MainColors.dart';
import '../../CustomNavbar/Drawer.dart';

class Main_Activities extends StatefulWidget {
  const Main_Activities({super.key});

  static const routeName = "/Main_Activity";

  @override
  State<Main_Activities> createState() => _Main_ActivitiesState();
}

final _advancedDrawerController = AdvancedDrawerController();

class _Main_ActivitiesState extends State<Main_Activities> {
  @override
  Widget build(BuildContext context) {
    int selectedMonth = DateTime.now().month;
    int selectedYear = DateTime.now().year;
    return CustomAdvancedDrawer(
      controller: _advancedDrawerController,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text(
            'سجل الانشطة',
            style: GoogleFonts.balooBhaijaan2(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: 25),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle:
              GoogleFonts.balooBhaijaan2(fontWeight: FontWeight.bold),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "اجازات - ${_getMonthName(selectedMonth)} $selectedYear",
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final DateTimeRange? picked =
                                await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDateRange: DateTimeRange(
                                start: DateTime(selectedYear, selectedMonth, 1),
                                end: DateTime(selectedYear, selectedMonth, 28),
                              ),
                            );

                            if (picked != null) {
                              setState(() {
                                selectedMonth = picked.start.month;
                                selectedYear = picked.start.year;
                              });
                            }
                          },
                          icon: Icon(Icons.calendar_today_outlined, size: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                  svgIconPath:
                      'assets/Customhome/break-coffee-pause-svgrepo-com.svg',
                ),
                const SizedBox(height: 10),
                _buildActivityItem(
                  icon: FontAwesomeIcons.clock,
                  title: "انهاء فترة الراحه ",
                  time: "1:00 مساء",
                  date: "17 أبريل 2023",
                  status: "في الموعد",
                  iconColor: Colorss.mainColor,
                  svgIconPath:
                      'assets/Customhome/break-coffee-pause-svgrepo-com.svg',
                ),
                const SizedBox(height: 10),
                _buildActivityItem(
                  icon: FontAwesomeIcons.rightFromBracket,
                  title: "تسجيل الانصراف",
                  time: "1:00 صباحًا",
                  date: "17 أبريل 2023",
                  status: "في الموعد",
                  iconColor: Colorss.mainColor,
                  svgIconPath: 'assets/Customhome/logout-svgrepo-com.svg',
                ),
                const SizedBox(height: 10),
                _buildActivityItem(
                  icon: FontAwesomeIcons.personArrowDownToLine,
                  title: "التواجد خارج مواعيد العمل",
                  time: "2 ساعه",
                  date: "17 أبريل 2023",
                  status: "في الموعد",
                  iconColor: Colorss.mainColor,
                  svgIconPath: 'assets/Customhome/calendar-svgrepo-com.svg',
                ),
                const SizedBox(height: 10),
                _buildActivityItem(
                  icon: FontAwesomeIcons.moneyBill,
                  title: "طلب سلفه",
                  time: "1500",
                  date: "17 أبريل 2023",
                  status: "فشلت",
                  iconColor: Colorss.mainColor,
                  svgIconPath: 'assets/Customhome/money-recive-svgrepo-com.svg',
                ),
                const SizedBox(height: 10),
                _buildActivityItem(
                  icon: FontAwesomeIcons.outdent,
                  title: "طلب اذن",
                  time: "10:00",
                  date: "17 أبريل 2023",
                  status: "فشلت",
                  iconColor: Colorss.mainColor,
                  svgIconPath: 'assets/Customhome/date-svgrepo-com.svg',
                ),
              ],
            ),
          ),
        ),
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
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: SvgPicture.asset(
                  svgIconPath,
                  colorFilter: ColorFilter.mode(
                    Colorss.mainColor,
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

String _getMonthName(int month) {
  List<String> months = [
    "يناير",
    "فبراير",
    "مارس",
    "أبريل",
    "مايو",
    "يونيو",
    "يوليو",
    "أغسطس",
    "سبتمبر",
    "أكتوبر",
    "نوفمبر",
    "ديسمبر"
  ];
  return months[month - 1];
}
