import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../ FieldsMachine/FieldsContext/Button.dart';

class CustomModalBottomSheet extends StatefulWidget {
  final String imagePath;
  final String head;

  const CustomModalBottomSheet({
    Key? key,
    required this.imagePath,
    required this.head,
  }) : super(key: key);

  @override
  _CustomModalBottomSheetState createState() => _CustomModalBottomSheetState();
}

class _CustomModalBottomSheetState extends State<CustomModalBottomSheet> {
  String enteredNumber = ''; // للحفاظ على الرقم المدخل

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
        width: 91,
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
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return FractionallySizedBox(
          heightFactor: MediaQuery.of(context).size.height > 800 ? 0.6 : 0.60,
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
                              widget.imagePath,
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
                              widget.head,
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
                        padding: EdgeInsets.all(5),
                        width: 200,
                        height: 60,
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
  }
}
