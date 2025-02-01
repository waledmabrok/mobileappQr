import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ FieldsMachine/Custom in Calender/Day and week.dart';
import '../../ FieldsMachine/Custom in Calender/status.dart';
import '../../ FieldsMachine/setup/MainColors.dart';
import '../../CustomNavbar/Drawer.dart';
import '../../CustomNavbar/customnav.dart';
import '../../home/homeTest.dart';
import '../navgate.dart';
import 'ColorCharts.dart';
import 'indictor.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  static const routeName = "/statistic";

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

final _advancedDrawerController = AdvancedDrawerController();

class PieChart2State extends State {
  int touchedIndex = -1;

  int totalWorkDays = 21;
  int attendedDays = 15;
  int totalLeaves = 3;
  int totalPermissions = 5;
  int totalDelays = 30;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return CustomAdvancedDrawer(
      controller: _advancedDrawerController,
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              Text(
                                "إحصائيات - ${_getMonthName(selectedMonth)} $selectedYear",
                                style: GoogleFonts.balooBhaijaan2(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              final DateTimeRange? picked =
                                  await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                initialDateRange: DateTimeRange(
                                  start:
                                      DateTime(selectedYear, selectedMonth, 1),
                                  end:
                                      DateTime(selectedYear, selectedMonth, 28),
                                ),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor:
                                          Colorss.mainColor, // اللون الأساسي
                                      hintColor: Colors.grey, // لون التلميحات
                                      colorScheme: ColorScheme.light(
                                        primary: Colorss.mainColor,
                                        // لون العنوان والأزرار
                                        onPrimary: Colors.white,
                                        // لون النص في الأزرار
                                        secondary: Colors.grey,
                                        // لون التحديد عند اختيار الأيام
                                        onSecondary: Colors.white,
                                        // لون النص عند التحديد
                                        surface: Colors.white,
                                        // لون الخلفية
                                        onSurface: Colors.black, // لون النصوص
                                      ),
                                      dialogBackgroundColor:
                                          Colors.white, // لون خلفية الحوار
                                    ),
                                    child: child!,
                                  );
                                },
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: StatCard(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                index2: 2,
                                                filter: 'الخروج المبكر',
                                              ),
                                            ),
                                          );
                                        },
                                        title: 'الحضور',
                                        value: '15/21',
                                        borderColor: Colors.blue,
                                        backgroundColor: Colors.blue[50]!,
                                      ),
                                    ),
                                    SizedBox(width: 10), // المسافة بين العناصر
                                    Expanded(
                                      child: StatCard(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                index2: 2,
                                                filter: 'الاجازات',
                                              ),
                                            ),
                                          );
                                        },
                                        title: 'الإجازات',
                                        value: '15/21',
                                        borderColor: Colors.green,
                                        backgroundColor: Colors.green[50]!,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: StatCard(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                index2: 2,
                                                filter: 'الاذونات',
                                              ),
                                            ),
                                          );
                                        },
                                        title: 'الإذونات',
                                        value: '15/21',
                                        borderColor: Colors.red,
                                        backgroundColor: Colors.red[50]!,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: StatCard(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                index2: 2,
                                                filter: 'التاخيرات',
                                              ),
                                            ),
                                          );
                                        },
                                        title: 'التأخيرات',
                                        value: '00:30',
                                        borderColor: Colors.indigo,
                                        backgroundColor: Colors.indigo[50]!,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          AspectRatio(
                            aspectRatio: 2,
                            child: Row(
                              children: <Widget>[
                                const SizedBox(
                                  height: 18,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, right: 8, left: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Indicator(
                                            color: AppColors.contentColorBlue,
                                            text: 'الحضور',
                                            isSquare: true,
                                          ),
                                          const SizedBox(
                                            width: 44,
                                          ),
                                          Text(
                                            "25%",
                                            style: GoogleFonts.balooBhaijaan2(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Indicator(
                                            color: Colors.green,
                                            text: 'الاجازات',
                                            isSquare: true,
                                          ),
                                          const SizedBox(
                                            width: 39,
                                          ),
                                          Text(
                                            "25%",
                                            style: GoogleFonts.balooBhaijaan2(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Indicator(
                                            color: Colors.red,
                                            text: 'الاذونات',
                                            isSquare: true,
                                          ),
                                          const SizedBox(
                                            width: 37,
                                          ),
                                          Text(
                                            "25%",
                                            style: GoogleFonts.balooBhaijaan2(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Indicator(
                                            color: Colors.indigo,
                                            text: 'التاخيرات',
                                            isSquare: true,
                                          ),
                                          const SizedBox(
                                            width: 32,
                                          ),
                                          Text(
                                            "25%",
                                            style: GoogleFonts.balooBhaijaan2(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: PieChart(
                                      PieChartData(
                                        pieTouchData: PieTouchData(
                                          touchCallback: (FlTouchEvent event,
                                              pieTouchResponse) {
                                            setState(() {
                                              if (!event
                                                      .isInterestedForInteractions ||
                                                  pieTouchResponse == null ||
                                                  pieTouchResponse
                                                          .touchedSection ==
                                                      null) {
                                                touchedIndex = -1;
                                                return;
                                              }
                                              touchedIndex = pieTouchResponse
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                            });
                                          },
                                        ),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 30,
                                        sections: showingSections(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 28,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "سجل - ${_getMonthName(selectedMonth)} $selectedYear",
                                        style: GoogleFonts.balooBhaijaan2(
                                          fontSize: 18,
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
                                              builder: (context) => HomeScreen(
                                                index2: 2,
                                                filter: "All",
                                              ),
                                            ),
                                          );
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
                                ),
                                AttendanceCard3(
                                  day: '1',
                                  weekday: 'Thursday',
                                  status: 'Absent',
                                ),
                                AttendanceCard3(
                                  day: '2',
                                  weekday: 'Wednesday',
                                  status: 'Under Time',
                                ),
                                AttendanceCard3(
                                  day: '3',
                                  weekday: 'Thursday',
                                  status: 'Under Time',
                                ),
                                AttendanceCard3(
                                  day: '4',
                                  weekday: 'Friday',
                                  status: 'Absent',
                                ),
                                AttendanceCard3(
                                  day: '5',
                                  weekday: 'Saturday',
                                  status: 'Under Time',
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ActivityScreenContent(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                  )
                ],
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: SizedBox(
                height: 70,
                child: CustomBottomNavBar(
                  selectedIndex: 4,
                  onItemTapped: (p0) {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///=====================================
  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: 25,
            title: '25%',
            radius: radius,
            titleStyle: GoogleFonts.balooBhaijaan2(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: 25,
            title: '25%',
            radius: radius,
            titleStyle: GoogleFonts.balooBhaijaan2(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.indigo,
            value: 25,
            title: '25%',
            radius: radius,
            titleStyle: GoogleFonts.balooBhaijaan2(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: 25,
            title: '25%',
            radius: radius,
            titleStyle: GoogleFonts.balooBhaijaan2(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color borderColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  StatCard({
    required this.title,
    required this.value,
    required this.borderColor,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(15),
          color: backgroundColor.withOpacity(0.2),
        ),
        width: 153,
        height: 90,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.balooBhaijaan2(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                value,
                style: GoogleFonts.balooBhaijaan2(
                    color: borderColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
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

class AttendanceCard3 extends StatelessWidget {
  final String day;
  final String weekday;

  // final String clockIn;
  // final String clockOut;
  // final String totalHours;
  final String status;

  const AttendanceCard3({
    super.key,
    required this.day,
    required this.weekday,
    //  required this.clockIn,
    // required this.clockOut,
    //  required this.totalHours,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.inverseSurface,
            )),
        child: Padding(
          padding: EdgeInsets.only(
              top: screenWidth * 0.037,
              right: screenWidth * 0.035,
              left: screenWidth * 0.035),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusColumn(status: status),
                  DayAndWeekdayColumn(day: day, weekday: weekday),
                ],
              ),
              SizedBox(height: screenWidth * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
