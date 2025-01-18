import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionContainer extends StatefulWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const TransactionContainer({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  TransactionContainerState createState() => TransactionContainerState();
}

class TransactionContainerState extends State<TransactionContainer> {
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
          border: Border.all(
            color: const Color(0xffe9e9ea),
            width: 0.50,
          ),
          borderRadius: BorderRadius.circular(10.0),
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
