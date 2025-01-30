import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wfi_details/onboarding/profile.dart';
import '../ FieldsMachine/setup/MainColors.dart';
import '../CustomNavbar/Drawer.dart';
import '../Request permission/Request_permission.dart';
import '../home/homeTest.dart';
import 'Profile/ProfileMain.dart';
import 'Profile/Wallet/Wallet.dart';
import 'Profile/custom section.dart';
import 'Request_money/Request_money_2.dart';
import 'Summary/Sammary1.dart';
import 'calender.dart';
import 'home1.dart';
import 'notification.dart';

class HomeScreen extends StatefulWidget {
  final int index2;
  final String filter;
  static const routeName = "/Navbar";

  const HomeScreen({Key? key, this.index2 = 2, this.filter = 'All'})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _advancedDrawerController = AdvancedDrawerController();
  int _selectedIndex = 3;
  late List<Widget> _screens;
  late AnimationController _controller;
  final GlobalKey _buttonKey = GlobalKey();
  late int index2;
  bool _isSheetVisible = false;

  @override
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index2;
    index2 = widget.index2;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _screens = [
      AttendanceScreen5(),
      TasksScreen(),
      AttendancePage(
        filter: widget.filter,
      ),
      ProfilePage(),
    ];
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
                      height: screenHeight > 900
                          ? screenHeight * 0.42
                          : screenHeight * 0.38,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
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
                              _controller.reverse();
                              setState(() {
                                _isSheetVisible = false;
                              });
                            },
                            child: Container(
                              color: Colors.black.withOpacity(0.0),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                                      _isSheetVisible = false;
                                    });
                                  },
                                ),
                                _buildOptionItem(
                                  context,
                                  title: "طلب إجازة",
                                  icon: Icons.beach_access,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LeaveRequestPage(),
                                      ),
                                    );
                                    _controller.reverse();
                                    setState(() {
                                      _isSheetVisible = false;
                                    });
                                  },
                                ),
                                _buildOptionItem(
                                  context,
                                  title: "إذن انصراف",
                                  icon: Icons.exit_to_app,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PermissionRequestPage(),
                                      ),
                                    );
                                    _controller.reverse();
                                    setState(() {
                                      _isSheetVisible = false;
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoanRequestPage(),
                                      ),
                                    );
                                    _controller.reverse();
                                    setState(() {
                                      _isSheetVisible = false;
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

  Future<bool> _onWillPop() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return Future.value(false);
    } else {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              title: Center(
                child: Text(
                  "تأكيد الخروج",
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colorss.MainText,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              content: Text(
                "هل أنت متأكد أنك تريد الخروج؟",
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colorss.SecondText,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // لا تغلق التطبيق
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colorss.mainColor,
                          side: BorderSide(color: Colorss.mainColor),
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "لا",
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // اغلق التطبيق
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colorss.mainColor,
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "نعم",
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )) ??
          false;
    }
  }

  void _toggleSheet(BuildContext context) {
    if (_isSheetVisible) {
      Navigator.pop(context);
      _controller.reverse();
    } else {
      //   _showSheet(context);
    }
    _isSheetVisible = !_isSheetVisible;
  }

  void _onItemTapped(int index) {
    if (index == 5) {
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
    return CustomAdvancedDrawer(
      controller: _advancedDrawerController,
      child: Scaffold(
        extendBody: true,
        floatingActionButton: GestureDetector(
          //   backgroundColor: Colors.transparent,
          key: _buttonKey,
          onTap: () {
            if (_controller.isCompleted) {
              _controller.reverse();
            } else {
              _controller.forward();
            }
            _showAnimatedBottomSheetFromButton(context, _buttonKey);
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.1415927,
                child: child,
              );
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colorss.mainColor,
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
        body: WillPopScope(
            onWillPop: _onWillPop, child: _screens[_selectedIndex]),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomAppBar(
              padding: EdgeInsets.all(0),
              shape: const CircularNotchedRectangle(),
              notchMargin: 12.0,
              color: Theme.of(context).colorScheme.background,
              child: Row(
                //   mainAxisAlignment: MainAxisAlignment.,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavItem(
                      'assets/SvgNavbar/home-2-svgrepo-com.svg', 'الحضور', 0),
                  _buildNavItem(
                      'assets/SvgNavbar/Calender.svg', 'الاحصائيات', 2),
                  const SizedBox(width: 50),
                  _buildNavItem('assets/SvgNavbar/Notifi.svg', 'المحفظة', 1),
                  _buildNavItem('assets/SvgNavbar/profile.svg', 'الاعدادات', 3),
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
        overlayColor: MaterialStateProperty.all(Colors.transparent),
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
                    color:
                        isActive ? Colorss.mainColor : const Color(0xFFA49494),
                    semanticsLabel: label,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

Widget _buildOptionItem(
  BuildContext context, {
  required String title,
  required IconData icon,
  required VoidCallback onTap,
  bool isLast = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ListTile(
        leading: Icon(icon, color: Colorss.mainColor, size: 24),
        title: Text(
          title,
          style: GoogleFonts.balooBhaijaan2(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
      if (!isLast)
        const Divider(
          thickness: 0.5,
          color: Colors.grey,
        ),
    ],
  );
}
