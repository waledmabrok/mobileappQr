import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ FieldsMachine/setup/MainColors.dart';
import '../../home/CustomMainHome/Leave.dart';
import '../CustomNavbar/Drawer.dart';
import '../CustomNavbar/customnav.dart';
import '../onboarding/Requests_Main/Requests.dart';
import '../onboarding/Statistics/StatisticsMain.dart';
import '../onboarding/calender.dart';

class PermissionRequestMain extends StatefulWidget {
  const PermissionRequestMain({super.key});

  static const routeName = "/permission";

  @override
  State<PermissionRequestMain> createState() => _PermissionRequestMainState();
}

class _PermissionRequestMainState extends State<PermissionRequestMain> {
//customDrawer
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    int selectedMonth = DateTime.now().month;
    int selectedYear = DateTime.now().year;
//custom drawer============
    return CustomAdvancedDrawer(
      controller: _advancedDrawerController,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text(
            'الاذونات',
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
                              "اذونات - ${_getMonthName(selectedMonth)} $selectedYear",
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
                                  title: 'كل الاذونات',
                                  value: '05/10',
                                  borderColor: Colors.blue,
                                  backgroundColor: Colors.blue[50]!,
                                ),
                              ),
                              SizedBox(width: 10), // المسافة بين العناصر
                              Expanded(
                                child: StatCard(
                                  title: 'مرواح مبكر',
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
                                  title: 'نص يوم',
                                  value: '15/21',
                                  borderColor: Colors.red,
                                  backgroundColor: Colors.red[50]!,
                                ),
                              ),
                              SizedBox(width: 10), // المسافة بين العناصر
                              Expanded(
                                child: StatCard(
                                  title: 'اذن تاخير',
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
                                "طلبات - ${_getMonthName(selectedMonth)} $selectedYear",
                                style: GoogleFonts.balooBhaijaan2(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // الانتقال إلى صفحة الإحصائيات
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RequestsMain(selectedTab: "الاذونات"),
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
                            requestType: "اذن",
                            requestTitle: "اذن - 15 Apr 2024",
                            status: "مقبول",
                            details: {
                              'detail1Label': "يوم الاذن",
                              'detail1Value': "15/4/2024",
                              'detail2Label': "نوع الاذن",
                              'detail2Value': "مرواح مبكر",
                              'approvedBy': "البوب",
                            },
                          ),
                          LeaveCard(
                            requestType: "اذن",
                            requestTitle: "اذن - 3 Apr 2024",
                            status: "مرفوض",
                            details: {
                              'detail1Label': "يوم الاذن",
                              'detail1Value': "3/4/2024",
                              'detail2Label': "نوع الاذن",
                              'detail2Value': "نص يوم",
                              'approvedBy': "البوب",
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    )
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
