import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Login/login.dart';
import 'onboarding/navgate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      locale: Locale('ar', 'AE'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', 'AE'),
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.blue, // لون المؤشر
          selectionColor: Colors.blue.withOpacity(0.4),
          selectionHandleColor: Colors.blue,
        ),
      ),
    );
  }
}
