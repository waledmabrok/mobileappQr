import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wfi_details/onboarding/profile.dart';
import '../ FieldsMachine/setup/MainColors.dart';
import '../home/homeTest.dart';
import 'Profile/ProfileMain.dart';
import 'Profile/Wallet.dart';
import 'calender.dart';
import 'home1.dart';
import 'notification.dart';

class HomeScreen extends StatefulWidget {
  final int index2;
  final String filter;

  const HomeScreen({Key? key, required this.index2, this.filter = 'All'})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  int _selectedIndex = 0;
  late List<Widget> _screens;
  String userName = '';
  String useremail = '';
  String userProfilePicture = '';
  String position = "";

  @override
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'غير معروف';
      userProfilePicture = prefs.getString('user_profile_picture') ?? '';
      useremail = prefs.getString('user_email') ?? '';
      position = prefs.getString('user_position') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _screens = [
      TasksScreen(),
      AttendancePage(filter: widget.filter),
      AttendanceScreen5(),
      AttendanceScreen(),
      ProfilePage(),
    ];
    _selectedIndex = widget.index2;
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      // Trigger the drawer or menu opening action here
      _handleMenuButtonPressed();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _handleMenuButtonPressed() {
    // Your existing code for opening the drawer
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: _advancedDrawerController,
      backdrop: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo,
              Colors.indigo,
            ],
          ),
        ),
      ),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: true,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                        image: DecorationImage(
                          image: NetworkImage(userProfilePicture.isNotEmpty
                              ? userProfilePicture
                              : 'image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 144,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/checkdone.svg",
                                        width: 24,
                                        height: 24,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        userName,
                                        style: GoogleFonts.balooBhaijaan2(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          //  النصية للإيميل
                          Container(
                            width: 144,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                useremail,
                                style: GoogleFonts.balooBhaijaan2(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ListTile(
                  onTap: () {
                    _advancedDrawerController.toggleDrawer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    ).then((value) {
                      // إغلاق الـ Drawer بعد الانتقال إلى الصفحة
                      _advancedDrawerController.hideDrawer();
                    });
                  },
                  leading: Icon(
                    Icons.person,
                  ),
                  title: Text(
                    'الحساب',
                    style: GoogleFonts.balooBhaijaan2(),
                  ),
                ),
                ListTile(
                  onTap: () {
                    _advancedDrawerController.toggleDrawer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Wallet()),
                    ).then((value) {
                      // إغلاق الـ Drawer بعد الانتقال إلى الصفحة
                      _advancedDrawerController.hideDrawer();
                    });
                  },
                  leading: Icon(
                    Icons.wallet,
                  ),
                  title: Text(
                    'المحفظه',
                    style: GoogleFonts.balooBhaijaan2(),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text(
                    'الاعدادات',
                    style: GoogleFonts.balooBhaijaan2(),
                  ),
                ),
                ListTile(
                  onTap: () => _onItemTapped(0),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    'تسجيل خروج',
                    style: GoogleFonts.balooBhaijaan2(color: Colors.red),
                  ),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('Yourcolor.net'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60.0, left: 20),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 2; // الانتقال إلى الشاشة الرئيسية (index 2)
              });
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF487FDB), Color(0xFF9684E1)],
                  stops: [0.1667, 0.6756],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  "assets/SvgNavbar/Home.svg",
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
                child: SvgPicture.asset("assets/SvgNavbar/background.svg")),
            IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Color(0xffEFECEF), width: 2)),
                      color: Colors.white.withOpacity(0.6),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNavItem(
                            'assets/SvgNavbar/Calender.svg', 'المتابعه', 1),
                        _buildNavItem(
                            'assets/SvgNavbar/Notifi.svg', 'الإشعارات', 0),
                        const SizedBox(width: 50),
                        _buildNavItem('assets/time.svg', 'الحضور', 3),
                        _buildNavItem(
                            'assets/SvgNavbar/profile.svg', 'الملف الشخصي', 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
              color:
                  isActive ? const Color(0xFF3D48AB) : const Color(0xFFA49494),
              semanticsLabel: label,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.balooBhaijaan2(
              fontSize: 11,
              color:
                  isActive ? const Color(0xFF3D48AB) : const Color(0xFFA49494),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
