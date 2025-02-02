import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import ' FieldsMachine/setup/MainColors.dart';
// Replace with the actual path to your Colorss class

class ThemeClass {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colorss.primaryColor,
    scaffoldBackgroundColor: Colorss.backgroundLight,
    colorScheme: ColorScheme.light(
      primary: Colorss.primaryColor,
      secondary: Colorss.secondaryColor,
      background: Colorss.backgroundLight,
      surface: Colorss.accentLight,
      onPrimary: Colorss.textPrimaryLight,
      onSecondary: Colorss.textSecondaryLight,
      onBackground: Colorss.textPrimaryLight,
      onSurface: Colorss.textSecondaryLight,
      surfaceVariant: Colorss.ContainerLight,
      inverseSurface: Colorss.borderLight,
      secondaryContainer: Colorss.highlightColor,
      // خلفية التحديد
      onSecondaryContainer: Colors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.balooBhaijaan2(color: Colors.black),
      bodySmall: GoogleFonts.balooBhaijaan2(color: Colorss.textPrimaryLight),
      bodyMedium: GoogleFonts.balooBhaijaan2(color: Colors.black),
      headlineMedium:
          GoogleFonts.balooBhaijaan2(color: Colorss.textPrimaryLight),
    ),
    appBarTheme: AppBarTheme(
      color: Colorss.primaryColor,
      iconTheme: IconThemeData(color: Colorss.iconColor),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colorss.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: IconThemeData(color: Colorss.iconColor),
    dividerColor: Colorss.borderLight,
    shadowColor: Colorss.shadowColor,
    highlightColor: Colorss.highlightColor,
    splashColor: Colorss.splashColor,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colorss.primaryColorDark,
    scaffoldBackgroundColor: Colorss.backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: Colorss.primaryColorDark2,
      secondary: Colorss.secondaryColorDark,
      background: Colorss.backgroundDark,
      surface: Colorss.accentDark,
      onPrimary: Colorss.textPrimaryDark,
      onSecondary: Colorss.textSecondaryDark,
      onBackground: Colorss.textPrimaryDark,
      onSurface: Colorss.textSecondaryDark,
      surfaceVariant: Colorss.ContainerDark,
      inverseSurface: Colorss.borderDark,
      secondaryContainer: Colorss.primaryColorDark2,
      onSecondaryContainer: Colors.white,
    ),
    textTheme: TextTheme(
      bodySmall: GoogleFonts.balooBhaijaan2(color: Colorss.textPrimaryDark),
      bodyMedium: GoogleFonts.balooBhaijaan2(color: Colorss.textSecondaryDark),
      bodyLarge: GoogleFonts.balooBhaijaan2(color: Colorss.textSecondaryDark),
      headlineMedium:
          GoogleFonts.balooBhaijaan2(color: Colorss.textPrimaryDark),
    ),
    appBarTheme: AppBarTheme(
      color: Colorss.primaryColorDark,
      iconTheme: IconThemeData(color: Colorss.iconColor),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colorss.primaryColorDark,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: IconThemeData(color: Colorss.iconColor),
    dividerColor: Colorss.borderDark,
    shadowColor: Colorss.shadowColor,
    highlightColor: Colorss.highlightColor,
    splashColor: Colorss.splashColor,
  );
}
