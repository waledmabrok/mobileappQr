import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ FieldsMachine/FieldsContext/Password.dart';
import '../ FieldsMachine/FieldsContext/Text.dart';
import '../ FieldsMachine/setup/MainColors.dart';
import '../CustomApi/ApiLogin/LoginService.dart';
import '../onboarding/navgate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:network_info_plus/network_info_plus.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _wifiName = 'إنتظر...';
  String _wifiBSSID = 'إنتظر...';
  final NetworkInfo _networkInfo = NetworkInfo();
  bool _obscurePassword = true;
  bool isLoading = false;
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void initState() {
    super.initState();
    _getWiFiInfo();
  }

  // Fetch Wi-Fi information
  Future<void> _getWiFiInfo() async {
    String? wifiName = await _networkInfo.getWifiName(); // Get Wi-Fi SSID
    String? wifiBSSID = await _networkInfo.getWifiBSSID(); // Get Wi-Fi MAC address (BSSID)

    setState(() {
      _wifiName = wifiName ?? 'غير متصل';
      _wifiBSSID = wifiBSSID ?? 'غير متصل';
    });

    print('Wi-Fi Name: $_wifiName');
    print('Wi-Fi MAC (BSSID): $_wifiBSSID');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Consumer<LoginController>(
        builder: (context, controller, _) {
          return Scaffold(backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Center(
              child: SingleChildScrollView(

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey, // Add form key here
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        SvgPicture.asset(
                          'assets/Logo.svg',
                          height: 100,
                          width: 100,
                        ),

                        SizedBox(height: 50),
                        Center(
                          child: Text(
                            "من فضلك ادخل البيانات",
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              //fontFamily: 'BalooBhaijaan2',
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        // Username input with validator
                        CustomText(

                          isRequired: true,
                          controller: _usernameController,
                        ),
                        SizedBox(height: 25),
                        // Password input with validator
                        CustomPassword(
                          isRequired: true,
                          controller: _passwordController,
                        ),

                        SizedBox(height: 40),
                        if (controller.errorMessage.isNotEmpty)
                          Text(
                            controller.errorMessage,
                            style:GoogleFonts.cairo(color: Colors.red,),
                          ),
                        // Login Button
                        Center(
                          child:
                          isLoading
                              ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colorss.mainColor),
                          )
                              : SizedBox(
                            width: 200,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF7557e4),
                                    Color(0xFF7585ec),
                                  ],
                                  stops: [0.3, 1.2],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;  // Set loading to true
                                  });
                                  // Validate the form before attempting login
                                  if (_formKey.currentState?.validate() ?? false) {
                                    // If valid, proceed with login
                                    await controller.login(
                                      _usernameController.text,
                                      _passwordController.text,
                                        _wifiBSSID,

                                    );

                                    if (controller.errorMessage.isEmpty) {
                                      // Navigate to HomeScreen after a successful login
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeScreen(index2: 0,filter: "All",)),
                                      );
                                    }
                                  }
                                  setState(() {
                                    isLoading = false;  // Set loading to false after login attempt
                                  });
                                },
                                child:  Text(
                                  'تسجيل الدخول',
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
