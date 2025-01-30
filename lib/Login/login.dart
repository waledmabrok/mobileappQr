import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ FieldsMachine/FieldsContext/Password.dart';
import '../ FieldsMachine/FieldsContext/Text.dart';
import '../ FieldsMachine/setup/MainColors.dart';
import '../CustomApi/ApiLogin/LoginService.dart';
import '../onboarding/navgate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _wifiName = 'إنتظر...';
  String _wifiBSSID = 'إنتظر...';
  final NetworkInfo _networkInfo = NetworkInfo();
  bool _obscurePassword = true;
  bool isLoading = false;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _formController;

  late Animation<Offset> _logoAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<Offset> _formAnimation;
  late Animation<Offset> _logoAnimationStage2;
  late Animation<Offset> _logoAnimationStage1;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void initState() {
    super.initState();
    _getWiFiInfo();
    _loadCredentials();
    // Animation controllers
    _logoController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _textController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _formController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // Define animations for logo
    _logoAnimationStage1 = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _logoAnimationStage2 = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    // Assign the initial logo animation
    _logoAnimation = _logoAnimationStage1;

    // Define animations for text and form
    _textAnimation = Tween<Offset>(
      begin: Offset(0, 200),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _formAnimation = Tween<Offset>(
      begin: Offset(0, 300),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOut),
    );

    // Start animations with delays
    Future.delayed(Duration(milliseconds: 500), () {
      _logoController.forward(); // Start logo animation
    });

    // Add listener for stage transitions
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Stage 2 for logo animation
        Future.delayed(Duration(milliseconds: 700), () {
          setState(() {
            _logoAnimation =
                _logoAnimationStage2; // Update logo animation to stage 2
            _logoController.forward(); // Repeat logo animation stage 2
          });
        });

        // Add delays for text and form animations
        Future.delayed(Duration(milliseconds: 500), () {
          _textController.forward(); // Start text animation
        });

        Future.delayed(Duration(milliseconds: 800), () {
          _formController.forward(); // Start form animation
        });
      }
    });
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('password', _passwordController.text);
  }

  // استرجاع بيانات المستخدم
  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _usernameController.text = prefs.getString('username') ?? '';
    _passwordController.text = prefs.getString('password') ?? '';
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _formController.dispose();
    super.dispose();
  }

  // Fetch Wi-Fi information
  Future<void> _getWiFiInfo() async {
    String? wifiName = await _networkInfo.getWifiName(); // Get Wi-Fi SSID
    String? wifiBSSID =
        await _networkInfo.getWifiBSSID(); // Get Wi-Fi MAC address (BSSID)

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
          return Scaffold(
            //    backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "yourcolor.net",
                                style: GoogleFonts.balooBhaijaan2(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                    fontSize: 20,
                                    color: Colorss.SecondText),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Icon(FontAwesomeIcons.earthAfrica,
                                  color: Colorss.SecondText, size: 16),
                            ],
                          )),
                        ))),
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey, // Add form key here
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SlideTransition(
                              position: _logoAnimation,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF7585ec),
                                          Color(0xFF9684E1),
                                        ],
                                        stops: [
                                          0.1667,
                                          0.6756
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Image.asset(
                                  'assets/Logo.png',
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            SlideTransition(
                              position: _textAnimation,
                              child: Center(
                                child: Text(
                                  "Your Color Team",
                                  style: GoogleFonts.balooBhaijaan2(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            SlideTransition(
                              position: _formAnimation,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                child: Column(
                                  children: [
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
                                        style: GoogleFonts.balooBhaijaan2(
                                          color: Colors.red,
                                        ),
                                      ),
                                    // Login Button
                                    Center(
                                      child: isLoading
                                          ? CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colorss.mainColor),
                                            )
                                          : SizedBox(
                                              width: 200,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFF7585ec),
                                                        Color(0xFF9684E1),
                                                      ],
                                                      stops: [
                                                        0.1667,
                                                        0.6756
                                                      ],
                                                      begin: Alignment.topRight,
                                                      end:
                                                          Alignment.bottomLeft),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 16),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    shadowColor:
                                                        Colors.transparent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      isLoading =
                                                          true; // Set loading to true
                                                    });
                                                    await _saveCredentials();
                                                    // Validate the form before attempting login
                                                    if (_formKey.currentState
                                                            ?.validate() ??
                                                        false) {
                                                      // If valid, proceed with login
                                                      await controller.login(
                                                        _usernameController
                                                            .text,
                                                        _passwordController
                                                            .text,
                                                        _wifiBSSID,
                                                      );

                                                      if (controller
                                                          .errorMessage
                                                          .isEmpty) {
                                                        // Navigate to HomeScreen after a successful login
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      HomeScreen(
                                                                        index2:
                                                                            0,
                                                                        filter:
                                                                            "All",
                                                                      )),
                                                        );
                                                      }
                                                    }
                                                    setState(() {
                                                      isLoading =
                                                          false; // Set loading to false after login attempt
                                                    });
                                                  },
                                                  child: Text(
                                                    'تسجيل الدخول',
                                                    style: GoogleFonts
                                                        .balooBhaijaan2(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
