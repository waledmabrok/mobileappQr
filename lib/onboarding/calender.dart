import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ FieldsMachine/Custom in Calender/Attendet.dart';
import '../ FieldsMachine/Custom in Calender/Day and week.dart';
import '../ FieldsMachine/Custom in Calender/line.dart';
import '../ FieldsMachine/Custom in Calender/status.dart';
import '../ FieldsMachine/Custom in Calender/Sketlon.dart';
import '../ FieldsMachine/setup/MainColors.dart';
import '../CustomApi/Api calender/api calender.dart';
import 'package:lottie/lottie.dart';
import '../CustomApi/Api calender/modelcalender.dart';

class AttendancePage extends StatefulWidget {
  final String filter;
  late List<dynamic> attendanceData;

  AttendancePage({this.filter = 'All'});

  //const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String selectedMonth = ''; // To store the formatted current month
  int selectedYear = 0;
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();
  late Future<List<Attendance>> attendanceData; // Future for API data
  bool isFullDaySelected = false;
  String currentFilter = 'All';

  bool isAll = true;
  bool isEarlyLeaveSelected = false;
  bool isAbsentSelected = false;
  int? employeeId;
  StreamController<DateTime> _dateStreamController =
      StreamController<DateTime>.broadcast();

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
    selectedMonth = DateFormat('MMMM yyyy')
        .format(selectedDate); // تعيين الشهر والسنة بشكل صحيح
    selectedYear = selectedDate.year;
    _getUserId();
    attendanceData = Future.value([]);
    // Delay applying the initial filter to give data time to load
    Future.delayed(Duration(milliseconds: 500), () {
      currentFilter = widget.filter.isEmpty ? 'All' : widget.filter;
      _applyInitialFilter();
    });
  }

  void _applyInitialFilter() {
    _updateSelectedFilter(filter: widget.filter);
    setState(() {
      _loadAttendanceData(); // تأكد من أن البيانات يتم تحميلها بعد تغيير الفلتر
    });
  }

  void _updateSelectedFilter({required String filter}) {
    setState(() {
      isAll = filter == 'All' || filter == 'كل الايام';
      isFullDaySelected = filter == 'كل الايام';
      isEarlyLeaveSelected = filter == 'الخروج المبكر';
      isAbsentSelected = filter == 'الغياب';
    });
  }

  // Function to retrieve user ID from SharedPreferences
  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('user_id');

    if (storedUserId != null) {
      setState(() {
        employeeId = int.parse(
            storedUserId); // Assuming userId is a string, convert it to int
      });
      _loadAttendanceData();
    } else {
      // Handle case when user ID is not found
      print('User ID not found');
    }
  }

  void _loadAttendanceData() {
    if (employeeId != null) {
      setState(() {
        attendanceData = AttendanceService().fetchAttendance(
            employeeId!, selectedDate.month, selectedDate.year);
      });
    } else {
      print('Employee ID is null');
    }
  }

  void _previousMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
      selectedYear = selectedDate.year;
      selectedMonth = DateFormat('MMMM yyyy').format(selectedDate);
      _loadAttendanceData();
    });
  }

  void _nextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
      selectedYear = selectedDate.year;
      selectedMonth = DateFormat('MMMM yyyy').format(selectedDate);
      _loadAttendanceData();
    });
  }

  Future<void> _selectMonth(BuildContext context) async {
    int tempSelectedMonth = selectedDate.month;
    int tempSelectedYear = selectedDate.year;
    bool isSwapEnabled = false; // حالة الزر

    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'اختر الشهر والسنة',
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'الشهر الحالي: الشهر ${tempSelectedMonth} - السنة ${tempSelectedYear}',
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    Switch(
                      activeColor: Colorss.mainColor,
                      value: isSwapEnabled,
                      onChanged: (value) {
                        setState(() {
                          // تحديث قيمة السويتش
                          isSwapEnabled = value;

                          // إذا كان السويتش مفعل، نقوم بتحديث التاريخ إلى الشهر والسنة الحاليين
                          if (isSwapEnabled) {
                            tempSelectedMonth = DateTime.now().month;
                            tempSelectedYear = DateTime.now().year;

                            // بث التاريخ الجديد
                            selectedDate =
                                DateTime(tempSelectedYear, tempSelectedMonth);
                            _dateStreamController.add(selectedDate);

                            // تحديث البيانات
                            _loadAttendanceData();
                          }
                        });

                        // تأخير إغلاق النافذة بعد 2 ثانية (مناسب لتحديث البيانات)
                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            Navigator.of(context)
                                .pop(); // إغلاق النافذة فقط إذا كانت ما زالت مفتوحة
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      // اختيار الشهر
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 40,
                          scrollController: FixedExtentScrollController(
                              initialItem: tempSelectedMonth - 1),
                          onSelectedItemChanged: (index) {
                            tempSelectedMonth = index + 1;
                          },
                          children: List.generate(12, (index) {
                            return Center(
                              child: Text(
                                'الشهر ${index + 1}',
                                style: GoogleFonts.balooBhaijaan2(fontSize: 16),
                              ),
                            );
                          }),
                        ),
                      ),
                      // اختيار السنة
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 40,
                          scrollController: FixedExtentScrollController(
                            initialItem:
                                tempSelectedYear - (DateTime.now().year - 15),
                          ),
                          onSelectedItemChanged: (index) {
                            tempSelectedYear = DateTime.now().year - 15 + index;
                          },
                          children: List.generate(30, (index) {
                            int year = DateTime.now().year - 15 + index;
                            return Center(
                              child: Text(
                                'السنة $year',
                                style: GoogleFonts.balooBhaijaan2(fontSize: 16),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // زر الإلغاء
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // الشكل الدائري
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.grey
                              .withOpacity(0.1), // خلفية مع شفافية خفيفة
                        ),
                        child: Text(
                          'إلغاء',
                          style: GoogleFonts.balooBhaijaan2(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // المسافة بين الأزرار
                    // زر التأكيد
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _loadAttendanceData();
                          setState(() {
                            // تحديث التاريخ المختار
                            selectedDate =
                                DateTime(tempSelectedYear, tempSelectedMonth);

                            // بث التاريخ الجديد
                            _dateStreamController.add(selectedDate);

                            // تحديث البيانات
                            attendanceData = AttendanceService()
                                .fetchAttendance(employeeId!,
                                    selectedDate.month, selectedDate.year);
                          });

                          // إغلاق النافذة
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // الشكل الدائري
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor:
                              Colorss.mainColor, // خلفية مع شفافية خفيفة
                        ),
                        child: Text(
                          'تاكيد',
                          style: GoogleFonts.balooBhaijaan2(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Stream<List<Attendance>> get _attendanceStream {
    return Stream.fromFuture(
      AttendanceService()
          .fetchAttendance(employeeId!, selectedDate.month, selectedDate.year),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 20,
        // Adjust toolbar height as needed
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 0,
        // Optional to remove shadow
        /* title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              */ /*  IconButton(
                onPressed: _previousMonth,
                icon: const Icon(
                  Icons.chevron_left,
                  size: 35,
                  color: Colors.black,
                ),
              ),*/ /*
             */ /* SizedBox(
                width: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  */ /**/ /*   GestureDetector(
                    //(
                    onTap: () => _selectMonth(context),
                    child: Text(
                      '$selectedMonth',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),*/ /**/ /*
                  // التاريخ بجانب الشهر

                  const SizedBox(width: 8),
                  GestureDetector(
                    //(
                    onTap: () => _selectMonth(context),
                    child: Icon(
                      Icons.calendar_today_outlined,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                  // رمز التاريخ
                ],
              ),*/ /*
              */ /*   SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(
                  Icons.chevron_right,
                  size: 35,
                  color: Colors.black,
                ),
              ),*/ /*
            ],
          ),
        ),*/
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Month Navigation

            PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Container(
                width: double.infinity,
                color: Colors.white, // Set the background color to white
                child: Column(
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilterChipWidget(
                          label: 'كل الايام',
                          isSelected: isAll,
                          onSelected: () {
                            _updateSelectedFilter(filter: 'All');
                            setState(() {
                              isAll = true;
                              isFullDaySelected = true;
                              isEarlyLeaveSelected = false;
                              isAbsentSelected = false;
                            });
                          },
                          required: false,
                        ),
                        /* FilterChipWidget(
                          label: 'اليوم كامل',
                          isSelected: isFullDaySelected,
                          onSelected: () {
                            setState(() {
                              isAll = false;
                              isFullDaySelected = true;
                              isEarlyLeaveSelected = false;
                              isAbsentSelected = false;
                            });
                          },
                        ),*/
                        FilterChipWidget(
                          label: 'الخروج مبكرا',
                          isSelected: isEarlyLeaveSelected,
                          onSelected: () {
                            _updateSelectedFilter(filter: "الخروج المبكر");
                            setState(() {
                              isAll = false;
                              isFullDaySelected = false;
                              isEarlyLeaveSelected = true;
                              isAbsentSelected = false;
                            });
                          },
                          required: false,
                        ),
                        FilterChipWidget(
                          label: 'الغياب',
                          isSelected: isAbsentSelected,
                          onSelected: () {
                            _updateSelectedFilter(filter: "الغياب");
                            setState(() {
                              isAll = false;
                              isFullDaySelected = false;
                              isEarlyLeaveSelected = false;
                              isAbsentSelected = true;
                            });
                          },
                          required: false,
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: GestureDetector(
                            //(
                            onTap: () => _selectMonth(context),
                            child: Icon(
                              Icons.calendar_today_outlined,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),

            // Attendance Data
            StreamBuilder<List<Attendance>>(
              stream: _attendanceStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SingleChildScrollView(child: SkeletonCard());
                } else if (snapshot.hasError) {
                  return Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    // تحديد عرض الشاشة بالكامل
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Calender/Menstrual calendar.gif',
                          width: double.infinity, // تحديد عرض الصورة بالكامل
                          fit: BoxFit
                              .contain, // يضمن أن الصورة تأخذ الحجم المناسب داخل الحاوية
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No attendance records found'));
                } else {
                  List<Attendance> filteredData = snapshot.data!;

                  // Apply filters to the data (Full Day, Late, etc.)
                  if (isAll) {
                    filteredData = snapshot.data!;
                  }
                  if (isEarlyLeaveSelected) {
                    filteredData = filteredData
                        .where(
                            (attendance) => attendance.status == 'Under Time')
                        .toList();
                  }
                  if (isAbsentSelected) {
                    filteredData = filteredData
                        .where((attendance) => attendance.status == 'Absent')
                        .toList();
                  }

                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final data = filteredData[index];
                        return AttendanceCard(
                          day: data.date.day,
                          weekday: data.date.dayName,
                          // You might want to improve this to display day names
                          clockIn: data.checkInTime,
                          clockOut: data.checkOutTime,
                          totalHours: data.totalTime,
                          status: data.status,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool required;
  final VoidCallback onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.required,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
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
                    'assets/SvgNotifi/Animation - 1736014220484.json',
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
                color: isSelected
                    ? Colors.blue
                    : (required
                        ? Colors.black
                        : Colors
                            .grey), // تغيير اللون هنا بناءً على `isSelected` و `required`
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 0.5,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final String day;
  final String weekday;
  final String clockIn;
  final String clockOut;
  final String totalHours;
  final String status;

  const AttendanceCard({
    super.key,
    required this.day,
    required this.weekday,
    required this.clockIn,
    required this.clockOut,
    required this.totalHours,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<Map<String, dynamic>> details = [
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
    ];

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
              SizedBox(
                  height: screenWidth *
                      0.03), // تباعد بين الصف العلوي والعناصر الأخرى
              // الصف الأوسط: العناصر (الحضور والتفاصيل)
              Container(
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
                    spacing: screenWidth * 0.03, // المسافة الأفقية بين العناصر
                    runSpacing:
                        screenWidth * 0.03, // المسافة العمودية بين العناصر
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
              ),
              SizedBox(height: screenWidth * 0.05), // تباعد سفلي
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingImage extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;

  LoadingImage({
    required this.imagePath,
    this.height = double.infinity,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Colors.white,
      child: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
