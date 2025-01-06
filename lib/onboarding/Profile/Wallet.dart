import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wallet extends StatefulWidget {
  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String userName = '';
  String userEmail = '';
  String userProfilePicture = '';
  String position = '';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.5 - 440 / 2 - 5,
              top: -6,
              child: Container(
                width: 440,
                height: 298,
                decoration: BoxDecoration(
                  color: Color(0xFF2D13D5),
                  borderRadius: BorderRadius.circular(50),
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
            Positioned(
              top: 220,
              left: 16,
              right: 16,
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // عنصر 1
                    buildTransactionContainer(
                      imagePath: 'assets/SvgProfile/wither.png',
                      label: 'تاريخ الرواتب',
                    ),
                    // عنصر 2
                    buildTransactionContainer(
                      imagePath: 'assets/SvgProfile/broww.png',
                      label: 'طلب سلفه',
                    ),
                    // عنصر 3
                    buildTransactionContainer(
                      imagePath: 'assets/SvgProfile/mins.png',
                      label: 'الخصومات',
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              right: 0,
              left: 0,
              top: 131,
              child: Text(
                '50,000,00',
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 48,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  height: 77 / 48,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // من تاريخ 1/12/2023 إلى 1/1/2024 النص
            Positioned(
              left: 120,
              top: 203,
              child: Text(
                'من تاريخ 1/12/2023 الى 1/1/2024',
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  letterSpacing: 0.03,
                ),
                textAlign: TextAlign.right,
              ),
            ),

            // الراتب الكلى النص
            Positioned(
              right: 0,
              left: 0,
              top: 115,
              child: Text(
                'الراتب الكلى',
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 24 / 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // الصف الذي يحتوي على صورة الملف الشخصي واسم الشخص
            Positioned(
              left: 0,
              right: 0,
              top: 67,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // صورة الملف الشخصي
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
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
                  ),

                  // اسم الشخص
                  Container(
                    padding: EdgeInsets.only(
                        right: 16), // التأكد من المسافة على اليمين
                    width: 197,
                    height: 42,
                    child: Text(
                      userName,
                      style: GoogleFonts.balooBhaijaan2(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 42 / 26,
                      ),
                      textAlign:
                      TextAlign.right, // تأكد من محاذاة الاسم بشكل صحيح
                    ),
                  ),
                ],
              ),
            ),

            // قائمة المعاملات
            Positioned(
              top: 370,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // العنصر 1: طلب سلفة
                    TransactionItem(
                      amount: '1500,00',
                      type: 'طلب سلفة',
                      status: 'sucess',
                      time: 'الثلاثاء 9:20 صباحا',
                    ),
                    // العنصر 2: تاريخ الرواتب
                    TransactionItem(
                      amount: '1500,00',
                      type: 'تاريخ الرواتب',
                      status: 'Failed',
                      time: 'الثلاثاء 9:20 صباحا',
                    ),
                    // العنصر 3: الخصومات
                    TransactionItem(
                      amount: '1500,00',
                      type: 'الخصومات',
                      status: 'sucess',
                      time: 'الثلاثاء 9:20 صباحا',
                    ),
                    // العنصر 4: الراتب
                    TransactionItem(
                      amount: '1500,00',
                      type: 'الراتب',
                      status: 'sucess',
                      time: 'الثلاثاء 9:20 صباحا',
                    ),
                    // العنصر 5: الراتب
                    TransactionItem(
                      amount: '1500,00',
                      type: 'الراتب',
                      status: 'sucess',
                      time: 'الثلاثاء 9:20 صباحا',
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 258,
              top: 335,
              child: Text(
                'المعاملات',
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 24 / 15, // Line height equivalent to box height
                ),
              ),
            ),

            // العنصر الثاني (الكل)
            Positioned(
              left: 23,
              top: 335,
              child: Text(
                'الكل',
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFC2BBBB), // #C2BBBB اللون الرمادي
                  height: 16 / 10, // Line height equivalent to box height
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTransactionContainer(
      {required String imagePath, required String label}) {
    return Container(
      width: 77,
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Color(0xFFC1BBBB)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.balooBhaijaan2(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              fontSize: 10,
              height: 16 / 10,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String amount;
  final String type;
  final String status;
  final String time;

  TransactionItem({
    required this.amount,
    required this.type,
    required this.status,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // التفاصيل
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: GoogleFonts.balooBhaijaan2(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    time,
                    style: GoogleFonts.balooBhaijaan2(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              // المبلغ
              Column(
                children: [
                  Text(
                    '$amount جنيه',
                    style: GoogleFonts.balooBhaijaan2(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // الحالة
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: status == 'sucess'
                            ? Colors.white
                            : Color(0xffFFF3F3),
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        border:
                        Border.all(width: 1.5, color: Color(0xffDDDDDD))),
                    child: Text(
                      status,
                      style: GoogleFonts.balooBhaijaan2(
                        color: status == 'sucess' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          height: 0,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFE8E5FF),
              width: 1,
            ),
          ),
        ),
      ],
    );
  }
}
