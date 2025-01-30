import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wfi_details/onboarding/Profile/ChangePasswors.dart';
import 'package:wfi_details/onboarding/Profile/Wallet/Alltrasaction.dart';
import 'package:wfi_details/onboarding/Profile/Wallet/Wallet.dart';
import 'package:wfi_details/onboarding/Request_money/Request_money_main.dart';
import 'package:wfi_details/onboarding/Requests_Main/Requests.dart';
import 'package:wfi_details/onboarding/Statistics/StatisticsMain.dart';
import 'package:wfi_details/onboarding/Summary/main_Summary.dart';
import 'package:wfi_details/onboarding/home1.dart';
import 'package:wfi_details/themes.dart';
import 'Login/login.dart';
import 'Request permission/Request_permission.dart';
import 'Request permission/Requst-Permission_Main.dart';
import 'onboarding/Activities/Main_Activities.dart';
import 'onboarding/Profile/DarkMode.dart';
import 'onboarding/Profile/Wallet/opponent.dart';
import 'onboarding/Request_money/Request_money_2.dart';
import 'onboarding/Summary/Sammary1.dart';
import 'onboarding/navgate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تحميل الثيم المحفوظ من SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool("isDarkMode") ?? false; // تحميل الثيم المحفوظ

  // تشغيل التطبيق بعد تحميل الثيم
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(
          initialMode: isDarkMode ? ThemeMode.dark : ThemeMode.light),
      child: MyApp(),
    ),
  );

  // إعدادات شريط الحالة
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // شفافية شريط الحالة
      statusBarIconBrightness: Brightness.dark, // أيقونات بيضاء
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(),
            '/Navbar': (context) => HomeScreen(),
            '/statistic': (context) => PieChartSample2(),
            '/summary': (context) => MainSummary(),
            '/permission': (context) => PermissionRequestMain(),
            '/requst_money': (context) => Request_money_Main(),
            '/All_requests': (context) => RequestsMain(),
            '/request_summary': (context) => LeaveRequestPage(),
            '/request_money2': (context) => LoanRequestPage(),
            '/Main_Activity': (context) => Main_Activities(),
            '/all_transaction': (context) => transactionAll(),
            '/My_wallet': (context) => Wallet(),
            '/Discounts_Page': (context) => DiscountsPage(),
            '/request_Premission2': (context) => PermissionRequestPage(),
            '/attendance': (context) => AttendanceScreen(),
            '/change_password': (context) => changePassword(),
            '/darkMode': (context) => ThemeSwitcherScreen(),
          },
          debugShowCheckedModeBanner: false,
          locale: Locale('ar', 'AE'),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('ar', 'AE'),
          ],
          themeMode: themeProvider.themeMode,
          // استخدام الثيم المحمل من ThemeProvider
          theme: ThemeClass.lightTheme,
          darkTheme: ThemeClass.darkTheme,
        );
      },
    );
  }
}
