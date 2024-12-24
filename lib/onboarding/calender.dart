import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ FieldsMachine/Custom in Calender/Attendet.dart';
import '../ FieldsMachine/Custom in Calender/Day and week.dart';
import '../ FieldsMachine/Custom in Calender/line.dart';
import '../ FieldsMachine/Custom in Calender/status.dart';
import '../ FieldsMachine/Custom in Calender/Sketlon.dart';
import '../CustomApi/Api calender/api calender.dart';

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
  String selectedMonth = 'December 2024';
  int selectedYear = 2024;
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();
  late Future<List<Attendance>> attendanceData; // Future for API data
  bool isFullDaySelected = false;
  String currentFilter = 'All';

  bool isAll = true;
  bool isEarlyLeaveSelected = false;
  bool isAbsentSelected = false;
  int? employeeId;
  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
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
      attendanceData = AttendanceService()
          .fetchAttendance(employeeId!, selectedDate.month, selectedDate.year);
    } else {
      // Handle case when employeeId is null
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80, // Adjust toolbar height as needed
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 0, // Optional to remove shadow
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(
                  Icons.chevron_left,
                  size: 35,
                  color: Color(0xff3880ee),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  // شهر وسنة
                  Text(
                    '$selectedMonth',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3880ee),
                    ),
                  ),
                  // التاريخ بجانب الشهر
                  const SizedBox(width: 8),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: Color(0xff3880ee),
                  ), // رمز التاريخ
                ],
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(
                  Icons.chevron_right,
                  size: 35,
                  color: Color(0xff3880ee),
                ),
              ),
            ],
          ),
        ),
      ),


      body: Container(color: Color(0xfffafafc),
        child: Column(

          children: [
            // Month Navigation

            PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Container(
                width: double.infinity,
                color: Colors.white, // Set the background color to white
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            onSelected: () {   _updateSelectedFilter(filter: "الخروج المبكر");
                              setState(() {
                                isAll = false;
                                isFullDaySelected = false;
                                isEarlyLeaveSelected = true;
                                isAbsentSelected = false;
                              });
                            },
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
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 15,),
            // Attendance Data
            FutureBuilder<List<Attendance>>(
              future: attendanceData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
              return SingleChildScrollView(child: SkeletonCard());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load attendance data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No attendance records found'));
                } else {
                  List<Attendance> filteredData = snapshot.data!;

                  // Apply filters to the data (Full Day, Late, etc.)
                  if (isAll) {
                    filteredData = filteredData.where((attendance) => attendance.status == 'All').toList();
                  }
                  if (isEarlyLeaveSelected) {
                    filteredData = filteredData.where((attendance) => attendance.status == 'Under Time').toList();
                  }
                  if (isAbsentSelected) {
                    filteredData = filteredData.where((attendance) => attendance.status == 'Absent').toList();
                  }

                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final data = filteredData[index];
                        return AttendanceCard(

                          day: data.date.day,
                          weekday: data.date.dayName, // You might want to improve this to display day names
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
  final VoidCallback onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.blue
                : Colors.grey, // Change text color when selected
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
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
        'icon': Icons.check_circle
      },
    ];

    return Padding(
      padding: EdgeInsetsDirectional.only(start: 5, end: 5, top: 10),
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: screenWidth * 0.01, horizontal: screenWidth * 0.01),
        decoration: BoxDecoration(
          color: Color(0xfffafafc),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Start from the beginning
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align content to the left
              children: [
                DayAndWeekdayColumn(day: day, weekday: weekday),
                SizedBox(width: 20),
                Wrap(
                  spacing: 30.0,
                  runSpacing: 4.0,
                  children: details.map((detail) {
                    return AttendanceColumn(
                      clockIn: detail['value'],
                      label: detail['label'],
                      icon: detail['icon'],
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                StatusColumn(status: status),
              ],
            ),
            SizedBox(
              height: screenWidth * 0.05,
            ),
            DividerRow(),
          ],
        ),
      ),
    );
    ;

    ;
  }
}
