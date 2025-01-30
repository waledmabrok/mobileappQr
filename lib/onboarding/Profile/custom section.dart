import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'DarkMode.dart';

class CustomFrameWidget extends StatelessWidget {
  final String title;
  final List<OptionItem> options;
  final bool showThemeSwitch; // إضافة متغير لتحديد إذا كان يجب إظهار السويتش

  const CustomFrameWidget({
    Key? key,
    required this.title,
    required this.options,
    this.showThemeSwitch = false, // افتراضيًا مخفي
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        IntrinsicHeight(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
            decoration: BoxDecoration(
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
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...options.map((option) {
                        return Column(
                          children: [
                            _buildOption(
                              icon: option.icon,
                              label: option.label,
                              color: option.color,
                              onTap: option.onTap,
                              isSwitch: false, // الخيارات العادية بدون سويتش
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      }).toList(),
                      if (showThemeSwitch)
                        _buildThemeSwitch(themeProvider), // إضافة السويتش
                    ],
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
    bool isSwitch = false,
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
              style: GoogleFonts.balooBhaijaan2(
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

  Widget _buildThemeSwitch(ThemeProvider themeProvider) {
    return SwitchListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(
        "تحديد الثييم",
        style: GoogleFonts.balooBhaijaan2(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Color(0xFF4F5464),
        ),
      ),
      value: themeProvider.themeMode == ThemeMode.dark,
      onChanged: (value) {
        themeProvider.toggleTheme();
      },
      activeColor: Colors.blue,
      // لون الزر عند التفعيل

      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Colors.grey[300],
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
