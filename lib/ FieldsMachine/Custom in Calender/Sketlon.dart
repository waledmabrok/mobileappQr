import 'package:flutter/material.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(start: 5, end: 5, top: 10),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: screenWidth * 0.01,
          horizontal: screenWidth * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4), // shadow position
            ),
          ],
        ),
        child: Column(
          children: [
            // أول Container مع محتوى بلون وردي
            _buildSkeletonContent(screenWidth, Colors.blue.shade100),
            SizedBox(height: 10),  // المسافة بين العناصر

            // ثاني Container مع محتوى بلون ريديس (أحمر)
            _buildSkeletonContent(screenWidth, Colors.blue.shade100),
            SizedBox(height: 10),  // المسافة بين العناصر

            // ثالث Container مع محتوى بلون وردي أكثر عمقاً
            _buildSkeletonContent(screenWidth, Colors.blue.shade200),
            SizedBox(height: 10),  // المسافة بين العناصر

            // رابع Container مع محتوى بلون ريديس (أحمر)
            _buildSkeletonContent(screenWidth, Colors.blue.shade300),

          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonContent(double screenWidth, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenWidth * 0.01,
        horizontal: screenWidth * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2), // shadow position
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 80,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                  ),
                ],
              ),
              Wrap(
                spacing: 10.0,
                children: List.generate(3, (index) {
                  return Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 60,
                        height: 10,
                        color: color,
                      ),
                    ],
                  );
                }),
              ),
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color, // اللون الذي تم تحديده
                      borderRadius: BorderRadius.circular(25), // تحديد نصف الحجم لجعل الحافة دائرية
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: screenWidth * 0.05,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
