import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ FieldsMachine/setup/MainColors.dart';
import '../../navgate.dart';
import 'CustomWallet/CustomAlltransaction.dart';

class transactionAll extends StatefulWidget {
  const transactionAll({super.key});

  @override
  State<transactionAll> createState() => _transactionAllState();
}

class _transactionAllState extends State<transactionAll> {
  String userName = '';
  String userEmail = '';
  String userProfilePicture = '';
  String position = '';
  String enteredNumber = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'غير معروف';
      userProfilePicture = prefs.getString('user_profile_picture') ?? '';
      userEmail = prefs.getString('user_email') ?? '';
      position = prefs.getString('user_position') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 35.0, left: 20, right: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    overlayColor: WidgetStatePropertyAll(Colors.white),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colorss.BorderColor)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: userProfilePicture.isNotEmpty
                            ? CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(userProfilePicture),
                              )
                            : Icon(Icons.person, size: 35),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "اهلا ${userName}  ",
                              style: GoogleFonts.balooBhaijaan2(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 1),
                          ],
                        ),
                        Spacer(),
                        InkWell(
                          overlayColor: WidgetStatePropertyAll(Colors.white),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(index2: 1),
                              ),
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: Colorss.BorderColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.notification_important_outlined,
                                  size: 18,
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xfff8f8f8),
                ),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Text(
                          'المعاملات',
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/broww.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "طلب سلفه",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "فشلت",
                    iconColor: Colorss.BorderColor,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/wither.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "تاريخ الرواتب",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "نجحت العمليه",
                    iconColor: Colorss.BorderColor,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/mins.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "الخصومات",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "نجحت العمليه",
                    iconColor: Colorss.BorderColor,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/broww.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "طلب سلفه",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "فشلت",
                    iconColor: Colorss.BorderColor,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/mins.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "الخصومات",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "نجحت العمليه",
                    iconColor: Colorss.BorderColor,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/broww.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "طلب سلفه",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "فشلت",
                    iconColor: Colorss.BorderColor,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/wither.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "تاريخ الرواتب",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "نجحت العمليه",
                    iconColor: Colorss.BorderColor,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/mins.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "الخصومات",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "نجحت العمليه",
                    iconColor: Colorss.BorderColor,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/wither.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "تاريخ الرواتب",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "نجحت العمليه",
                    iconColor: Colorss.BorderColor,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/mins.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "الخصومات",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "فشلت",
                    iconColor: Colorss.BorderColor,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/wither.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "تاريخ الرواتب",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "نجحت العمليه",
                    iconColor: Colorss.BorderColor,
                  ),
                  ActivityItem(
                    imagePath: 'assets/SvgProfile/mins.png',
                    // icon: FontAwesomeIcons.rightToBracket,
                    title: "الخصومات",
                    time: "1500",
                    date: "17 أبريل 2023",
                    status: "نجحت العمليه",
                    iconColor: Colorss.BorderColor,
                  ),
                ]),
              ),
            ),

            // عنوان المعاملات
          ),
        ],
      ),
    );
  }
}
