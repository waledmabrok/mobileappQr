import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ FieldsMachine/setup/MainColors.dart';
import '../Request permission/Request_permission.dart';
import '../home/homeTest.dart';
import '../onboarding/Profile/ProfileMain.dart';
import '../onboarding/Profile/custom section.dart';
import '../onboarding/Request_money/Request_money_2.dart';
import '../onboarding/Summary/Sammary1.dart';
import '../onboarding/calender.dart';
import '../onboarding/home1.dart';
import '../onboarding/navgate.dart';
import '../onboarding/notification.dart';
import '../onboarding/profile.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    this.selectedIndex = 0,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  bool _isSheetOpen = false;

  final GlobalKey _buttonKey = GlobalKey();
  late List<Widget> _screens;
  bool _isSheetVisible = false;
  String userName = '';
  String useremail = '';
  String userProfilePicture = '';
  String position = "";
  final _advancedDrawerController = AdvancedDrawerController();

  void _onItemTapped(int index) {
    widget.onItemTapped(
        index); // Call the callback to update the index in the parent widget
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _screens = [
      AttendanceScreen5(
        advancedDrawerController: _advancedDrawerController,
      ),
      TasksScreen(),
      AttendancePage(),
      ProfilePage(),
    ];
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'غير معروف';
      userProfilePicture = prefs.getString('user_profile_picture') ?? '';
      useremail = prefs.getString('user_email') ?? '';
      position = prefs.getString('user_position') ?? '';
    });
  }

  void _showAnimatedBottomSheetFromButton(BuildContext context, GlobalKey key) {
    final RenderBox renderBox =
    key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size buttonSize = renderBox.size;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations
          .of(context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, animation, secondaryAnimation) {
        double screenWidth = MediaQuery
            .of(context)
            .size
            .width;
        double screenHeight = MediaQuery
            .of(context)
            .size
            .height;
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
                      height: screenHeight < 850
                          ? screenHeight * 0.42
                          : screenHeight * 0.38,
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .background,
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
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .background,
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
        double screenWidth = MediaQuery
            .of(context)
            .size
            .width;
        double screenHeight = MediaQuery
            .of(context)
            .size
            .height;
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
    ).whenComplete(() {
      // عكس الأنميشن عند إغلاق الـ BottomSheet
      if (_controller.isCompleted) {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: GestureDetector(
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
      bottomNavigationBar: Container(
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
          shape: const CircularNotchedRectangle(),
          notchMargin: 12.0,
          color: Theme
              .of(context)
              .colorScheme
              .background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavItem(
                  'assets/SvgNavbar/home-2-svgrepo-com.svg', 'الحضور', 0),
              _buildNavItem('assets/SvgNavbar/Calender.svg', 'الاحصائيات', 1),
              const SizedBox(width: 50), // مكان الزر العائم
              _buildNavItem('assets/SvgNavbar/Notifi.svg', 'المحفظة', 2),
              _buildNavItem('assets/SvgNavbar/profile.svg', 'الاعدادات', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    bool isActive = widget.selectedIndex == index;

    return InkWell(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: () {
        _onItemTapped(index);
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(
                    index2: 0,
                  ),
            ),
          );
        }
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(
                    index2: 2,
                  ),
            ),
          );
        }
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(
                    index2: 1,
                  ),
            ),
          );
        }
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(
                    index2: 3,
                  ),
            ),
          );
        }
      },
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
      ),
    );
  }
}

Widget _buildOptionItem(BuildContext context, {
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
          color: Colors.grey,
          thickness: 0.5,
        ),
    ],
  );
}
