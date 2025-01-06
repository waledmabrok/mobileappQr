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
    Color backgroundColor = Colors.green.withOpacity(0.2); // لون افتراضي خفيف
    if (status == 'Absent') {
      backgroundColor = Colors.red.withOpacity(0.2);
    } else if (status == 'Early Leave') {
      backgroundColor = Colors.orange.withOpacity(0.2);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            //border: Border.all(color: Color(0xffd1d1d1), width: 1),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 8, top: 3, bottom: 3),
            child: Text(
              status.length > 6
                  ? status.substring(0, 10)
                  : status, // تقليص النص إلى 6 حروف
              style: GoogleFonts.balooBhaijaan2(
                  color: status == 'Absent'
                      ? Colors.red
                      : (status == 'Early Leave'
                          ? Colors.orange
                          : Colors.green),
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
              overflow:
                  TextOverflow.ellipsis, // إضافة النقط (...) في حالة زيادة النص
              maxLines: 1, // لضمان ظهور النص في سطر واحد فقط
            ),
          ),
        )
      ],
    );
  }
}
