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
import 'Profile/Wallet/Wallet.dart';
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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _advancedDrawerController = AdvancedDrawerController();
  int _selectedIndex = 3;
  late List<Widget> _screens;
  String userName = '';
  String useremail = '';
  String userProfilePicture = '';
  String position = "";
  late AnimationController _controller;
  bool _isSheetOpen = false;
  final GlobalKey _buttonKey = GlobalKey();

// تعريف متغير لتحديد حالة الشيت
  bool _isSheetVisible = false;

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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadUserData();
    _screens = [
      AttendanceScreen5(),
      TasksScreen(),
      AttendancePage(filter: widget.filter),
      AttendanceScreen5(),
      // AttendanceScreen(),
      ProfilePage(),
    ];
    _selectedIndex = widget.index2;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAnimatedBottomSheetFromButton(BuildContext context, GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size buttonSize = renderBox.size;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, animation, secondaryAnimation) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        double textFontSize = screenWidth * 0.037;
        double lineHeight = textFontSize * 1.2;
        double verticalMargin = screenHeight * 0.01;

        return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              FocusScope.of(context).unfocus();
              return true;
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 130.0),
                child: Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 5,
                    child: Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _controller.reverse(); // عكس الأنميشن
                              setState(() {
                                _isSheetVisible = false; // إخفاء الشيت
                              });
                            },
                            child: Container(
                              color: Colors.black.withOpacity(0.0),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /*  Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),*/
                                const SizedBox(height: 20),
                                _buildOptionItem(
                                  context,
                                  title: "تسجيل الحضور",
                                  icon: Icons.check_circle_outline,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AttendanceScreen(),
                                      ),
                                    );
                                    _controller.reverse();
                                    setState(() {
                                      _isSheetVisible = false; // إغلاق الشيت
                                    });
                                  },
                                ),
                                _buildOptionItem(
                                  context,
                                  title: "طلب إجازة",
                                  icon: Icons.beach_access,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                        context, '/leave-request');
                                    _controller.reverse();
                                    setState(() {
                                      _isSheetVisible = false; // إغلاق الشيت
                                    });
                                  },
                                ),
                                _buildOptionItem(
                                  context,
                                  title: "إذن انصراف",
                                  icon: Icons.exit_to_app,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                        context, '/exit-permission');
                                    _controller.reverse();
                                    setState(() {
                                      _isSheetVisible = false; // إغلاق الشيت
                                    });
                                  },
                                ),
                                _buildOptionItem(
                                  isLast: true,
                                  context,
                                  title: "طلب سلفة",
                                  icon: Icons.attach_money,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                        context, '/loan-request');
                                    _controller.reverse();
                                    setState(() {
                                      _isSheetVisible = false; // إغلاق الشيت
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(
                (offset.dx + buttonSize.width / 2) / screenWidth * 2 - 1,
                (offset.dy + buttonSize.height / 2) / screenHeight * 2 - 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuad,
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.1, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutQuad,
              ),
            ),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
      },
    );
  }

  void _toggleSheet(BuildContext context) {
    if (_isSheetVisible) {
      // إذا كان الشيت ظاهرًا، قم بإغلاقه
      Navigator.pop(context);
      _controller.reverse(); // عكس الأنميشن
    } else {
      // إذا لم يكن الشيت ظاهرًا، قم بفتحه
      //   _showSheet(context);
    }
    _isSheetVisible = !_isSheetVisible; // تغيير حالة الشيت
  }

