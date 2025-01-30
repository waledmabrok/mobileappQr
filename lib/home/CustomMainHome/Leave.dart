import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ FieldsMachine/setup/MainColors.dart';

class LeaveCard extends StatelessWidget {
  final String requestType;
  final String requestTitle;
  final String status;
  final Map<String, String> details;

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
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "طلب",
                        style: GoogleFonts.balooBhaijaan2(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        requestTitle,
                        style: GoogleFonts.balooBhaijaan2(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusLabel(status), // الحالة
                ],
              ),
              SizedBox(height: 7),
              Divider(thickness: 0.5, color: Colors.grey[300]),
              SizedBox(height: 7),

              // التفاصيل
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailColumn(
                    context,
                    details['detail1Label'] ?? '',
                    details['detail1Value'] ?? '',
                  ),
                  _buildDetailColumn(
                    context,
                    details['detail2Label'] ?? '',
                    details['detail2Value'] ?? '',
                  ),
                  _buildDetailColumn(
                    context,
                    "المسئول",
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
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

  Widget _buildDetailColumn(BuildContext context, String label, String value) {
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
        SizedBox(height: 10),
        Text(
          value,
          style: GoogleFonts.balooBhaijaan2(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
