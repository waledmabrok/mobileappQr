import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscountItem extends StatelessWidget {
  final String amount;
  final String label;
  final String date;
  final String iconPath;
  final VoidCallback onTap;

  const DiscountItem({
    required this.amount,
    required this.label,
    required this.date,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 16,
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.balooBhaijaan2(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          amount,
                          style: GoogleFonts.balooBhaijaan2(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Spacer(),
                        Text(
                          date,
                          style: GoogleFonts.balooBhaijaan2(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 7.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE3E1E1), width: 0.5),
          borderRadius: BorderRadius.circular(7.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFF1F6FA),
              child: Image.asset(
                iconPath,
                width: 20,
                height: 20,
              ),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 7.0),
                Text(
                  date,
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999AB4),
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFE42F45),
                  ),
                ),
                SizedBox(height: 0.0),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 12,
                      color: Color(0xFF999AB4),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "تفاصيل",
                      style: GoogleFonts.balooBhaijaan2(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999AB4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
