import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ FieldsMachine/Custom in Calender/Day and week.dart';
import '../../ FieldsMachine/Custom in Calender/status.dart';
import '../../ FieldsMachine/setup/MainColors.dart';
import '../../home/homeTest.dart';
import '../navgate.dart';
import 'ColorCharts.dart';
import 'indictor.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  int totalWorkDays = 21;
  int attendedDays = 15;
  int totalLeaves = 3;
  int totalPermissions = 5;
  int totalDelays = 30;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  // بالدقائق
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "إحصائيات - ${_getMonthName(selectedMonth)} $selectedYear",
                      style: GoogleFonts.balooBhaijaan2(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final DateTimeRange? picked = await showDateRangePicker(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      StatCard(
                        title: 'الحضور',
                        value: '15/21',
                        borderColor: Colors.blue,
                        backgroundColor: Colors.blue[50]!,
                      ),
                      Spacer(),
                      StatCard(
                        title: 'الإجازات',
                        value: '15/21',
                        borderColor: Colors.green,
                        backgroundColor: Colors.green[50]!,
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      StatCard(
                        title: 'الإذونات',
                        value: '15/21',
                        borderColor: Colors.red,
                        backgroundColor: Colors.red[50]!,
                      ),
                      Spacer(),
                      StatCard(
                        title: 'التأخيرات',
                        value: '00:30',
                        borderColor: Colors.indigo,
                        backgroundColor: Colors.indigo[50]!,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.8,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, right: 8, left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              "50%",
                              style: GoogleFonts.balooBhaijaan2(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              "50%",
                              style: GoogleFonts.balooBhaijaan2(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              "50%",
                              style: GoogleFonts.balooBhaijaan2(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              "50%",
                              style: GoogleFonts.balooBhaijaan2(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "سجل - ${_getMonthName(selectedMonth)} $selectedYear",
                            style: GoogleFonts.balooBhaijaan2(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
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
                          /*  IconButton(
                        onPressed: () async {
                          final DateTimeRange? picked = await showDateRangePicker(
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
                      ),*/
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الانشطه - ${_getMonthName(selectedMonth)} $selectedYear",
                        style: GoogleFonts.balooBhaijaan2(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
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
                      */ /*  IconButton(
                            onPressed: () async {
                              final DateTimeRange? picked = await showDateRangePicker(
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
                          ),*/ /*
                    ],
                  ),*/
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActivityScreenContent(),
                  ),
                ],
              ),
            ),
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
            value: 50,
            title: '50%',
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
            value: 50,
            title: '50%',
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
            value: 50,
            title: '50%',
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
            value: 50,
            title: '50%',
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

  StatCard({
    required this.title,
    required this.value,
    required this.borderColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // أضف منطق التنقل إلى الصفحة المناسبة هنا
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(15),
          color: backgroundColor,
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
                style: GoogleFonts.balooBhaijaan2(
                    color: Colors.black,
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

    /*  List<Map<String, dynamic>> details = [
      {
        'label': ' الحضور',
        'value': clockIn,
        'icon': FontAwesomeIcons.clockFour
      },
      {
        'label': ' الانصراف',
        'value': clockOut,
        'icon': FontAwesomeIcons.clockRotateLeft
      },
      {
        'label': 'المدة الكلية',
        'value': totalHours,
        'icon': FontAwesomeIcons.clock
      },
    ];*/

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colorss.BorderColor)),
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
/*              SizedBox(
                  height: screenWidth *
                      0.03),*/ // تباعد بين الصف العلوي والعناصر الأخرى
              // الصف الأوسط: العناصر (الحضور والتفاصيل)
              /*   Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(
                        0xfff8f9fb,
                      ),
                      Colors.white,
                    ],
                    stops: [0.1667, 0.5756],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: screenWidth * 0.030),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: screenWidth * 0.03,
                    runSpacing: screenWidth * 0.03,
                    children: details.map((detail) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: AttendanceColumn(
                          clockIn: detail['value'],
                          label: detail['label'],
                          icon: detail['icon'],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),*/
              SizedBox(height: screenWidth * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
