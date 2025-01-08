import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ FieldsMachine/FieldsContext/Button.dart';
import '../../../ FieldsMachine/setup/MainColors.dart';
import 'opponent.dart';

class Wallet extends StatefulWidget {
  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
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

  void showCustomModalBottomSheet(
    BuildContext context,
    String imagePath,
  ) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              heightFactor:
                  MediaQuery.of(context).size.height > 800 ? 0.58 : 0.60,
              widthFactor: 0.97,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان والوصف
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color(0xffF9F9F9),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  imagePath,
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'طلب سلفة',
                                  style: GoogleFonts.balooBhaijaan2(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'قم بطلب سلفة الآن وسدد بالتقسيط',
                                  style: GoogleFonts.balooBhaijaan2(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff7B7D85),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                            size: 19,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18),

                    // الرقم المدخل
                    Center(
                      child: Text(
                        enteredNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.balooBhaijaan2(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 18),

                    // لوحة الأرقام باستخدام Row و Column
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildNumberButton('3', setState),
                              SizedBox(width: 10),
                              buildNumberButton('2', setState),
                              SizedBox(width: 10),
                              buildNumberButton('1', setState),
                            ],
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildNumberButton('6', setState),
                              SizedBox(width: 10),
                              buildNumberButton('5', setState),
                              SizedBox(width: 10),
                              buildNumberButton('4', setState),
                            ],
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildNumberButton('9', setState),
                              SizedBox(width: 10),
                              buildNumberButton('8', setState),
                              SizedBox(width: 10),
                              buildNumberButton('7', setState),
                            ],
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildNumberButton('<', setState),
                              SizedBox(width: 10),
                              buildNumberButton('0', setState),
                              SizedBox(width: 10),
                              buildNumberButton('.', setState),
                            ],
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.all(12),
                            width: 200,
                            height: 70,
                            child: CustomButton(
                              text: 'طلب الان',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildNumberButton(String buttonText, StateSetter setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (buttonText == '<') {
            if (enteredNumber.isNotEmpty) {
              enteredNumber =
                  enteredNumber.substring(0, enteredNumber.length - 1);
            }
          } else {
            if (enteredNumber == '0') {
              enteredNumber =
                  buttonText; // إذا كانت القيمة صفر، ابدأ من الرقم الجديد
            } else {
              enteredNumber += buttonText; // إضافة الرقم إلى الرقم المدخل
            }
          }
        });
      },
      child: Container(
        height: 55,
        width: 100,
        decoration: buttonText == '<'
            ? BoxDecoration()
            : BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
        alignment: Alignment.center,
        child: buttonText == '<'
            ? Icon(
                Icons.backspace_outlined,
                size: 24,
                textDirection: TextDirection.ltr,
              ) // عرض أيقونة الحذف
            : Text(
                buttonText,
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // الخلفية العلوية
          Positioned(
            top: -5,
            /*  left: MediaQuery
                .of(context)
                .size
                .width * 0.5 - 220,*/
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 298,
              decoration: BoxDecoration(
                color: Color(0xFF2D13D5),
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
            top: 67,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // صورة الملف الشخصي
                Padding(
                  padding: const EdgeInsets.only(left: 0.0),
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
                  padding:
                      EdgeInsets.only(left: 10), // التأكد من المسافة على اليمين
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
                    textAlign: TextAlign.left, // تأكد من محاذاة الاسم بشكل صحيح
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
                  'الراتب الكلي',
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '50,000,00',
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
          Positioned(
            top: 250,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TransactionContainer(
                  imagePath: 'assets/SvgProfile/wither.png',
                  label: 'تاريخ الرواتب',
                  onTap: () {},
                ),
                _TransactionContainer(
                  imagePath: 'assets/SvgProfile/broww.png',
                  label: 'طلب سلفه',
                  onTap: () {
                    print("open sheeeeeeeeeeeeeeeeet");
                    showCustomModalBottomSheet(
                      context,
                      'assets/SvgProfile/broww.png',
                    );
                  },
                ),
                _TransactionContainer(
                  imagePath: 'assets/SvgProfile/mins.png',
                  label: 'الخصومات',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DiscountsPage()),
                    );
                  },
                ),
                _TransactionContainer(
                  imagePath: 'assets/SvgProfile/mins.png',
                  label: 'طلب قسط',
                  onTap: () {},
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
                  children: /* List.generate(
                  5,
                  (index) => TransactionItem(
                    amount: '1500,00',
                    type: 'طلب سلفة',
                    status: index % 2 == 0 ? 'sucess' : 'Failed',
                    time: 'الثلاثاء 9:20 صباحا',
                  ),
                )*/
                      [
                    _buildActivityItem(
                      imagePath: 'assets/SvgProfile/broww.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "طلب سلفه",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BackgroundContainer,
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    _buildActivityItem(
                      imagePath: 'assets/SvgProfile/wither.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "تاريخ الرواتب",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "فشلت",
                      iconColor: Colorss.BackgroundContainer,
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    _buildActivityItem(
                      imagePath: 'assets/SvgProfile/mins.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "الخصومات",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BackgroundContainer,
                    ),
                    _buildActivityItem(
                      imagePath: 'assets/SvgProfile/broww.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "طلب سلفه",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BackgroundContainer,
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    _buildActivityItem(
                      imagePath: 'assets/SvgProfile/wither.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "تاريخ الرواتب",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "فشلت",
                      iconColor: Colorss.BackgroundContainer,
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    _buildActivityItem(
                      imagePath: 'assets/SvgProfile/mins.png',
                      // icon: FontAwesomeIcons.rightToBracket,
                      title: "الخصومات",
                      time: "1500",
                      date: "17 أبريل 2023",
                      status: "نجحت العمليه",
                      iconColor: Colorss.BackgroundContainer,
                    ),
                  ]),
            ),
          ),

          // عنوان المعاملات
          Positioned(
            right: 20,
            top: 335,
            child: Text(
              'المعاملات',
              style: GoogleFonts.balooBhaijaan2(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            left: 23,
            top: 335,
            child: Text(
              'الكل',
              style: GoogleFonts.balooBhaijaan2(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xFFC2BBBB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    /*   required IconData icon,*/
    required String title,
    required String time,
    required String date,
    required String status,
    required Color iconColor,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        /* boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],*/
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  imagePath,
                  width: 10,
                  height: 10,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.balooBhaijaan2(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    date,
                    style: GoogleFonts.balooBhaijaan2(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  status,
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
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
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFE8E5FF), width: 1),
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
              SizedBox(height: 10),
              Text(
                time,
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          // المبلغ والحالة
          Column(
            children: [
              Text(
                '$amount جنيه',
                style: GoogleFonts.balooBhaijaan2(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'sucess'
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.balooBhaijaan2(
                    color: status == 'sucess' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionContainer extends StatefulWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _TransactionContainer({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  _TransactionContainerState createState() => _TransactionContainerState();
}

class _TransactionContainerState extends State<_TransactionContainer> {
  String enteredNumber = ''; // القيمة المدخلة من المستخدم

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 77,
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Color(0xFFC1BBBB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.imagePath,
              width: 27,
              height: 27,
            ),
            SizedBox(height: 4),
            Text(
              widget.label,
              style: GoogleFonts.balooBhaijaan2(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNumberButton(String buttonText, StateSetter setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (buttonText == '<') {
            if (enteredNumber.isNotEmpty) {
              enteredNumber =
                  enteredNumber.substring(0, enteredNumber.length - 1);
            }
          } else {
            if (enteredNumber == '0') {
              enteredNumber =
                  buttonText; // إذا كانت القيمة صفر، ابدأ من الرقم الجديد
            } else {
              enteredNumber += buttonText; // إضافة الرقم إلى الرقم المدخل
            }
          }
        });
      },
      child: Container(
        height: 45,
        width: 80,
        decoration: buttonText == '<'
            ? BoxDecoration()
            : BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
        alignment: Alignment.center,
        child: buttonText == '<'
            ? Icon(
                Icons.backspace_outlined,
                size: 24,
                textDirection: TextDirection.ltr,
              ) // عرض أيقونة الحذف
            : Text(
                buttonText,
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
