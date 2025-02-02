import 'dart:async';
import 'dart:io';
import 'dart:ui' as flutter;
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../ FieldsMachine/CustomSnackBar/Snackbar.dart';
import '../ FieldsMachine/setup/MainColors.dart';
import '../CustomNavbar/Drawer.dart';
import '../CustomNavbar/customnav.dart';
import 'package:geocoding/geocoding.dart';

class AttendanceScreen extends StatefulWidget {
  static const routeName = "/attendance";

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String city = "جار التحميل...";
  String country = "Loading...";
  String buttonText = 'تسجيل حضور';
  bool isAttendanceStarted = false;
  DateTime? startTime;
  DateTime? endTime;
  bool isCheckedIn = true;
  Duration elapsedTime = Duration.zero;
  String userName = '';
  String userProfilePicture = '';
  final _advancedDrawerController = AdvancedDrawerController();
  bool _isRequestingPermission = false;

  /// Variables for location and Wi-Fi checking
  static const targetLatitude = 30.580996;
  static const double targetLongitude = 31.4904367;
  static const double allowedDistance = 15;
  static const requiredWifiName = '"ElBoshy"';
  Timer? _timer;
  final ValueNotifier<bool> isFinishedNotifier = ValueNotifier(false);

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  bool isSwipeVisible = false;
  bool isFinished = false;
  bool _isRequestInProgress = false;

  StreamController<bool> _wifiController = StreamController<bool>();
  StreamController<bool> _locationController = StreamController<bool>();

  // Variables for location and Wi-Fi checking
  bool isLocationPermissionGranted = false;
  bool isWifiConnected = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkLocationPermission();
    _startBackgroundTasks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLocationPermissionGranted) {
        _checkLocationInBackground();
      }
      _checkLocationPermission();
      _checkWifiInBackground();
    });
  }

  void _startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (isCheckedIn) {
          setState(() {
            elapsedTime = DateTime.now().difference(startTime!);
          });
        } else {
          _stopTimer();
        }
      });
    }
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'غير معروف';
      userProfilePicture = prefs.getString('user_profile_picture') ?? '';
    });
  }

  // Check if location permission is granted
  void _checkLocationPermission() async {
    // التحقق من حالة الإذن الحالية
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      setState(() {
        isLocationPermissionGranted = true;
      });
      print('تم منح إذن الموقع بالفعل');
      return;
    }

    if (status.isDenied || status.isLimited) {
      // طلب الإذن إذا لم يكن ممنوحًا
      PermissionStatus newStatus = await Permission.location.request();

      if (newStatus.isGranted) {
        setState(() {
          isLocationPermissionGranted = true;
        });
        print('تم منح إذن الموقع');
      } else {
        _showLocationDialog();
      }
    } else if (status.isPermanentlyDenied) {
      // إذا تم رفض الإذن بشكل دائم، عرض تنبيه للمستخدم
      _showLocationDialog();
    }
  }

