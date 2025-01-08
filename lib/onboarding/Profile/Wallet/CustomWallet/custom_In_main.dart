import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
