import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {

  String selectedMonth = 'March 2024';
  int selectedYear = 2024;// Default month
  bool isFullDaySelected = true;
  bool isEarlyLeaveSelected = false;
  bool isLateInSelected = false;
  bool isAbsentSelected = false;
  bool islateInSelected = false;

  DateTime selectedDate = DateTime.now(); // Initial date for the current month
  late List<Map<String, String>> monthData; // Holds data for the selected month
  @override
  void initState() {
    super.initState();
    _updateMonthData();
  }

  // Update month data based on selected year and month
  void _updateMonthData() {
    final firstDayOfMonth = DateTime(selectedYear, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(selectedYear, selectedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Generate data for each day of the month
    monthData = List.generate(daysInMonth, (index) {
      final day = (index + 1).toString();
      final weekday = DateFormat('EEE').format(DateTime(selectedYear, selectedDate.month, index + 1));

      return {
        'day': day,
        'weekday': weekday,
        'clockIn': '--:--',
        'clockOut': '--:--',
        'totalHours': '--:--',
        'status': 'Absent', // Default status for empty days
      };
    });

    setState(() {
      selectedMonth = DateFormat('MMMM yyyy').format(selectedDate);
    });
  }

  // Navigate to the previous month
  void _previousMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
      selectedYear = selectedDate.year;
      _updateMonthData();
    });
  }

  // Navigate to the next month
  void _nextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
      selectedYear = selectedDate.year;
      _updateMonthData();
    });
  }

  final Map<String, List<Map<String, String>>> attendanceData = {
    'March 2024': [
      {
        'day': '19',
        'weekday': 'Fri',
        'clockIn': '09:10',
        'clockOut': '06:10',
        'totalHours': '09:00',
        'status': 'Full Day',
      },
      {
        'day': '18',
        'weekday': 'Thu',
        'clockIn': '--:--',
        'clockOut': '--:--',
        'totalHours': '--:--',
        'status': 'Absent',
      },
      {
        'day': '17',
        'weekday': 'Wed',
        'clockIn': '09:10',
        'clockOut': '04:10',
        'totalHours': '07:00',
        'status': 'Early Leave',
      },
      {
        'day': '16',
        'weekday': 'Tue',
        'clockIn': '09:10',
        'clockOut': '06:10',
        'totalHours': '09:00',
        'status': 'Full Day',
      },
      {
        'day': '15',
        'weekday': 'Mon',
        'clockIn': '09:10',
        'clockOut': '06:10',
        'totalHours': '09:00',
        'status': 'Full Day',
      },
      {
        'day': '14',
        'weekday': 'Sun',
        'clockIn': '--:--',
        'clockOut': '--:--',
        'totalHours': '--:--',
        'status': 'Absent',
      },
    ],
    // Add more months here if needed
  };

  @override
  Widget build(BuildContext context) {
    // Filter the data based on the selected filters
    List<Map<String, String>> filteredData = monthData.where((data) {
      if (isFullDaySelected && data['status'] == 'Full Day') {
        return true;
      }
      if (isEarlyLeaveSelected && data['status'] == 'Early Leave') {
        return true;
      }
      if (isLateInSelected && data['status'] == 'Late in') {
        return true;
      }
      if (isAbsentSelected && data['status'] == 'Absent') {
        return true;
      }
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(toolbarHeight: 10,backgroundColor: Colors.white,),
      body: Column(
        children: [

          Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
            children: [

              IconButton(

                  onPressed: _previousMonth,

                icon: const Icon(Icons.chevron_left,size: 35,color: Color(0xff3880ee),),
              ),
SizedBox(width: 10,),

              Row(
                children: [
                  // شهر وسنة
                  Text(
                    '$selectedMonth',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Color(0xff3880ee),),
                  ),
                  // التاريخ بجانب الشهر
                  const SizedBox(width: 8),
                  Icon(Icons.calendar_today_outlined, size: 18,color: Color(0xff3880ee),), // رمز التاريخ
                ],
              ),
              SizedBox(width: 10,),

              IconButton(

                  onPressed: _nextMonth,

                icon: const Icon(Icons.chevron_right,size: 35,color: Color(0xff3880ee),),
              ),
            ],
          ),
        ),

          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterChipWidget(
                  label: 'All',
                  isSelected: isFullDaySelected && !isEarlyLeaveSelected && !isLateInSelected && !isAbsentSelected,
                  onSelected: () {
                    setState(() {
                      isFullDaySelected = true;
                      isEarlyLeaveSelected = true;
                      isLateInSelected = true;
                      isAbsentSelected = true;
                      islateInSelected=true;
                    });
                  },
                ),
                FilterChipWidget(
                  label: 'Full Day',
                  isSelected: isFullDaySelected,
                  onSelected: () {
                    setState(() {
                      isFullDaySelected = !isFullDaySelected;
                    });
                  },
                ),
                FilterChipWidget(
                  label: 'Early Leave',
                  isSelected: isEarlyLeaveSelected,
                  onSelected: () {
                    setState(() {
                      isEarlyLeaveSelected = !isEarlyLeaveSelected;
                    });
                  },
                ),
                FilterChipWidget(
                  label: 'Absents',
                  isSelected: isAbsentSelected,
                  onSelected: () {
                    setState(() {
                      isAbsentSelected = !isAbsentSelected;
                    });
                  },
                ),  FilterChipWidget(
                  label: 'LateIn',
                  isSelected:  islateInSelected ,
                  onSelected: () {
                    setState(() {
                      islateInSelected  = ! islateInSelected ;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final data = filteredData[index];
                return GestureDetector(

                  child: AttendanceCard(
                    day: data['day']!,
                    weekday: data['weekday']!,
                    clockIn: data['clockIn']!,
                    clockOut: data['clockOut']!,
                    totalHours: data['totalHours']!,
                    status: data['status']!,
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Weekend off: 14 Sunday & 13 Saturday',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
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
            color: isSelected ? Colors.blue : Colors.grey, // تغيير لون النص فقط عند الاختيار
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: Colors.white, // لا تغيير في الخلفية عند الاختيار
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // جعل الحواف دائرية
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey, // تغيير لون الحدود بناءً على الاختيار
            width: 0.5, // عرض الحدود
          ),
        ),
        showCheckmark: false,
      )


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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // توزيع العناصر بشكل متساوي
            children: [
              DayAndWeekdayColumn(day: day, weekday: weekday),
              const SizedBox(width: 5),
              AttendanceColumn(clockIn: clockIn, label: 'تسجيل الحضور', icon: FontAwesomeIcons.clockFour),
              AttendanceColumn(clockIn: clockOut, label: 'تسجيل الانصراف', icon: FontAwesomeIcons.clockRotateLeft),
              AttendanceColumn(clockIn: totalHours, label: 'المدة الكلية', icon: Icons.check_circle),
              StatusColumn(status: status),
            ],
          ),
          DividerRow(),
        ],
      ),
    );
  }
}

