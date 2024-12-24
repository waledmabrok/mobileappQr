
// Custom widget for the divider row
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DividerRow extends StatelessWidget {
  const DividerRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(30, (index) {
          return Container(
            width: 6,
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            // المسافة بين الشرطات
            color: Colors.blueGrey,
          );
        }),
      ),
    );
  }
}