// دالة لإظهار رسالة تنبيه للمستخدم
  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("إذن الموقع مطلوب"),
          content: Text(
              "يجب عليك تفعيل الموقع لاستخدام هذه الميزة. يمكنك تفعيل الإذن من إعدادات التطبيق."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // فتح إعدادات التطبيق
                Navigator.of(context).pop();
              },
              child: Text("فتح الإعدادات"),
            ),
          ],
        );
      },
    );
  }

  // Start background tasks for checking location and wifi
  void _startBackgroundTasks() {
    // Check location and Wi-Fi every minute
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isLocationPermissionGranted) {
        _checkLocationInBackground();
      }
      _checkWifiInBackground();
    });
  }

  // Check if the device is within a specific location
  void _checkLocationInBackground() async {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) async {
      if (!mounted) return;
      double distance = Geolocator.distanceBetween(
        targetLatitude,
        targetLongitude,
        position.latitude,
        position.longitude,
      );

      //   print('المسافة الحالية: $distance متر');

      if (distance <= allowedDistance) {
        //   print('الجهاز داخل النطاق المسموح به');

        Map<String, String> location =
            await getCityAndCountry(position.latitude, position.longitude);
        if (!mounted) return;
        setState(() {
          city = location['city'] ?? 'مدينة غير معروفة';
          country = location['country'] ?? 'دولة غير معروفة';
        });
      }
    });
  }

  Future<Map<String, String>> getCityAndCountry(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark placemark = placemarks.first;

      String city = placemark.locality ?? 'مدينة غير معروفة';
      String country = placemark.country ?? 'دولة غير معروفة';

      return {
        'city': city,
        'country': country,
      };
    } catch (e) {
      print('خطأ: $e');
      return {
        'city': 'مدينة غير معروفة',
        'country': 'دولة غير معروفة',
      };
    }
  }

  // Check if the device is connected to the required Wi-Fi
  void _checkWifiInBackground() async {
    final info = NetworkInfo();

    try {
      String? wifiName = await info.getWifiName();
      // print('Connected Wifi: $wifiName');

      if (wifiName != null &&
          wifiName.toLowerCase() == requiredWifiName.toLowerCase()) {
        setState(() {
          isWifiConnected = true;
        });
        //  print('Connected to the required Wi-Fi');
      } else {
        setState(() {
          isWifiConnected = false;
        });
        //   print('Not connected to the required Wi-Fi');
      }
    } catch (e) {
      print('Error checking Wi-Fi: $e');
    }
  }

  Future<String> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location service is disabled';
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return 'Lat: ${position.latitude}, Lon: ${position.longitude}';
  }

  void _openQRCodeScanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      print('User ID is not available in SharedPreferences');
      return;
    }
    String location = await _getCurrentLocation();
    DateTime time = DateTime.timestamp();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                // Camera
                Stack(
                  children: [
                    Positioned.fill(
                      child: MobileScanner(
                          controller: MobileScannerController(
                            detectionSpeed: DetectionSpeed.noDuplicates,
                          ),
                          onDetect: (BarcodeCapture barcodeCapture) async {
                            final barcode = barcodeCapture.barcodes.isNotEmpty
                                ? barcodeCapture.barcodes.first
                                : null;

                            if (barcode != null && barcode.rawValue != null) {
                              final scannedCode = barcode.rawValue!;
                              print('Scanned QR Code: $scannedCode');

                              Uri uri = Uri.parse(scannedCode);
                              String? dataParam = uri.queryParameters['data'];

                              if (dataParam != null) {
                                Map<String, dynamic> data =
                                    jsonDecode(dataParam);

                                String scannedUserId = data['userId'];
                                print('Scanned User ID: $scannedUserId');

                                if (scannedUserId == userId) {
                                  print(
                                      'User ID matches. Registering attendance.');

                                  Map<String, dynamic> requestData = {
                                    "user_id": userId,
                                    "qr_code": scannedCode,
                                    'time':
                                        DateTime.now().millisecondsSinceEpoch,
                                    'location': location,
                                  };

                                  String jsonBody = jsonEncode(requestData);
                                  print("Sending request...");
                                  await _sendCheckInRequest(userId, jsonBody);

                                  if (mounted) {
                                    Navigator.pop(context);
                                  }

                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  } else {
                                    print('Cannot launch the URL.');
                                    showCustomSnackBar(
                                      context,
                                      message: "خطا ف تشغيل اللينك",
                                      // Replace with your localized message
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                } else {
                                  print(
                                      'User ID does not match. Access denied.');
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                            height: 350,
                                            width: double.infinity,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'دا مش حسابك الشخصي',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts
                                                      .balooBhaijaan2(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    _openQRCodeScanner();
                                                  },
                                                  child: Container(
                                                    width: 180,
                                                    height: 180,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xff3880ee),
                                                          Color(0xffc087e5),
                                                        ],
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 5),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.home_outlined,
                                                            color: Colors.white,
                                                            size: 40,
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                            'هفتح حسابي',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .balooBhaijaan2(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                              } else {
                                print(
                                    'Data parameter is missing in the scanned QR Code.');
                                if (Navigator.canPop(context)) {
                                  Navigator.maybePop(context);
                                }
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          height: 350,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurRadius: 10,
                                                offset: Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'دا مش حسابك الشخصي',
                                                textAlign: TextAlign.center,
                                                style:
                                                    GoogleFonts.balooBhaijaan2(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  _openQRCodeScanner();
                                                },
                                                child: Container(
                                                  width: 180,
                                                  height: 180,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xff3880ee),
                                                        Color(0xffc087e5),
                                                      ],
                                                      begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.2),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 5),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.home_outlined,
                                                          color: Colors.white,
                                                          size: 40,
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          'العمل من المنزل',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .balooBhaijaan2(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: CustomPaint(
                          painter: CornerPainter(),
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _sendCheckInRequest(String userId, String jsonBody) async {
    String url =
        'https://demos.elboshy.com/attendance/wp-json/attendance/v1/check-in';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('تم تسجيل الحضور بنجاح');
        print(response.body);
        setState(() {
          isCheckedIn = !isCheckedIn;
          if (!isAttendanceStarted) {
            startTime = DateTime.now();
            buttonText = 'تسجيل انصراف';
            _startTimer();
          } else {
            endTime = DateTime.now();
            buttonText = 'تسجيل حضور';
            _timer?.cancel();
          }
          isAttendanceStarted = !isAttendanceStarted;
        });
        Timer.periodic(Duration(seconds: 1), (timer) {
          if (isCheckedIn) {
            setState(() {
              _startTimer();
              elapsedTime = DateTime.now().difference(startTime!);
            });
          } else {
            timer.cancel();
          }
        });
        return true;
      } else {
        print(response.body);
        print('فشل تسجيل الحضور: ${response.statusCode}');

        // إظهار رسالة مخصصة بناءً على نوع الفشل
        String errorMessage = 'حدث خطأ أثناء تسجيل الحضور';
        if (response.body.contains('Invalid QR Code time format')) {
          errorMessage = 'خطأ في الوقت، يرجى التأكد من الوقت';
        } else if (response.body.contains('Out of range')) {
          errorMessage = 'أنت خارج النطاق المسموح به';
        } else if (response.body.contains('Invalid QR Code data')) {
          errorMessage = 'user مختلف';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.close, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: GoogleFonts.balooBhaijaan2(),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.close, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "مشكلة في الاتصال بالإنترنت",
                  style: GoogleFonts.balooBhaijaan2(),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      print('حدث خطأ أثناء إرسال طلب تسجيل الحضور: $e');
      return false;
    }
  }

// Handle the attendance button
  Future<bool> _handleAttendance() async {
    final bool isConnected = await _checkInternetConnection();

    if (!isConnected) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.transparent,
              child: Container(
                height: 350,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'خارج نطاق الشركه',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.balooBhaijaan2(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        _openQRCodeScanner();
                      },
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff3880ee),
                              Color(0xffc087e5),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home_outlined,
                                color: Colors.white,
                                size: 40,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'العمل من المنزل',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.balooBhaijaan2(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
      return false;
    }

    // Logic for attendance
    if (!isAttendanceStarted) {
      String location = await _getCurrentLocation();
      DateTime time = DateTime.now();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId != null) {
        Map<String, dynamic> requestData = {
          "user_id": userId,
          "qr_code": "manual-check-in",
          'time': time.millisecondsSinceEpoch,
          'location': location,
        };
        _openQRCodeScanner();
        return true;
      } else {
        print('User ID not found in SharedPreferences.');
        return false;
      }
    } else {
      _openCheckOutDialog();
      return false;
    }
  }

  void _processAttendance() async {
    final bool isConnected = true;

    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'لا يوجد اتصال بالإنترنت. يرجى التحقق من الاتصال وإعادة المحاولة.',
            style: GoogleFonts.balooBhaijaan2(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  void _openCheckOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: 350,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'هل أنت متأكد من أنك ترغب في تسجيل الانصراف؟',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.balooBhaijaan2(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      Directionality(
                        textDirection: flutter.TextDirection.ltr,
                        child: SwipeableButtonView(
                          buttonText: "اسحب للتأكيد",
                          buttonWidget: Container(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ),
                          ),
                          activeColor: Colors.red,
                          isFinished: isFinished,
                          onWaitingProcess: () {
                            Future.delayed(Duration(milliseconds: 100), () {
                              setModalState(() {
                                isFinished = true;
                              });
                            });
                          },
                          onFinish: () async {
                            await _processCheckOut();
                            setModalState(() {
                              isFinished = false;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _processCheckOut() async {
    print("Processing Check Out...");
    bool isSuccessful = await _sendCheckOutRequest();

    if (isSuccessful) {
      setState(() {
        isCheckedIn = false;
        isSwipeVisible = false;
        endTime = DateTime.now();
        buttonText = 'تسجيل حضور';
      });
    } else {}
  }

  Future<bool> _sendCheckOutRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      print('لم يتم العثور على user_id في SharedPreferences');
      return false;
    }

    String url =
        'https://demos.elboshy.com/attendance/wp-json/attendance/v1/check-out?user_id=$userId';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          isCheckedIn = !isCheckedIn;
          buttonText = 'تسجيل حضور';
          isAttendanceStarted = false;
          endTime = DateTime.now();
        });
        print('تم تسجيل الانصراف بنجاح');
        print(response.body);
        return true; // العملية نجحت
      } else {
        print('فشل تسجيل الانصراف: ${response.statusCode}');
        return false; // العملية فشلت
      }
    } catch (e) {
      print('حدث خطأ أثناء إرسال طلب الانصراف: $e');
      return false;
    }
  }

  void _showSwipeableBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        bool isFinished = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              child: Directionality(
                textDirection: flutter.TextDirection.ltr,
                child: SwipeableButtonView(
                  buttonText: "اسحب للتأكيد",
                  buttonWidget: Container(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ),
                  activeColor: Colors.red,
                  isFinished: isFinished,
                  onWaitingProcess: () {
                    Future.delayed(Duration(milliseconds: 100), () {
                      setModalState(() {
                        isFinished = true;
                      });
                    });
                  },
                  onFinish: () async {
                    print("Starting check-out process...");
                    await _processCheckOut();
                    print("Check-out completed. Closing sheet...");
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return CustomAdvancedDrawer(
      controller: _advancedDrawerController,
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: screenHeight,
                child: Column(
                  children: [
                    Column(
                      children: [
                        // Stack in AppBar
                        Stack(
                          children: [
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 00,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 50),
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 20, end: 20, top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                " ${userName}  ",
                                                style:
                                                    GoogleFonts.balooBhaijaan2(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              SizedBox(height: 1),
                                              Text(
                                                'قم بتسجيل حضورك الان',
                                                style:
                                                    GoogleFonts.balooBhaijaan2(
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff909090),
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1.5,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(35)),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 3,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30)),
                                                ),
                                                child: userProfilePicture
                                                        .isNotEmpty
                                                    ? CircleAvatar(
                                                        radius: 27,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                userProfilePicture),
                                                      )
                                                    : Icon(Icons.person,
                                                        size: 35),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 4,
                                              left: 4,
                                              child: Container(
                                                height: 14,
                                                width: 14,
                                                decoration: BoxDecoration(
                                                  color: Color(0xff5eb6a1),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 330,
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),

              ///image background

              /////////time and click button///////////////////////////////////////=====================================
              Positioned(
                left: 0,
                right: 0,
                top: 130,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Text(
                        DateFormat('hh:mm a', 'en').format(DateTime.now()),
                        style: GoogleFonts.balooBhaijaan2(
                            color: Color(0xff67686E),
                            fontSize: 40,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 5),
                      Text(
                        DateFormat('EEEE , dd  MMMM ', 'ar')
                            .format(DateTime.now()),
                        style: GoogleFonts.balooBhaijaan2(
                            color: Color(0xff909090),
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 25),
                      Stack(
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _handleAttendance();
                                });
                              },
                              child: Container(
                                width: 248,
                                height: 248,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromRGBO(232, 228, 255, 0.6),
                                      Color.fromRGBO(231, 237, 255, 0.6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 15,
                            top: 15,
                            right: 15,
                            bottom: 15,
                            child: GestureDetector(
                              onTap: () async {
                                bool attendanceSuccessful =
                                    await _handleAttendance();
                                setState(() {
                                  if (attendanceSuccessful) {
                                    isCheckedIn = true;
                                    _startTimer();
                                  } else {
                                    isCheckedIn = false;
                                  }
                                });
                                if (attendanceSuccessful) {
                                  _processAttendance();
                                } else {}
                              },
                              child: Dismissible(
                                key: Key('attendance_button'),
                                direction: DismissDirection.none,
                                onDismissed: (direction) {
                                  if (isSwipeVisible) {
                                    _showSwipeableBottomSheet(context);
                                  }
                                },
                                child: Container(
                                  width: 218,
                                  height: 218,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: isCheckedIn
                                          ? [
                                              Color(0xFF487FDB),
                                              Color(0xFF9684E1)
                                            ]
                                          : [
                                              Color(0xff992f92),
                                              Color(0xffe02f73),
                                              Color(0xffe02f73)
                                            ],
                                      stops: isCheckedIn
                                          ? [0.1667, 0.6756]
                                          : [0.0, 0.5, 1.0],
                                      begin: isCheckedIn
                                          ? Alignment.topRight
                                          : Alignment.topCenter,
                                      end: isCheckedIn
                                          ? Alignment.bottomLeft
                                          : Alignment.bottomCenter,
                                    ),
                                    /* boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF9684E1).withOpacity(0.7),
                                        offset: Offset(-10, 24),
                                        blurRadius: 34,
                                        spreadRadius: -16,
                                      ),
                                    ],*/
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/clickin.svg",
                                          height: 81,
                                          width: 64,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          buttonText,
                                          style: GoogleFonts.balooBhaijaan2(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on,
                              color: Color(0xff67686E), size: 14),
                          SizedBox(width: 4),
                          Text(
                            '$city',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff909090)),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoCard(
                            icon: FontAwesomeIcons.clockFour,
                            time: startTime != null
                                ? DateFormat('hh:mm:ss a', 'ar')
                                    .format(startTime!)
                                : '00:00:00',
                            label: 'تسجيل حضور',
                          ),
                          _buildInfoCard(
                            icon: FontAwesomeIcons.clockRotateLeft,
                            label: 'تسجيل انصراف',
                            time: endTime != null
                                ? DateFormat('hh:mm:ss a', 'ar')
                                    .format(endTime!)
                                : '00:00:00',
                          ),
                          _buildInfoCard(
                            icon: Icons.check_circle,
                            label: 'المدة الكلية',
                            time: isCheckedIn
                                ? formatDuration(elapsedTime)
                                : startTime != null && endTime != null
                                    ? formatDuration(
                                        endTime!.difference(startTime!))
                                    : "00:00",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 120,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: SizedBox(
                  height: 70,
                  child: CustomBottomNavBar(
                    selectedIndex: 4,
                    onItemTapped: (p0) {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required IconData icon, required String label, required String time}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 30,
          color: Colorss.mainColor,
        ),
        SizedBox(height: 5),
        Text(time,
            style: GoogleFonts.balooBhaijaan2(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(label,
            style: GoogleFonts.balooBhaijaan2(
                color: Colors.grey[400], fontSize: 13)),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

Widget _buildAttendanceCard(String number, String title, Color bgColor,
    Color lineColor, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1.0, left: 3, right: 3),
            child: Container(
              height: 5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        number,
                        style: GoogleFonts.balooBhaijaan2(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: lineColor,
                        ),
                      ),
                      Text(
                        title,
                        style: GoogleFonts.balooBhaijaan2(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: lineColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[500]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();

    path.moveTo(0, 40);
    path.quadraticBezierTo(0, 0, 40, 0);

    path.moveTo(size.width - 40, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 40);

    path.moveTo(0, size.height - 40);
    path.quadraticBezierTo(0, size.height, 40, size.height);

    path.moveTo(size.width - 40, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 40);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