/*  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // إغلاق الشيت عند الضغط على الخلفية
                    _controller.reverse(); // عكس الأنميشن
                    setState(() {
                      _isSheetVisible = false; // إخفاء الشيت
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.0),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 20),
                  // وقت الحركة
                  bottom: _isSheetVisible ? 150 : 150,
                  // تحرك الشيت من الزر للأعلى
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _isSheetVisible
                        ? 1.0
                        : 0.0, // تأثير الشفافية (Fade In / Fade Out)
                    duration: Duration(milliseconds: 30), // وقت الشفافية
                    child: FractionallySizedBox(
                      widthFactor: 0.8, // العرض النسبي للشيت
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            */ /*  Center(
                              child: Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),*/ /*
                            const SizedBox(height: 20),
                            _buildOptionItem(
                              context,
                              title: "تسجيل الحضور",
                              icon: Icons.check_circle_outline,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/attendance');
                                _controller.reverse();
                                setState(() {
                                  _isSheetVisible = false; // إغلاق الشيت
                                });
                              },
                            ),
                            _buildOptionItem(
                              context,
                              title: "طلب إجازة",
                              icon: Icons.beach_access,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/leave-request');
                                _controller.reverse();
                                setState(() {
                                  _isSheetVisible = false; // إغلاق الشيت
                                });
                              },
                            ),
                            _buildOptionItem(
                              context,
                              title: "إذن انصراف",
                              icon: Icons.exit_to_app,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, '/exit-permission');
                                _controller.reverse();
                                setState(() {
                                  _isSheetVisible = false; // إغلاق الشيت
                                });
                              },
                            ),
                            _buildOptionItem(
                              isLast: true,
                              context,
                              title: "طلب سلفة",
                              icon: Icons.attach_money,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/loan-request');
                                _controller.reverse();
                                setState(() {
                                  _isSheetVisible = false; // إغلاق الشيت
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }*/

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
        extendBody: true,
        floatingActionButton: GestureDetector(
          //   backgroundColor: Colors.transparent,
          key: _buttonKey,
          onTap: () {
            if (_controller.isCompleted) {
              // إذا كان الأنميشن قد انتهى (الدوران اكتمل)
              _controller.reverse(); // العودة إلى الوضع الأصلي
            } else {
              // إذا كان الأنميشن لم يكتمل
              _controller.forward(); // تشغيل الأنميشن (الدوران)
            }
            _showAnimatedBottomSheetFromButton(
                context, _buttonKey); // عرض الشيت السفلي
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              // يدور الزر عند كل نقرة
              return Transform.rotate(
                angle: _controller.value * 2 * 3.1415927, // دوران 360 درجة
                child: child,
              );
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colorss.mainColor, // اللون الأساسي
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  "assets/SvgNavbar/plus-svgrepo-com.svg",
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1), // لون الظل
                  spreadRadius: 0, // انتشار الظل
                  blurRadius: 4, // درجة التمويه
                  offset: const Offset(0, -2), // موضع الظل
                ),
              ],
            ),
            child: BottomAppBar(
              padding: EdgeInsets.all(0),
              shape: const CircularNotchedRectangle(),
              notchMargin: 12.0,
              color: Colors.white,
              child: Row(
                //   mainAxisAlignment: MainAxisAlignment.,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavItem(
                      'assets/SvgNavbar/home-2-svgrepo-com.svg', 'الحضور', 3),

                  _buildNavItem(
                      'assets/SvgNavbar/Calender.svg', 'الاحصائيات', 2),
                  const SizedBox(width: 50), // الفراغ حول زر الفاب
                  _buildNavItem('assets/SvgNavbar/Notifi.svg', 'المحفظة', 1),
                  _buildNavItem('assets/SvgNavbar/profile.svg', 'الاعدادات', 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    bool isActive = _selectedIndex == index;

    return InkWell(
        overlayColor: MaterialStateProperty.all(Colors.white),
        onTap: () => _onItemTapped(index),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            if (isActive)
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  ClipRRect(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        color: Colorss.mainColor.withOpacity(0.7),
                      ),
                      width: 25,
                      height: 3,
                    ),
                  ),
                  ClipRect(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colorss.mainColor.withOpacity(0.1),
                            Colorss.mainColor.withOpacity(0.0),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                          topRight: Radius.circular(70),
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                      width: 40,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ClipRect(
              child: Align(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 40,
                    height: 25,
                    color: isActive
                        ? const Color(0xFF3D48AB)
                        : const Color(0xFFA49494),
                    semanticsLabel: label,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

// عنصر فردي للخيارات
Widget _buildOptionItem(
  BuildContext context, {
  required String title,
  required IconData icon,
  required VoidCallback onTap,
  bool isLast = false, // إضافة متغير لتحديد ما إذا كان هذا العنصر الأخير
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ListTile(
        leading: Icon(icon, color: Colorss.mainColor, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
      if (!isLast) // إذا لم يكن العنصر الأخير، أضف الخط
        const Divider(
          thickness: 0.5,
        ),
    ],
  );
}
