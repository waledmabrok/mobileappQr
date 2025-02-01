import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ FieldsMachine/setup/MainColors.dart';
import '../MainHome/CustomFilter.dart';

class CustomAdvancedDrawer extends StatelessWidget {
  final Widget child;
  final AdvancedDrawerController controller;

  CustomAdvancedDrawer({required this.child, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: controller,
      backdrop: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.inverseSurface),
      ),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: true,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      drawer: CustomDrawerContent(),
      child: child,
    );
  }
}

class CustomDrawerContent extends StatelessWidget {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.inverseSurface),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              children: [
                // Header Section

                // Drawer Items
                _buildDrawerItem(
                  context,
                  iconPath: "assets/Customhome/login-svgrepo-com.svg",
                  label: 'تسجيل حضور',
                  onTap: () {
                    Navigator.pushNamed(context, "/attendance");
                  },
                ),
                _buildDrawerItem(
                  context,
                  iconPath:
                      "assets/Customhome/statistics-graph-stats-analytics-business-data-svgrepo-com.svg",
                  label: 'الاحصائيات',
                  onTap: () {
                    //   Navigator.pop(context); // إغلاق الدراور
                    Navigator.pushNamed(context, "/statistic");
                  },
                ),
                _buildDrawerItem(
                  context,
                  iconPath: "assets/Customhome/calendar-svgrepo-com.svg",
                  label: 'الاجازات',
                  onTap: () {
                    Navigator.pushNamed(context, '/summary');
                  },
                ),
                Divider(color: Colors.grey.withOpacity(0.3), height: 20),
                _buildDrawerItem(
                  context,
                  iconPath: "assets/Customhome/permissions-svgrepo-com.svg",
                  label: 'الاذونات',
                  onTap: () {
                    Navigator.pushNamed(context, "/permission");
                  },
                ),
                _buildDrawerItem(
                  context,
                  iconPath:
                      "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                  label: 'السٌلَف',
                  onTap: () {
                    Navigator.pushNamed(context, '/requst_money');
                  },
                ),
                Divider(color: Colors.grey.withOpacity(0.3), height: 20),
                _buildDrawerItem(
                  context,
                  iconPath: "assets/SvgProfile/wallet-receive-svgrepo-com2.svg",
                  label: 'كل المعاملات',
                  onTap: () {
                    Navigator.pushNamed(context, '/all_transaction');
                  },
                ),
                _buildDrawerItem(
                  context,
                  iconPath: "assets/SvgProfile/wallet-svgrepo-com.svg",
                  label: 'المحفظه',
                  onTap: () {
                    Navigator.pushNamed(context, '/My_wallet');
                  },
                ),
                _buildDrawerItem(
                  context,
                  iconPath: "assets/SvgProfile/wallet-minus-svgrepo-com.svg",
                  label: 'خصومات',
                  onTap: () {
                    Navigator.pushNamed(context, '/Discounts_Page');
                  },
                ),
                Divider(color: Colors.grey.withOpacity(0.3), height: 20),
                _buildDrawerItem(
                  context,
                  iconPath: "assets/Customhome/date-today-svgrepo-com.svg",
                  label: 'كل الانشطه',
                  onTap: () {
                    Navigator.pushNamed(context, '/Main_Activity');
                  },
                ),
                _buildDrawerItem(
                  context,
                  iconPath: "assets/Customhome/money-recive-svgrepo-com.svg",
                  label: 'طلب سلفه',
                  onTap: () {
                    Navigator.pushNamed(context, '/request_money2');
                  },
                ),
                _buildDrawerItem(
                  context,
                  iconPath: "assets/Customhome/list.svg",
                  label: 'كل الطلبات',
                  onTap: () {
                    Navigator.pushNamed(context, '/All_requests');
                  },
                ),
                _buildDrawerItem(
                  context,
                  iconPath: "assets/Customhome/calendar-svgrepo-com.svg",
                  label: 'طلب اجازه',
                  onTap: () {
                    Navigator.pushNamed(context, '/request_summary');
                  },
                ),
                _buildDrawerItem(
                  context,
                  iconPath: "assets/Customhome/permissions-svgrepo-com.svg",
                  label: 'طلب اذن',
                  onTap: () {
                    Navigator.pushNamed(context, '/request_Premission2');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        color: Colors.black,
      ),
      title: Text(
        label,
        style: GoogleFonts.balooBhaijaan2(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
