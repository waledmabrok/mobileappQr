import 'dart:async';
import 'dart:io';
import 'dart:ui' as flutter;
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
import 'package:network_info_plus/network_info_plus.dart';

import '../ FieldsMachine/setup/MainColors.dart';
import 'calender.dart';
import 'navgate.dart';


class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String buttonText = 'تسجيل حضور';
  bool isAttendanceStarted = false;
  DateTime? startTime;
  DateTime? endTime;
  bool isCheckedIn = true;
  Duration elapsedTime = Duration.zero;

  /// Variables for location and Wi-Fi checking
  static const targetLatitude = 30.580996;
  static const double targetLongitude = 31.4904367;
  static const double allowedDistance = 15;
  static const requiredWifiName = '"ElBoshy"';
  Timer? _timer;

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  bool isSwipeVisible = false;
  bool isFinished = false;
  bool _isRequestInProgress = false; // متغير لتعقب حالة الطلب

  StreamController<bool> _wifiController = StreamController<bool>();
  StreamController<bool> _locationController = StreamController<bool>();

  // Variables for location and Wi-Fi checking
  bool isLocationPermissionGranted = false;
  bool isWifiConnected = false;

  // الوقت المنقضي
  @override
  void initState() {
    super.initState();
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

  // Check if location permission is granted
  void _checkLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        isLocationPermissionGranted = true;
      });
      print('Location permission granted');
    } else {
      print('Location permission denied');
    }
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
            locationSettings: LocationSettings(accuracy: LocationAccuracy.high))
        .listen((Position position) {
      double distance = Geolocator.distanceBetween(
        targetLatitude,
        targetLongitude,
        position.latitude,
        position.longitude,
      );

      //  print('Current Distance: $distance meters');
      if (distance <= allowedDistance) {
        // Perform any action when within allowed distance
        print('Device is within allowed range');
      }
    });
  }

  // Check if the device is connected to the required Wi-Fi
  void _checkWifiInBackground() async {
    final info = NetworkInfo();

    try {
      String? wifiName = await info.getWifiName();
      print('Connected Wifi: $wifiName');

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
/*  void _openQRCodeScanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id'); // قراءة الـ user_id

    if (userId == null) {
      print('User ID is not available in SharedPreferences');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Scan QR Code', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          ),
          body: QRScannerView(userId: userId),
        ),
      ),
    );
  }*/
  void _openQRCodeScanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      print('User ID is not available in SharedPreferences');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                // خلفية بيضاء
                Positioned.fill(
                  child: Container(color: Colors.white),
                ),
                // شاشة الكاميرا المصغرة
                Stack(
                  children: [
                    Center(
                      child: ClipRRect( // استخدم ClipRRect لقص الزوايا بشكل دائري
                        borderRadius: BorderRadius.circular(25), // تحديد مقدار التقوس للحدود
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25), // نفس قيمة التقوس للإطار
                            border: Border.all(color: Colors.red, width: 3), // حدود حمراء
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(0, 10),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          width: 300, // عرض مربع
                          height: 300, // ارتفاع مربع
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

                                Map<String, dynamic> requestData = {
                                  "user_id": userId,
                                  "qr_code": scannedCode,
                                };

                                String jsonBody = jsonEncode(requestData);
                                print("Sending request...");

                                try {
                                  Uri uri = Uri.parse(scannedCode);

                                  if (uri.queryParameters.containsKey('userId')) {
                                    String scannedUserId = uri.queryParameters['userId']!;

                                    if (scannedUserId == userId) {
                                      print('User ID matches. Registering attendance.');
                                      await _sendCheckInRequest(userId, jsonBody);

                                      if (mounted) {
                                        Navigator.pop(context);
                                      }

                                      setState(() {
                                        isCheckedIn = !isCheckedIn;
                                        if (!isAttendanceStarted) {
                                          startTime = DateTime.now();
                                          buttonText = 'تسجيل انصراف';
                                        } else {
                                          endTime = DateTime.now();
                                          buttonText = 'تسجيل حضور';
                                        }
                                        isAttendanceStarted = !isAttendanceStarted;
                                      });

                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      } else {
                                        print('Cannot launch the URL.');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Cannot launch the URL.')),
                                        );
                                      }
                                    } else {
                                      print('User ID does not match. Access denied.');
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(Icons.close, color: Colors.white),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  "الحساب مختلف",
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
                                    }
                                  } else {
                                    print('User ID is missing in the scanned QR Code.');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(Icons.close, color: Colors.white),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                "الحساب مختلف",
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
                                  }
                                } catch (e) {
                                  print('Error processing QR Code: $e');
                                }
                              }
                            },
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



  Future<void> _sendCheckInRequest(String userId, String jsonBody) async {
    try {
      String url =
          'https://demos.elboshy.com/attendance/wp-json/attendance/v1/check-in?user_id=$userId';

      final response = await http.post(
        Uri.parse(url),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Successfully sent check-in request');
        print(response.body);

        Map<String, dynamic> responseJson = jsonDecode(response.body);
        if (responseJson['status'] == 'success') {
          if (responseJson['qr_code'] != null &&
              responseJson['qr_code'].startsWith('http')) {
            Uri uri = Uri.parse(responseJson['qr_code']);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              print('الرابط غير صالح أو لا يمكن فتحه');
            }
          } else {
            // تحديث الحالة بناءً على الاستجابة
            /* if (mounted) {
              setState(() {
                isCheckedIn = !isCheckedIn;
                if (!isAttendanceStarted) {
                  startTime = DateTime.now();
                  buttonText = 'تسجيل انصراف';
                } else {
                  endTime = DateTime.now();
                  buttonText = 'تسجيل حضور';
                }
                isAttendanceStarted = !isAttendanceStarted;
              });
            }*/
          }
        } else {
          print('فشل التحقق من البيانات، لم يتم تسجيل الحضور');
        }
      } else {
        print('Failed to send check-in request: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending check-in request: $e');
    }
  }

// Handle the attendance button
  void _handleAttendance() async {
    // تحقق من اتصال Wi-Fi
    if (!isWifiConnected) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'تنبيه',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'أنت غير متصل بشبكة الواي فاي المطلوبة، سيتم تسجيل الحضور ولكنك ستكون خارج نطاق الشركة.',
              style: GoogleFonts.cairo(),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'موافق',
                  style: GoogleFonts.cairo(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (!isAttendanceStarted) {
                    _openQRCodeScanner();
                  } else {
                    _processAttendance();
                  }
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (isLocationPermissionGranted) {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((position) {
        double distance = Geolocator.distanceBetween(
          targetLatitude,
          targetLongitude,
          position.latitude,
          position.longitude,
        );

        if (distance > allowedDistance) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'أنت خارج نطاق الشركة. يرجى التواجد في الموقع المناسب.',
                style: GoogleFonts.cairo(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );

          if (!isAttendanceStarted) {
            _openQRCodeScanner();
          } else {
            _processAttendance();
          }
          return;
        }

        if (!isAttendanceStarted) {
          _openQRCodeScanner();
        } else {
          _processAttendance();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يرجى تفعيل إذن الموقع.',
            style: GoogleFonts.cairo(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _processAttendance() async {
    final bool isConnected = await _checkInternetConnection();
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'لا يوجد اتصال بالإنترنت. يرجى التحقق من الاتصال وإعادة المحاولة.',
            style: GoogleFonts.cairo(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      if (!isAttendanceStarted) {
        // تسجيل حضور
        startTime = DateTime.now();
        isCheckedIn = true;
        buttonText = 'تسجيل انصراف';
      } else {
        isSwipeVisible = true;
        // تسجيل انصراف
        /*endTime = DateTime.now();
        isCheckedIn = false;

        buttonText = 'تسجيل حضور';*/
      }
      isAttendanceStarted = !isAttendanceStarted;
    });
  }

  void _processCheckOut2() {
    setState(() {
      _sendCheckOutRequest();
      isCheckedIn = false;
      isSwipeVisible = false;
      buttonText = 'تسجيل حضور';
    });
  }



  Future<void> _processCheckOut() async {
    print("Processing Check Out...");
    await _sendCheckOutRequest();

    setState(() {
      isCheckedIn = false;
      isSwipeVisible = false;
      endTime = DateTime.now();
      buttonText = 'تسجيل حضور';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تسجيل انصراف بنجاح',
          style: GoogleFonts.cairo(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _sendCheckOutRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id'); // قراءة الـ user_id

    if (userId == null) {
      print('لم يتم العثور على user_id في SharedPreferences');
      return;
    }

    String url =
        'https://demos.elboshy.com/attendance/wp-json/attendance/v1/check-out?user_id=$userId';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        print('تم تسجيل الانصراف بنجاح');
        print(response.body);
      } else {
        print('فشل تسجيل الانصراف: ${response.statusCode}');
      }
    } catch (e) {
      print('حدث خطأ أثناء إرسال طلب الانصراف: $e');
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
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
              activeColor: Color(0xff3398F6),
              isFinished: isFinished,
              onWaitingProcess: () {
                Future.delayed(Duration(seconds: 1), () {
                  setState(() {
                    isFinished = true;
                  });
                });
              },
              onFinish: () async {
                await _processCheckOut();
                setState(() {
                  isFinished = false;
                });
                Navigator.pop(context); // إغلاق الـ Bottom Sheet
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    // Stack in AppBar
                    Stack(
                      children: [
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            color: Color(0xff3880ee),
                            borderRadius: BorderRadius.only(),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 15, left: 10, right: 10),
                          child: Column(
                            children: [
                              SizedBox(height: 40),
                              Row(
                                children: [
                                  SizedBox(width: 20),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(35)),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 32,
                                          backgroundImage:
                                              AssetImage('assets/img1.jpg'),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 3,
                                        left: 3,
                                        child: Container(
                                          height: 14,
                                          width: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Waled Mabrok',
                                        style: GoogleFonts.cairo(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Mark Your Attendance!',
                                        style: GoogleFonts.cairo(
                                            color: Colors.white70, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
        
                  ],
                ),
                SizedBox(height: 350,),

                Padding(
                  padding: EdgeInsetsDirectional.only(start: 20, top: 10, end: 20, bottom: 10),
                  child: Container(
                    alignment: AlignmentDirectional.topStart,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "الحضور",
                            style: GoogleFonts.cairo(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "الشهر الحالي",
                            style: GoogleFonts.cairo(
                              color: Colors.blueGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10,),
                          GridView.count(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 2,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              _buildAttendanceCard("08", "الخروج المبكر", Colors.blue.shade50, Colors.blue,() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>HomeScreen(index2: 2,filter: 'الخروج المبكر')),
                                );
                              },),
                              _buildAttendanceCard("03", "الغياب", Colors.purple.shade50, Colors.purple,() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen(index2: 2,filter: 'الغياب')),
                                );
                              },),
                              _buildAttendanceCard("04", "التأخير", Colors.red.shade50, Colors.red,(){}),
                              _buildAttendanceCard("09", "إجمالي الإجازات", Colors.orange.shade50, Colors.orange,(){}),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(

                        borderRadius: BorderRadius.all(Radius.circular(15)
                        ),color: Colors.white,boxShadow: [ BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "الأحداث القادمة",
                                style: GoogleFonts.cairo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Add navigation to the events page here
                                },
                                child: Text(
                                  "عرض الكل",
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colorss.mainColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                // First card
                                Container(
                                  width: 250,
                                  margin: EdgeInsetsDirectional.only(end: 12),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.greenAccent, Colors.green],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Profile Image
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage('assets/img1.jpg'),
                                      ),
                                      SizedBox(width: 12),
                                      // Event Info
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "عيد ميلاد سعيد",
                                            style: GoogleFonts.cairo(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "وليد مبروك",
                                            style: GoogleFonts.cairo(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "26 اكتوبر",
                                            style: GoogleFonts.cairo(
                                              fontSize: 12,
                                              color: Colors.white.withOpacity(0.9),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      // Event Icon
                                      Icon(
                                        Icons.cake_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                                 Container(
                                  width: 250,
                                  margin: EdgeInsetsDirectional.only(end: 12),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.greenAccent, Colors.green],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Profile Image
                                      Stack(
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white, width: 2),
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(35)),
                                                ),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  radius: 28,
                                                  backgroundImage:
                                                  AssetImage('assets/img1.jpg'),
                                                ),
                                              ),

                                            ],
                                          ),

                                        ],
                                      ),
                                      SizedBox(width: 12),
                                      // Event Info
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "عيد ميلاد سعيد",
                                            style: GoogleFonts.cairo(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "وليد مبروك",
                                            style: GoogleFonts.cairo(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "26 اكتوبر",
                                            style: GoogleFonts.cairo(
                                              fontSize: 12,
                                              color: Colors.white.withOpacity(0.9),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      // Event Icon
                                      Icon(
                                        Icons.cake_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                                // Add more cards here if needed
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),


            SizedBox(height: 50,),

            Positioned(
              left: 0,
              right: 0,
              top: 150,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Text(
                      DateFormat('hh:mm a', 'ar').format(DateTime.now()),
                      style: GoogleFonts.cairo(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      DateFormat('MMMM dd, yyyy - EEEE', 'ar')
                          .format(DateTime.now()),
                      style: GoogleFonts.cairo(
                          color: Colors.grey[400], fontSize: 14),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _handleAttendance();
                          });
                        },
                        child: Dismissible(
                          key: Key('attendance_button'),
                          direction: DismissDirection.none,
                          onDismissed: (direction) {
                            if (isSwipeVisible) {
                              _processCheckOut2();
                             _showSwipeableBottomSheet(context);
                              isCheckedIn = true;
                            }
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: isCheckedIn
                                    ? [
                                        Color(0xff3880ee),
                                        Color(0xff3880ee),
                                        Color(0xffc087e5),
                                        Color(0xffc087e5)
                                      ] // ألوان عند الحضور
                                    : [
                                        Color(0xff992f92),
                                        Color(0xffe02f73),
                                        Color(0xffe02f73)
                                      ], // ألوان عند الانصراف
        
                                begin: isCheckedIn
                                    ? Alignment.topRight
                                    : Alignment.topCenter,
                                end: isCheckedIn
                                    ? Alignment.bottomLeft
                                    : Alignment.bottomCenter,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff3880ee).withOpacity(0.5),
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
                                    Icons.touch_app_rounded,
                                    color: Colors.white,
                                    size: 80,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    buttonText,
                                    // النص الذي يتغير بين "تسجيل انصراف" و "تسجيل حضور"
                                    style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard(
                          icon: FontAwesomeIcons.clockFour,
                          time: startTime != null
                              ? DateFormat('hh:mm:ss a', 'ar').format(startTime!)
                              : '--:--:--',
                          label: 'تسجيل حضور',
                        ),
                        _buildInfoCard(
                          icon: FontAwesomeIcons.clockRotateLeft,
                          label: 'تسجيل انصراف',
                          time: endTime != null
                              ? DateFormat('hh:mm:ss a', 'ar').format(endTime!)
                              : '--:--:--',
                        ),
                        _buildInfoCard(
                          icon: Icons.check_circle,
                          label: 'المدة الكلية',
                          time: isCheckedIn
                              ? "${elapsedTime.inHours.toString().padLeft(2, '0')}:${(elapsedTime.inMinutes % 60).toString().padLeft(2, '0')}:${(elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}"
                              : startTime != null && endTime != null
                                  ? "${endTime!.difference(startTime!).inHours.toString().padLeft(2, '0')}:${(endTime!.difference(startTime!).inMinutes % 60).toString().padLeft(2, '0')}:${(endTime!.difference(startTime!).inSeconds % 60).toString().padLeft(2, '0')}"
                                  : "--:--",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Visibility(
                  visible: isSwipeVisible,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 25),
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
                          activeColor: Color(0xff3398F6),
                          isFinished: isFinished,
                          onWaitingProcess: () {
                            Future.delayed(Duration(seconds: 1), () {
                              setState(() {
                                isFinished = true;
                              });
                            });
                          },
                          onFinish: () async {
                            await _processCheckOut();
                            setState(() {
                              isFinished = false;
                            });
                          },
                        ),
                      )),
                )),
        
          ],
        ),
      ),

    );
  }

  Widget _buildInfoCard(
      {required IconData icon, required String label, required String time}) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.grey[400]),
        SizedBox(height: 5),
        Text(time,
            style: GoogleFonts.cairo(
                color: Colors.black, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(label,
            style: GoogleFonts.cairo(color: Colors.grey[400], fontSize: 13)),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
Widget _buildAttendanceCard(String number, String title, Color bgColor, Color lineColor, VoidCallback onTap) {
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
            offset: Offset(0, 0), // يجعل الظل في المنتصف
          ),

        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 1.0,left: 3,right: 3),
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
              padding: const EdgeInsets.all(7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        number,
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: lineColor,
                        ),
                      ),
                      Text(
                        title,
                        style: GoogleFonts.cairo(
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