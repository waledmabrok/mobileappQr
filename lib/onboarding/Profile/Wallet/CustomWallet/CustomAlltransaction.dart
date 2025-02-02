import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String time;
  final String date;
  final String status;
  final Color iconColor;
  final String imagePath;
  final bool bottom;

  const ActivityItem({
    Key? key,
    required this.title,
    required this.time,
    required this.date,
    required this.status,
    required this.iconColor,
    required this.imagePath,
    this.bottom = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: bottom
            ? Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300, // Border color
                  width: 0.5, // Border width
                ),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  color: Theme.of(context).colorScheme.onPrimary,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: status == 'نجحت العمليه'
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 2.0),
                    child: Text(
                      status,
                      style: GoogleFonts.balooBhaijaan2(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: status == 'نجحت العمليه'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
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
