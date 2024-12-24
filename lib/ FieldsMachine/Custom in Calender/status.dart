import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          status,
          style: TextStyle(
            color: status == 'Absent'
                ? Colors.red
                : (status == 'Early Leave'
                ? Colors.orange
                : Colors.green),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}