// Custom widget for Day and Weekday column
class DayAndWeekdayColumn extends StatelessWidget {
  final String day;
  final String weekday;

  const DayAndWeekdayColumn({
    super.key,
    required this.day,
    required this.weekday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              '$day',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 4), // المسافة بين اليوم واليوم الأسبوعي
            Text(
              '$weekday',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for Attendance columns
class AttendanceColumn extends StatelessWidget {
  final String clockIn;
  final String label;
  final IconData icon;

  const AttendanceColumn({
    super.key,
    required this.clockIn,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(
            clockIn,
            style: TextStyle(fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Custom widget for Status column
class StatusColumn extends StatelessWidget {
  final String status;

  const StatusColumn({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 4), // المسافة بين "Total hrs" و حالة الحضور
        Text(
          status,
          style: TextStyle(
            color: status == 'Absent'
                ? Colors.red
                : (status == 'Early Leave'
                ? Colors.orange
                : Colors.green),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Custom widget for the divider row
class DividerRow extends StatelessWidget {
  const DividerRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(37, (index) {
          return Container(
            width: 6,  // عرض الشرطة
            height: 1, // سمك الشرطة
            margin: const EdgeInsets.symmetric(horizontal: 2), // المسافة بين الشرطات
            color: Colors.blueGrey, // لون الشرطة
          );
        }),
      ),
    );
  }
}




/*  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$weekday, $day',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text('Clock In: $clockIn'),
              Text('Clock Out: $clockOut'),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Total hrs: $totalHours'),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  color: status == 'Absent'
                      ? Colors.red
                      : (status == 'Early Leave'
                      ? Colors.orange
                      : Colors.green),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),*/