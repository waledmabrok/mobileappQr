import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ FieldsMachine/setup/MainColors.dart';
import '../../CustomNavbar/Drawer.dart';
import '../../CustomNavbar/customnav.dart';
import '../../home/CustomMainHome/Leave.dart';
import '../Requests_Main/Requests.dart';
import '../Statistics/StatisticsMain.dart';
import '../calender.dart';

class MainSummary extends StatefulWidget {
  const MainSummary({super.key});

  static const routeName = "/summary";

  @override
  State<MainSummary> createState() => _MainSummaryState();
}

final _advancedDrawerController = AdvancedDrawerController();

class _MainSummaryState extends State<MainSummary> {
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
            'الاجازات',
            style: GoogleFonts.balooBhaijaan2(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: 25),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle:
              GoogleFonts.balooBhaijaan2(fontWeight: FontWeight.bold),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 20, top: 20, bottom: 10),
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
                                    start: DateTime(
                                        selectedYear, selectedMonth, 1),
                                    end: DateTime(
                                        selectedYear, selectedMonth, 28),
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
                              icon:
                                  Icon(Icons.calendar_today_outlined, size: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  title: 'طلبات الاجازات',
                                  value: '05/10',
                                  borderColor: Colors.blue,
                                  backgroundColor: Colors.blue[50]!,
                                ),
                              ),
                              SizedBox(width: 10), // المسافة بين العناصر
                              Expanded(
                                child: StatCard(
                                  title: 'الاجازات الاعتياديه',
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
                                  title: 'الاجازات المرضية',
                                  value: '15/21',
                                  borderColor: Colors.red,
                                  backgroundColor: Colors.red[50]!,
                                ),
                              ),
                              SizedBox(width: 10), // المسافة بين العناصر
                              Expanded(
                                child: StatCard(
                                  title: 'الاجازات العارضة',
                                  value: '10/5 ',
                                  borderColor: Colors.indigo,
                                  backgroundColor: Colors.indigo[50]!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "اجازات - ${_getMonthName(selectedMonth)} $selectedYear",
                                style: GoogleFonts.balooBhaijaan2(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RequestsMain(selectedTab: "الاجازات"),
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
                              'detail1Label': "عدد أيام الإجازة",
                              'detail1Value': "3 أيام",
                              'detail2Label': "نوع الإجازة",
                              'detail2Value': "اعتيادي",
                              'approvedBy': "البوب",
                            },
                          ),
                          LeaveCard(
                            requestType: "إجازة",
                            requestTitle: "إجازة - 25 Apr 2023",
                            status: "مرفوض",
                            details: {
                              'detail1Label': "عدد أيام الإجازة",
                              'detail1Value': "3 أيام",
                              'detail2Label': "نوع الإجازة",
                              'detail2Value': "مرضيه",
                              'approvedBy': "البوب",
                            },
                          ),
                          SizedBox(
                            height: 80,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
