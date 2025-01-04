import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFrameWidget extends StatelessWidget {
  final String title;
  final List<OptionItem> options;

  const CustomFrameWidget({
    Key? key,
    required this.title,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    IntrinsicHeight(
          child: Container(
          width: double.infinity,
            padding: const EdgeInsets.only(top: 16,right: 16,left: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.balooBhaijaan2(

                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: -0.5,
                    color: Color(0xFF344054),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: options.map((option) {
                        return Column(
                          children: [
                            _buildOption(
                              icon: option.icon,
                              label: option.label,
                              color: option.color,
                              onTap: option.onTap,
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style:  GoogleFonts.balooBhaijaan2(

                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4F5464),
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFB6C2D7),
          ),
        ],
      ),
    );
  }
}

class OptionItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const OptionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
