import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ FieldsMachine/Custom in Calender/Attendet.dart';
import '../ FieldsMachine/Custom in Calender/Day and week.dart';
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
    selectedMonth = DateFormat('MMMM yyyy').format(selectedDate);
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
      _loadAttendanceData();
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
    bool isSwapEnabled = false;

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
                          isSwapEnabled = value;

                          if (isSwapEnabled) {
                            tempSelectedMonth = DateTime.now().month;
                            tempSelectedYear = DateTime.now().year;

                            selectedDate =
                                DateTime(tempSelectedYear, tempSelectedMonth);
                            _dateStreamController.add(selectedDate);

                            _loadAttendanceData();
                          }
                        });

                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            Navigator.of(context).pop();
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
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.grey.withOpacity(0.1),
                        ),
                        child: Text(
                          'إلغاء',
                          style: GoogleFonts.balooBhaijaan2(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _loadAttendanceData();
                          setState(() {
                            selectedDate =
                                DateTime(tempSelectedYear, tempSelectedMonth);

                            _dateStreamController.add(selectedDate);

                            attendanceData = AttendanceService()
                                .fetchAttendance(employeeId!,
                                    selectedDate.month, selectedDate.year);
                          });

                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colorss.mainColor,
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
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Month Navigation

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: PreferredSize(
                preferredSize: Size.fromHeight(40.0),
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
      child: Container(
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
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
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
          selectedColor: Colorss.mainColor,
          backgroundColor:
              isSelected ? Colors.lightBlue.shade100 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: isSelected ? Colors.lightBlue.shade100 : Colors.grey,
              width: 0.5,
            ),
          ),
          showCheckmark: false,
        ),
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
              ),
              SizedBox(height: screenWidth * 0.05),
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
