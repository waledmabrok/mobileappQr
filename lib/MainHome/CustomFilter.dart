import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../ FieldsMachine/setup/MainColors.dart';

class CustomNotificationWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String? iconPath;
  final String? label;
  final bool? isSelected;

  const CustomNotificationWidget({
    Key? key,
    required this.onTap,
    this.iconPath,
    this.label,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected!
              ? Colorss.mainColor
              : Theme.of(context).colorScheme.background,
          border: label != null && label!.isNotEmpty
              ? Border.all(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  width: 0.40,
                )
              : null,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null && iconPath!.isNotEmpty)
              SvgPicture.asset(
                iconPath!,
                width: 24,
                height: 24,
                color: isSelected!
                    ? Colors.white
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            if (label != null && label!.isNotEmpty) const SizedBox(height: 10),
            if (label != null && label!.isNotEmpty)
              Center(
                child: Text(
                  label!,
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isSelected!
                        ? Colors.white
                        : Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomNotificationWidgetRow extends StatelessWidget {
  final VoidCallback onTap;
  final String? iconPath;
  final String? label;
  final bool? isSelected;

  const CustomNotificationWidgetRow({
    Key? key,
    required this.onTap,
    this.iconPath,
    this.label,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: onTap,
      child: Container(
        //  padding: EdgeInsets.all(10),
        width: double.infinity, // لملء العرض بالكامل
        decoration: BoxDecoration(
          border: label != null && label!.isNotEmpty
              ? Border.fromBorderSide(BorderSide.none)
              : null,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (iconPath != null && iconPath!.isNotEmpty)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white),
                child: SvgPicture.asset(
                  iconPath!,
                  width: 24,
                  height: 24,
                  color: isSelected!
                      ? Colors.white
                      : Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            if (label != null && label!.isNotEmpty) const SizedBox(width: 10),
            // الخط المنقط بين الأيقونة والنص
            if (iconPath != null && iconPath!.isNotEmpty)
              const VerticalDivider(
                width: 10,
                thickness: 1,
                color: Colors.grey,
                indent: 5,
                endIndent: 5,
              ),
            if (label != null && label!.isNotEmpty)
              Text(
                label!,
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isSelected!
                      ? Colors.white
                      : Theme.of(context).colorScheme.onPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
