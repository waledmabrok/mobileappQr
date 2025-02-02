import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ FieldsMachine/setup/MainColors.dart';
import '../../CustomNavbar/Drawer.dart';
import '../../CustomNavbar/customnav.dart';
import '../../home/CustomMainHome/Leave.dart';
import '../Requests_Main/Requests.dart';
import '../Statistics/StatisticsMain.dart';

class Request_money_Main extends StatefulWidget {
  const Request_money_Main({super.key});

  static const routeName = '/requst_money';

  @override
  State<Request_money_Main> createState() => _Request_money_MainState();
}

final _advancedDrawerController = AdvancedDrawerController();

class _Request_money_MainState extends State<Request_money_Main> {
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
            'السلف',
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
                              "السلف - ${_getMonthName(selectedMonth)} $selectedYear",
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
                                  helpText: '',
                                  keyboardType: TextInputType.text,
                                  //  useRootNavigator: false,
                                  //barrierDismissible: false,
                                  context: context,
                                  locale: const Locale('ar', 'AE'),

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
                                      data: Theme.of(context),
                                      child: child!,
                                    );
                                  },
                                  initialEntryMode:
                                      DatePickerEntryMode.calendar,
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
                                  title: 'كل السلف',
                                  value: '05/10',
                                  borderColor: Colors.blue,
                                  backgroundColor: Colors.blue[50]!,
                                ),
                              ),
                              SizedBox(width: 10), // المسافة بين العناصر
                              Expanded(
                                child: StatCard(
                                  title: 'سلف كاش',
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
                                  title: 'سلف قسط',
                                  value: '15/21',
                                  borderColor: Colors.red,
                                  backgroundColor: Colors.red[50]!,
                                ),
                              ),
                              SizedBox(width: 10), // المسافة بين العناصر
                              Expanded(
                                child: StatCard(
                                  title: 'سلف منتهيه',
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
                                "سلف - ${_getMonthName(selectedMonth)} $selectedYear",
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
                                          RequestsMain(selectedTab: "السلف"),
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
                            requestType: "سلفه",
                            requestTitle: "سلفه - 15 Apr 2024",
                            status: "مقبول",
                            details: {
                              'detail1Label': "طريقه الدفع",
                              'detail1Value': "قسط",
                              'detail2Label': "الرصيد بعد السلفه",
                              'detail2Value': "2000 جنيه",
                              'approvedBy': "البوب",
                            },
                          ),
                          LeaveCard(
                            requestType: "سلف كاش",
                            requestTitle: "سلفة - 5000 جنيه",
                            status: "المراجعة",
                            details: {
                              'detail1Label': "طريقة الدفع",
                              'detail1Value': "كاش",
                              'detail2Label': "الرصيد بعد السلفة",
                              'detail2Value': "2000 جنيه",
                              'approvedBy': "",
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
