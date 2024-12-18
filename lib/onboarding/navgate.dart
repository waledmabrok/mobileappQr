import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wfi_details/onboarding/profile.dart';
import 'home1.dart';
import 'notification.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AttendanceScreen(),
    TasksScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300, // خط خفيف فوق الـ BottomNavigationBar
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xff3880ee),
          unselectedItemColor: Color(0xffc2c3c4),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 15,
          unselectedFontSize: 12,
          selectedLabelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.cairo(),
          items: [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home), // أيقونة FontAwesome
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bell), // أيقونة FontAwesome
              label: 'الإشعارات',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user), // أيقونة FontAwesome
              label: 'البروفايل',
            ),
          ],
        ),
      ),
    );
  }
}
