import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'calender.dart';
import 'home1.dart';
import 'notification.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  final int index2;
  final String filter;
  @override
  const HomeScreen({Key? key, required this.index2, this.filter = 'All'})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  // Declare _screens without passing filter here
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize _screens here where you have access to widget.filter
    _screens = [
      AttendanceScreen(),
      TasksScreen(),
      AttendancePage(filter: widget.filter), // Access widget.filter here

      ProfileScreen(),
    ];
    // Set the initial selected index from widget.index2
    _selectedIndex = widget.index2;
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(FontAwesomeIcons.home, 'الرئيسية', 0),
            _buildNavItem(FontAwesomeIcons.bell, 'الإشعارات', 1),
            _buildNavItem(FontAwesomeIcons.calendar, 'التواريخ', 2),
            _buildNavItem(FontAwesomeIcons.user, 'البروفايل', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // زيادة المساحة القابلة للنقر
        child: FaIcon(
          icon,
          size: 24,
          color: _selectedIndex == index ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}
