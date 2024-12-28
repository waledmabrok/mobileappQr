import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusColumn extends StatelessWidget {
  final String status;

  const StatusColumn({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 4),
        Text(
          status.length > 6 ? status.substring(0, 10) : status, // تقليص النص إلى 6 حروف
          style: GoogleFonts.balooBhaijaan2(
            color: status == 'Absent'
                ? Colors.red
                : (status == 'Early Leave'
                ? Colors.orange
                : Colors.green),
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis, // إضافة النقط (...) في حالة زيادة النص
          maxLines: 1, // لضمان ظهور النص في سطر واحد فقط
        )

      ],
    );
  }
}