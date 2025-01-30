import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ FieldsMachine/setup/MainColors.dart';
import '../../../MainHome/CustomFilter.dart';
import '../../navgate.dart';
import 'CustomWallet/ListDiscount.dart';

class DiscountsPage extends StatefulWidget {
  static const routeName = "/Discounts_Page";

  @override
  State<DiscountsPage> createState() => _DiscountsPageState();
}

class _DiscountsPageState extends State<DiscountsPage> {
  String userName = '';
  String userProfilePicture = '';

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'غير معروف'; // استرجاع الاسم
      userProfilePicture =
          prefs.getString('user_profile_picture') ?? ''; // استرجاع الصورة
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          /*     SliverAppBar(
            foregroundColor: Colors.transparent,
            pinned: true,
            automaticallyImplyLeading: false,
            forceMaterialTransparency: false,
            shadowColor: Colors.white,
            forceElevated: false,
            toolbarHeight: 80,
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 2,
            flexibleSpace: Padding(
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
                  Text(
                    "اهلا ${userName}  ",
                    style: GoogleFonts.balooBhaijaan2(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 1),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),*/
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
          /*   SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 15, right: 15, bottom: 30),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 3),
                          ),
                        );
                      },
                      iconPath: "assets/SvgProfile/wallet-svgrepo-com.svg",
                      // مسار الأيقونة
                      label: 'المحفظه', // النص الذي يظهر أسفل الأيقونة
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 3),
                          ),
                        );
                      },
                      iconPath: "assets/SvgNotifi/wallet-svgrepo-com.svg",
                      // مسار الأيقونة
                      label: 'طلب سلفه', // النص الذي يظهر أسفل الأيقونة
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 3),
                          ),
                        );
                      },
                      iconPath:
                          "assets/SvgProfile/wallet-receive-svgrepo-com2.svg",
                      // مسار الأيقونة
                      label: ' الرواتب', // النص الذي يظهر أسفل الأيقونة
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 3),
                          ),
                        );
                      },
                      iconPath:
                          "assets/SvgProfile/wallet-minus-svgrepo-com.svg",
                      // مسار الأيقونة
                      label: 'الخصومات', // النص الذي يظهر أسفل الأيقونة
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 0),
                          ),
                        );
                      },
                      iconPath: "assets/SvgNavbar/Notifi.svg", // مسار الأيقونة
                      label: 'الاشعارات', // النص الذي يظهر أسفل الأيقونة
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    CustomNotificationWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(index2: 0),
                          ),
                        );
                      },
                      iconPath:
                          "assets/SvgNavbar/Calender.svg", // مسار الأيقونة
                      label: 'المحفظه', // النص الذي يظهر أسفل الأيقونة
                    ),
                  ],
                ),
              ),
            ),
          ),*/

          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xfff8f8f8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15.0, top: 5, left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/SvgProfile/mins.png',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'الخصومات',
                                  style: GoogleFonts.balooBhaijaan2(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // العنصر الأول
                          DiscountItem(
                            amount: '-50,00',
                            label: 'خصم تاخير',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/SvgProfile/mins.png',
                            onTap: () {},
                          ),
                          // العنصر الثاني
                          DiscountItem(
                            amount: '-1200,00',
                            label: 'طلب سلفة',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/Calender/money.png',
                            onTap: () {},
                          ),
                          // العنصر الثالث
                          DiscountItem(
                            amount: '-100,00',
                            label: 'طلب سحب',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/SvgProfile/broww.png',
                            onTap: () {},
                          ),
                          // العنصر الرابع
                          DiscountItem(
                            amount: '-50,00',
                            label: 'طلب قسط',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/SvgProfile/wither.png',
                            onTap: () {},
                          ),
                          DiscountItem(
                            amount: '-50,00',
                            label: 'خصم تاخير',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/SvgProfile/mins.png',
                            onTap: () {},
                          ),
                          // العنصر الثاني
                          DiscountItem(
                            amount: '-1200,00',
                            label: 'طلب سلفة',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/Calender/money.png',
                            onTap: () {},
                          ),
                          // العنصر الثالث
                          DiscountItem(
                            amount: '-100,00',
                            label: 'طلب سحب',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/SvgProfile/broww.png',
                            onTap: () {},
                          ),
                          // العنصر الرابع
                          DiscountItem(
                            amount: '-50,00',
                            label: 'طلب قسط',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/SvgProfile/wither.png',
                            onTap: () {},
                          ),
                          DiscountItem(
                            amount: '-50,00',
                            label: 'خصم تاخير',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/SvgProfile/mins.png',
                            onTap: () {},
                          ),
                          // العنصر الثاني
                          DiscountItem(
                            amount: '-1200,00',
                            label: 'طلب سلفة',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/Calender/money.png',
                            onTap: () {},
                          ),
                          // العنصر الثالث
                          DiscountItem(
                            amount: '-100,00',
                            label: 'طلب سحب',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/SvgProfile/broww.png',
                            onTap: () {},
                          ),
                          // العنصر الرابع
                          DiscountItem(
                            amount: '-50,00',
                            label: 'طلب قسط',
                            date: '16 يوليو 2024',
                            iconPath: 'assets/SvgProfile/wither.png',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
