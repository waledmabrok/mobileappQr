import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ FieldsMachine/setup/MainColors.dart';
import '../../../CustomNavbar/Drawer.dart';
import '../../../MainHome/CustomFilter.dart';
import '../../calender.dart';
import '../../navgate.dart';
import 'CustomWallet/CustomAlltransaction.dart';

class transactionAll extends StatefulWidget {
  const transactionAll({super.key});

  static const routeName = "/all_transaction";

  @override
  State<transactionAll> createState() => _transactionAllState();
}

final _advancedDrawerController = AdvancedDrawerController();

class _transactionAllState extends State<transactionAll> {
  String userName = '';
  String userEmail = '';
  String userProfilePicture = '';
  String position = '';
  String enteredNumber = '';
  bool isAll = true;
  bool isEarlyLeaveSelected = false;
  bool Regularholidays = false;
  bool isAbsentSelected = false;
  bool Casualleave = false;
  bool Permissions = false;
  bool SickLeave = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'غير معروف';
      userProfilePicture = prefs.getString('user_profile_picture') ?? '';
      userEmail = prefs.getString('user_email') ?? '';
      position = prefs.getString('user_position') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedMonth = DateTime.now().month;
    int selectedYear = DateTime.now().year;
    return CustomAdvancedDrawer(
      controller: _advancedDrawerController,
      child: Scaffold(
        //  backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 35.0, left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colorss.BorderColor)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back_ios_new),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
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
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                " ${userName}  ",
                                style: GoogleFonts.balooBhaijaan2(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 1),
                            ],
                          ),
                          Spacer(),
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
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.notification_important_outlined,
                                    size: 18,
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilterChipWidget(
                        label: 'الكل',
                        isSelected: isAll,
                        onSelected: () {
                          //  _updateSelectedFilter(filter: "الاجازات");
                          setState(() {
                            isAll = true;
                            //   isFullDaySelected = false;
                            isEarlyLeaveSelected = false;
                            isAbsentSelected = false;
                            Permissions = false;
                            Casualleave = false;
                            Regularholidays = false;
                            SickLeave = false;
                          });
                        },
                        required: false,
                      ),
                      FilterChipWidget(
                        label: ' القبض',
                        isSelected: Permissions,
                        onSelected: () {
                          //  _updateSelectedFilter(filter: " الاذونات");
                          setState(() {
                            isAll = false;
                            //   isFullDaySelected = false;
                            isEarlyLeaveSelected = false;
                            isAbsentSelected = false;
                            Permissions = true;
                            Casualleave = false;
                            Regularholidays = false;
                            SickLeave = false;
                          });
                        },
                        required: false,
                      ),
                      FilterChipWidget(
                        label: ' الخصومات',
                        isSelected: isEarlyLeaveSelected,
                        onSelected: () {
                          //  _updateSelectedFilter(filter: " الاذونات");
                          setState(() {
                            isAll = false;
                            //   isFullDaySelected = false;
                            isEarlyLeaveSelected = true;
                            isAbsentSelected = false;
                            Permissions = false;
                            Casualleave = false;
                            Regularholidays = false;
                            SickLeave = false;
                          });
                        },
                        required: false,
                      ),
                      FilterChipWidget(
                        label: ' السلف ',
                        isSelected: isAbsentSelected,
                        onSelected: () {
                          //  _updateSelectedFilter(filter: " الاذونات");
                          setState(() {
                            isAll = false;
                            //   isFullDaySelected = false;
                            isEarlyLeaveSelected = false;
                            isAbsentSelected = true;
                            Permissions = false;
                            Casualleave = false;
                            Regularholidays = false;
                            SickLeave = false;
                          });
                        },
                        required: false,
                      ),
                      FilterChipWidget(
                        label: ' قسط',
                        isSelected: SickLeave,
                        onSelected: () {
                          //  _updateSelectedFilter(filter: " الاذونات");
                          setState(() {
                            isAll = false;
                            //   isFullDaySelected = false;
                            isEarlyLeaveSelected = false;
                            isAbsentSelected = false;
                            Permissions = false;
                            Casualleave = false;
                            Regularholidays = false;
                            SickLeave = true;
                          });
                        },
                        required: false,
                      ),
                      FilterChipWidget(
                        label: ' مكافاه',
                        isSelected: Casualleave,
                        onSelected: () {
                          //  _updateSelectedFilter(filter: " الاذونات");
                          setState(() {
                            isAll = false;
                            //   isFullDaySelected = false;
                            isEarlyLeaveSelected = false;
                            isAbsentSelected = false;
                            Permissions = false;
                            Casualleave = true;
                            Regularholidays = false;
                            SickLeave = false;
                          });
                        },
                        required: false,
                      ),
                      FilterChipWidget(
                        label: ' overtime',
                        isSelected: Regularholidays,
                        onSelected: () {
                          //  _updateSelectedFilter(filter: " الاذونات");
                          setState(() {
                            isAll = false;
                            //   isFullDaySelected = false;
                            isEarlyLeaveSelected = false;
                            isAbsentSelected = false;
                            Permissions = false;
                            Casualleave = false;
                            Regularholidays = true;
                            SickLeave = false;
                          });
                        },
                        required: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المعاملات',
                            style: GoogleFonts.balooBhaijaan2(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
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
                                  start:
                                      DateTime(selectedYear, selectedMonth, 1),
                                  end:
                                      DateTime(selectedYear, selectedMonth, 28),
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
                    SizedBox(
                      height: 10,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/broww.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "طلب سلفه",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "فشلت",
                      iconColor: Colorss.BorderColor,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/wither.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "تاريخ الرواتب",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BorderColor,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/mins.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "الخصومات",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BorderColor,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/broww.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "طلب سلفه",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "فشلت",
                      iconColor: Colorss.BorderColor,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/mins.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "الخصومات",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BorderColor,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/broww.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "طلب سلفه",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "فشلت",
                      iconColor: Colorss.BorderColor,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/wither.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "تاريخ الرواتب",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BorderColor,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/mins.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "الخصومات",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BorderColor,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/wither.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "تاريخ الرواتب",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BorderColor,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/mins.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "الخصومات",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "فشلت",
                      iconColor: Colorss.BorderColor,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/wither.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "تاريخ الرواتب",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BorderColor,
                    ),
                    ActivityItem(
                      imagePath: 'assets/SvgProfile/mins.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "الخصومات",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BorderColor,
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipWidgetTrans extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool required;
  final VoidCallback onSelected;
  final bool? isPositive; // تحديد إذا كانت الفئة موجبة أو سالبة

  const FilterChipWidgetTrans({
    super.key,
    required this.label,
    required this.isSelected,
    required this.required,
    required this.onSelected,
    this.isPositive, // إضافة المتغير هنا
  });

  @override
  Widget build(BuildContext context) {
    // استخدام قيمة افتراضية في حال كانت isPositive فارغة
    bool isPos = isPositive ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (required)
              Stack(
                children: [
                  Lottie.asset(
                    'assets/SvgNotifi/Animation-1736014220484.json',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 6.0,
                    top: 6.0,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            Text(
              label,
              style: GoogleFonts.balooBhaijaan2(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isPos // تحقق من إذا كانت الفئة موجبة أو سالبة
                        ? Colors.green // اللون الأخضر للفئات الموجبة
                        : Colors.red, // اللون الأحمر للفئات السالبة
              ),
            ),
            if (isPos) Icon(Icons.add, color: Colors.green), // إضافة أيقونة "+"
            if (!isPos)
              Icon(Icons.remove, color: Colors.red), // إضافة أيقونة "-"
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor:
            isPos ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7),
        backgroundColor: isSelected
            ? (isPos
                ? Colors.green.withOpacity(0.3)
                : Colors.red.withOpacity(0.3))
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: isSelected
                ? (isPos
                    ? Colors.green.withOpacity(0.3)
                    : Colors.red.withOpacity(0.3))
                : Colors.grey,
            width: 0.5,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}
