import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// تأكد من مسار ملف الثيم

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider({required ThemeMode initialMode}) : _themeMode = initialMode;

  void toggleTheme() {
    _themeMode =
        (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(_themeMode);
    notifyListeners();
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", mode == ThemeMode.dark);
  }
}

class ThemeSwitcherScreen extends StatelessWidget {
  static const routeName = "/darkMode";

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "تغيير الثيم",
          style: GoogleFonts.balooBhaijaan2(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SwitchListTile(
          activeColor: Colors.blue,
          // لون الزر عند التفعيل
          inactiveThumbColor: Colors.black,
          inactiveTrackColor: Colors.grey[300],
          title: Text(
            "تفعيل الوضع ",
            style: GoogleFonts.balooBhaijaan2(),
          ),
          value: themeProvider.themeMode == ThemeMode.dark,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
        ),
      ),
    );
  }
}
