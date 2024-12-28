import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Profile/ProfileMain.dart';
import 'calender.dart';
import 'home1.dart';
import 'notification.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  final int index2;
  final String filter;

  const HomeScreen({Key? key, required this.index2, this.filter = 'All'})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      AttendanceScreen(),
      TasksScreen(),
      AttendancePage(filter: widget.filter),
      ProfilePage(),
    ];
    _selectedIndex = widget.index2;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          // المحتوى
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),

        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffEFECEF), width: 2)),
          color: Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem('assets/SvgNavbar/Home.svg', 'الرئيسية', 0),
            _buildNavItem('assets/SvgNavbar/Notifi.svg', 'الإشعارات', 1),
            _buildNavItem('assets/SvgNavbar/Calender.svg', 'المتابعه', 2),
            _buildNavItem('assets/SvgNavbar/profile.svg', 'الملف الشخصي', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    bool isActive = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              color: isActive
                  ? const Color(0xFF3D48AB)
                  : const Color(0xFFA49494),
              semanticsLabel: label,
            ),
          ),
          SizedBox(height: 5), // مسافة بين الأيقونة والنص
          Text(
            label,
            style: GoogleFonts.balooBhaijaan2(
              fontSize: 11,
              color: isActive
                  ? const Color(0xFF3D48AB)
                  : const Color(0xFFA49494),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
