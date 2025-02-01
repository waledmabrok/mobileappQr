import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ FieldsMachine/FieldsContext/Button.dart';
import '../../../ FieldsMachine/setup/MainColors.dart';
import '../../../CustomNavbar/Drawer.dart';
import '../../../CustomNavbar/customnav.dart';
import '../../navgate.dart';
import 'Alltrasaction.dart';
import 'CustomWallet/CustomAlltransaction.dart';
import 'CustomWallet/container_widget_center.dart';
import 'CustomWallet/sheetNumber.dart';
import 'opponent.dart';

class Wallet extends StatefulWidget {
  static const routeName = "/My_wallet";

  @override
  State<Wallet> createState() => _WalletState();
}

final _advancedDrawerController = AdvancedDrawerController();

class _WalletState extends State<Wallet> {
  String userName = '';
  String userEmail = '';
  String userProfilePicture = '';
  String position = '';
  String enteredNumber = '';
  String user_position = '';

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

  void showCustomModalBottomSheet(BuildContext context,
      String imagePath,
      String head,) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return CustomModalBottomSheet(
          imagePath: imagePath,
          head: head,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomAdvancedDrawer(
      controller: _advancedDrawerController,
      child: Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .surfaceVariant,
        body: Stack(
          children: [
            // الخلفية العلوية
            Positioned(
              top: -5,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 298,
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            // معلومات المستخدم
            Positioned(
              left: 0,
              right: 10,
              top: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // صورة الملف الشخصي
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // الصورة
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 2),
                            image: DecorationImage(
                              image: NetworkImage(userProfilePicture.isNotEmpty
                                  ? userProfilePicture
                                  : 'image.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // مسافة بين الصورة والنص
                        // النصوص (الاسم والوظيفة)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // الاسم
                            Text(
                              userName,
                              style: GoogleFonts.balooBhaijaan2(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            // الوظيفة
                            Text(
                              position,
                              style: GoogleFonts.balooBhaijaan2(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colorss.BorderColor)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // الراتب الكلي
            Positioned(
              top: 115,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  Text(
                    'الرصيد المتاح',
                    style: GoogleFonts.balooBhaijaan2(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '1,000,00',
                    style: GoogleFonts.balooBhaijaan2(
                      fontSize: 48,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'من تاريخ 1/12/2023 الى 1/1/2024',
                    style: GoogleFonts.balooBhaijaan2(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // الخيارات
            /*    Positioned(
              top: 250,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TransactionContainer(
                    imagePath: 'assets/SvgProfile/wither.png',
                    label: 'تاريخ الرواتب',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => transactionAll()),
                      );
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  TransactionContainer(
                    imagePath: 'assets/SvgProfile/broww.png',
                    label: 'طلب سلفه',
                    onTap: () {
                      print("open sheeeeeeeeeeeeeeeeet");
                      showCustomModalBottomSheet(
                          context, 'assets/SvgProfile/broww.png', "طلب سلفة");
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  TransactionContainer(
                    imagePath: 'assets/SvgProfile/mins.png',
                    label: 'الخصومات',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DiscountsPage()),
                      );
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  TransactionContainer(
                    imagePath: 'assets/SvgProfile/mins.png',
                    label: 'طلب قسط',
                    onTap: () {
                      showCustomModalBottomSheet(
                          context, 'assets/SvgProfile/mins.png', "طلب قسط");
                    },
                  ),
                ],
              ),
            ),*/
            // قائمة المعاملات
            Positioned(
              top: 370,
              left: 20,
              right: 20,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(children: [
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
            Positioned(
              right: 30,
              top: 335,
              child: Text(
                'المعاملات',
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onPrimary,
                ),
              ),
            ),
            Positioned(
              left: 30,
              top: 335,
              child: InkWell(
                overlayColor: WidgetStatePropertyAll(Colors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => transactionAll()),
                  );
                },
                child: Text(
                  'الكل',
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFC2BBBB),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: SizedBox(
                height: 70,
                child: CustomBottomNavBar(
                  selectedIndex: 4,
                  onItemTapped: (p0) {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
