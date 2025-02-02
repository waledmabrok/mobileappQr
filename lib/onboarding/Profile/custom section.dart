import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../ FieldsMachine/setup/MainColors.dart';
import 'DarkMode.dart';

class CustomFrameWidget extends StatelessWidget {
  final String title;
  final List<OptionItem> options;
  final bool showThemeSwitch;

  const CustomFrameWidget({
    Key? key,
    required this.title,
    required this.options,
    this.showThemeSwitch = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IntrinsicHeight(
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.balooBhaijaan2(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
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
                  padding: EdgeInsets.only(
                      top: showThemeSwitch ? 27 : 16,
                      bottom: 16,
                      left: 16,
                      right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...options
                          .asMap()
                          .map((index, option) {
                            return MapEntry(
                              index,
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildOption(
                                    context: context,
                                    icon: option.icon,
                                    label: option.label,
                                    color: option.color,
                                    color2: option.color2,
                                    onTap: option.onTap,
                                    isSwitch: false,
                                  ),
                                  // const SizedBox(height: 15),
                                  if (index != options.length - 1)
                                    Divider(
                                      thickness: 0.5,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant,
                                    ),
                                ],
                              ),
                            );
                          })
                          .values
                          .toList(),
                      if (showThemeSwitch)
                        _buildThemeSwitch(themeProvider, context),
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
    required Color color2,
    bool isSwitch = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: color2),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.balooBhaijaan2(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4F5464),
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Color(0xFFB6C2D7),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSwitch(ThemeProvider themeProvider, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: Theme.of(context).colorScheme.surfaceVariant,
          thickness: 0.5,
        ),
        SwitchListTile(
          // visualDensity: VisualDensity.compact,
          //dense: true,
          contentPadding: EdgeInsets.zero,
          title: Row(
            //  mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
                child: Icon(
                  Icons.dark_mode_outlined,
                  size: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "تحديد الثييم",
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4F5464),
                ),
              ),
            ],
          ),
          value: themeProvider.themeMode == ThemeMode.dark,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },

          activeColor: Colorss.mainColor,
          controlAffinity: ListTileControlAffinity.trailing,
          //  activeTrackColor: Colors.black,
          inactiveThumbColor: Colors.grey.shade400,

          inactiveTrackColor: Theme.of(context).colorScheme.inverseSurface,
          //thumbColor: WidgetStatePropertyAll(Colors.white),
          overlayColor: WidgetStatePropertyAll(Colors.white),
          trackOutlineColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.surfaceVariant),
        ),
      ],
    );
  }
}

class OptionItem {
  final IconData icon;
  final String label;
  final Color color;
  final Color color2;
  final VoidCallback onTap;

  const OptionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.color2,
    required this.onTap,
  });
}
