import 'package:flutter/material.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsetsDirectional.only(start: 5, end: 5, top: 10),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: screenWidth * 0.01,
          horizontal: screenWidth * 0.01,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(12),
          /*  boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4), // shadow position
            ),
          ],*/
        ),
        child: Column(
          children: [
            _buildSkeletonContent(context, screenWidth, Colors.grey.shade100),
            SizedBox(height: 10),
            _buildSkeletonContent(context, screenWidth, Colors.grey.shade100),
            SizedBox(height: 10),
            _buildSkeletonContent(context, screenWidth, Colors.grey.shade200),
            SizedBox(height: 10),
            // _buildSkeletonContent(context, screenWidth, Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonContent(
      BuildContext context, double screenWidth, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenWidth * 0.01,
        horizontal: screenWidth * 0.01,
      ),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.inverseSurface),
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.04), // إضافة مسافة بين العناصر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            }),
          ),
          SizedBox(height: screenWidth * 0.05),
        ],
      ),
    );
  }
}
