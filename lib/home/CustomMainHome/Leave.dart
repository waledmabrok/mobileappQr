import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ FieldsMachine/setup/MainColors.dart';

class LeaveCard extends StatelessWidget {
  final String requestType; // نوع الطلب (إجازة، سلفة، إذن خروج)
  final String requestTitle; // العنوان (مثلاً: طلب إجازة + التاريخ)
  final String status; // الحالة (بانتظار المراجعة، مرفوض، مقبول)
  final Map<String, String> details; // التفاصيل المختلفة حسب النوع

  LeaveCard({
    required this.requestType,
    required this.requestTitle,
    required this.status,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Row

        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // العنوان والحالة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    requestTitle,
                    style: GoogleFonts.balooBhaijaan2(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildStatusLabel(status), // الحالة
                ],
              ),
              SizedBox(height: 10),
              Divider(thickness: 1, color: Colors.grey[300]),
              SizedBox(height: 8),

              // التفاصيل
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailColumn(
                    details['detail1Label'] ?? '',
                    details['detail1Value'] ?? '',
                  ),
                  _buildDetailColumn(
                    details['detail2Label'] ?? '',
                    details['detail2Value'] ?? '',
                  ),
                  _buildDetailColumn(
                    "الموافقة بواسطة",
                    status == "المراجعة" ? '-' : (details['approvedBy'] ?? ''),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // بناء حالة الطلب
  Widget _buildStatusLabel(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case "مقبول":
        bgColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green;
        break;
      case "مرفوض":
        bgColor = Colors.red.withOpacity(0.2);
        textColor = Colors.red;
        break;
      case "المراجعة":
        bgColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange;
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.balooBhaijaan2(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // بناء تفاصيل الأعمدة
  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.balooBhaijaan2(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.balooBhaijaan2(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
