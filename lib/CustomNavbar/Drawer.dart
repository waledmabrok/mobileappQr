import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import '../ FieldsMachine/setup/MainColors.dart';
import '../MainHome/CustomFilter.dart';
import '../Request permission/Requst-Permission_Main.dart';
import '../onboarding/Request_money/Request_money_main.dart';
import '../onboarding/Statistics/StatisticsMain.dart';
import '../onboarding/Summary/main_Summary.dart';
import '../onboarding/navgate.dart';

class CustomAdvancedDrawer extends StatelessWidget {
  final Widget child;
  final AdvancedDrawerController controller;

  CustomAdvancedDrawer({required this.child, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: controller,
      backdrop: Container(
        decoration: BoxDecoration(color: Theme
            .of(context)
            .colorScheme
            .primary),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 70),
        child: Align(
          alignment: Alignment.topCenter,
          child: Wrap(
            spacing: 15,
            runSpacing: 10,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [

              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, "/attendance");
                  },
                  iconPath:
                  "assets/Customhome/statistics-graph-stats-analytics-business-data-svgrepo-com.svg",
                  label: 'تسجيل حضور',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, "/statistic");
                  },
                  iconPath:
                  "assets/Customhome/statistics-graph-stats-analytics-business-data-svgrepo-com.svg",
                  label: 'الاحصائيات',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, '/summary');
                  },
                  iconPath: "assets/Customhome/calendar-svgrepo-com.svg",
                  label: 'الاجازات',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, "/permission");
                  },
                  iconPath: "assets/Customhome/permissions-svgrepo-com.svg",
                  label: 'الاذونات',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, '/requst_money');
                  },
                  iconPath:
                  "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                  label: 'السٌلَف',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, '/all_transaction');
                  },
                  iconPath:
                  "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                  label: 'كل المعاملات',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, '/My_wallet');
                  },
                  iconPath:
                  "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                  label: 'المحفظه',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, '/Discounts_Page');
                  },
                  iconPath:
                  "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                  label: 'خصومات',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, '/Main_Activity');
                  },
                  iconPath:
                  "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                  label: 'كل الانشطه',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, '/request_money2');
                  },
                  iconPath:
                  "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                  label: 'طلب سلفه',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, '/All_requests');
                  },
                  iconPath:
                  "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                  label: 'كل الطلبات',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, '/request_summary');
                  },
                  iconPath:
                  "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                  label: 'طلب اجازه',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomNotificationWidgetRow(
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.pushNamed(context, '/request_Premission2');
                  },
                  iconPath:
                  "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                  label: 'طلب اذن',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
