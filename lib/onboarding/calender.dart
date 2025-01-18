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
  bool Regularholidays = false;
  bool isAbsentSelected = false;
  bool Casualleave = false;
  bool Permissions = false;
  bool SickLeave = false;
  int? employeeId;
  StreamController<DateTime> _dateStreamController =
      StreamController<DateTime>.broadcast();

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
    selectedDate = DateTime(0);
/*    selectedMonth = DateFormat('MMMM yyyy').format(selectedDate);
    selectedYear = selectedDate.year;*/
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
    int tempSelectedMonth =
        selectedDate.month == 0 ? DateTime.now().month : selectedDate.month;
    int tempSelectedYear =
        selectedDate.year == 0 ? DateTime.now().year : selectedDate.year;

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
                            // عند التبديل إلى الوضع النشط، تعيين التاريخ الحالي
                            int tempSelectedMonth = selectedDate.month == 0
                                ? DateTime.now().month
                                : selectedDate.month;
                            int tempSelectedYear = selectedDate.year == 0
                                ? DateTime.now().year
                                : selectedDate.year;

                            selectedDate = DateTime(0);
                          } else {
                            // عند إيقاف التبديل، تعيين التاريخ إلى فارغ
                            selectedDate = DateTime(
                                0); // أو يمكن تعيينه إلى null إذا كنت تفضل
                          }

                          _dateStreamController.add(selectedDate);
                          _loadAttendanceData();
                        });

                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                    )
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

  void showDayDetails(
      BuildContext context, List<Map<String, String>> dayRecords) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "سجل الحضور",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              SizedBox(height: 8),
              // عرض بيانات اليوم داخل ListView
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: dayRecords.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    final record = dayRecords[index];
                    return ListTile(
                      leading: Icon(Icons.access_time, color: Colors.blue),
                      title: Text(record['time'] ?? "N/A"),
                      subtitle: Text(record['status'] ?? "N/A"),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Container(
                child: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          'سجل',
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          selectedDate.month != 0 && selectedDate.year != 0
                              ? '${selectedDate.month} - ${selectedDate.year}'
                              : '', // إخفاء النص إذا لم يتم تحديد التاريخ
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      //(
                      onTap: () => _selectMonth(context),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: PreferredSize(
                preferredSize: Size.fromHeight(40.0),
                child: Container(
                  width: double.infinity,
                  color: Colors.white, // Set the background color to white
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilterChipWidget(
                              label: 'الكل',
                              isSelected: isAll,
                              onSelected: () {
                                _updateSelectedFilter(filter: 'All');
                                setState(() {
                                  isAll = true;
                                  isFullDaySelected = true;
                                  isEarlyLeaveSelected = false;
                                  isAbsentSelected = false;
                                  Casualleave = false;
                                  Regularholidays = false;
                                  Permissions = false;
                                  SickLeave = false;
                                });
                              },
                              required: false,
                            ),

                            FilterChipWidget(
                              label: 'الحضور',
                              isSelected: isEarlyLeaveSelected,
                              onSelected: () {
                                _updateSelectedFilter(filter: "الخروج المبكر");
                                setState(() {
                                  isAll = false;
                                  isFullDaySelected = false;
                                  isEarlyLeaveSelected = true;
                                  isAbsentSelected = false;
                                  Casualleave = false;
                                  Regularholidays = false;
                                  Permissions = false;
                                  SickLeave = false;
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
                                  Casualleave = false;
                                  Regularholidays = false;
                                  Permissions = false;
                                  SickLeave = false;
                                });
                              },
                              required: false,
                            ),
                            FilterChipWidget(
                              label: 'الاجازات الاعتيادية',
                              isSelected: Regularholidays,
                              onSelected: () {
                                _updateSelectedFilter(
                                    filter: "الاجازات الاعتيادية");
                                setState(() {
                                  isAll = false;
                                  isFullDaySelected = false;
                                  isEarlyLeaveSelected = false;
                                  isAbsentSelected = false;
                                  Regularholidays = true;
                                  Casualleave = false;
                                  Permissions = false;
                                  SickLeave = false;
                                });
                              },
                              required: false,
                            ),
                            FilterChipWidget(
                              label: 'الاجازات العارضة',
                              isSelected: Casualleave,
                              onSelected: () {
                                _updateSelectedFilter(
                                    filter: "الاجازات العارضة");
                                setState(() {
                                  isAll = false;
                                  isFullDaySelected = false;
                                  isEarlyLeaveSelected = false;
                                  isAbsentSelected = false;
                                  Casualleave = true;
                                  Regularholidays = false;
                                  Permissions = false;
                                  SickLeave = false;
                                });
                              },
                              required: false,
                            ),
                            FilterChipWidget(
                              label: 'الاجازات المرضية',
                              isSelected: SickLeave,
                              onSelected: () {
                                _updateSelectedFilter(
                                    filter: "الاجازات المرضية");
                                setState(() {
                                  isAll = false;
                                  isFullDaySelected = false;
                                  isEarlyLeaveSelected = false;
                                  isAbsentSelected = false;
                                  SickLeave = true;
                                  Casualleave = false;
                                  Regularholidays = false;
                                  Permissions = false;
                                });
                              },
                              required: false,
                            ),
                            FilterChipWidget(
                              label: ' الاذونات',
                              isSelected: Permissions,
                              onSelected: () {
                                _updateSelectedFilter(filter: " الاذونات");
                                setState(() {
                                  isAll = false;
                                  isFullDaySelected = false;
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
                            //  Spacer(),
                          ],
                        ),
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
                    //  height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    // تحديد عرض الشاشة بالكامل
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Calender/Menstrual_calendar.gif',
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
    final List<Map<String, String>> dayRecords;
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
      child: GestureDetector(
        onTap: () {
          _showDetailsPopup(context); // فتح النافذة المنبثقة عند الضغط
        },
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
      ),
    );
  }

  // دالة لعرض النافذة المنبثقة
  void _showDetailsPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // لجعل حجم الشيت قابل للتعديل
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)), // جعل الحواف العلوية مستديرة
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16), // إضافة مسافات داخل الشيت
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // زر إغلاق (علامة "إكس") على الجهة اليسرى
              Row(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'تفاصيل الحضور',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black87),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // إغلاق الشيت عند الضغط على الرمز
                      },
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 0.5,
              ),
              SizedBox(height: 16),
              _buildPopupRow('الحضور:', clockIn),
              _buildPopupRow('الانصراف:', clockOut),
              _buildPopupRow('المدة الكلية:', totalHours),
              _buildPopupRow('الحالة:', status),
              SizedBox(height: 20), // مسافة إضافية قبل الزر
            ],
          ),
        );
      },
    );
  }

  // دالة مساعدة لبناء صف في النافذة المنبثقة
  Widget _buildPopupRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Text(value),
        ],
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
