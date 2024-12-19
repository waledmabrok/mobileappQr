import 'dart:async';
import 'dart:io';
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
    Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.high))
        .listen((Position position) {
      double distance = Geolocator.distanceBetween(
        targetLatitude,
        targetLongitude,
        position.latitude,
        position.longitude,
      );

      print('Current Distance: $distance meters');
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

      if (wifiName != null && wifiName.toLowerCase() == requiredWifiName.toLowerCase()) {
        setState(() {
          isWifiConnected = true;
        });
        print('Connected to the required Wi-Fi');
      } else {
        setState(() {
          isWifiConnected = false;
        });
        print('Not connected to the required Wi-Fi');
      }
    } catch (e) {
      print('Error checking Wi-Fi: $e');
    }
  }


/*  void _openQRCodeScanner() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scan QR Code', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: Container(
            height: 400,
            width: double.maxFinite,
            child: MobileScanner(
              onDetect: (BarcodeCapture barcodeCapture) {
                final barcode = barcodeCapture.barcodes.isNotEmpty
                    ? barcodeCapture.barcodes.first
                    : null;
                if (barcode != null && barcode.rawValue != null) {
                  final scannedCode = barcode.rawValue!;
                  print('Scanned QR Code: $scannedCode');
                  Navigator.pop(context); // Close the scanner dialog
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
                }
              },
            ),
          ),
        );
      },
    );

  }*/



  void _openQRCodeScanner() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');  // قراءة الـ user_id

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scan QR Code', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Container(
        height: 400,
          width: double.maxFinite,
          child: MobileScanner(
            onDetect: (BarcodeCapture barcodeCapture) async {
              final barcode = barcodeCapture.barcodes.isNotEmpty
                  ? barcodeCapture.barcodes.first
                  : null;
              if (barcode != null && barcode.rawValue != null) {
                final scannedCode = barcode.rawValue!;
                print('Scanned QR Code: $scannedCode');

                // Close the scanner dialog
                Navigator.pop(context);

                // Get the current timestamp
                String timestamp = DateTime.now().toIso8601String();

                // قراءة user_id من SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? userId = prefs.getString('user_id'); // قراءة user_id

                // تحقق من أن user_id موجود
                if (userId == null) {
                  print('لم يتم العثور على user_id في SharedPreferences');
                  return;
                }

                // إنشاء كائن JSON يتضمن البيانات
                Map<String, dynamic> requestData = {
                  "user_id": userId,
                  "qr_code": scannedCode,
                  "timestamp": timestamp,
                };

                // تحويل الكائن إلى JSON
                String jsonBody = jsonEncode(requestData);

                // إرسال الطلب
                _sendCheckInRequest(jsonBody);

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
              }
            },
          ),
        ),

        );
      },
    );
  }

  Future<void> _sendCheckInRequest(String url) async {
    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Successfully sent check-in request');
        print(response.body);
        // Handle success if needed (e.g., show a success message)
      } else {
        print('Failed to send check-in request: ${response.statusCode}');
        // Handle error if needed (e.g., show an error message)
      }
    } catch (e) {
      print('Error sending check-in request: $e');
      // Handle network error if needed
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
                  Navigator.of(context).pop(); // إغلاق الـ Dialog
                  if (!isAttendanceStarted) {
                    _openQRCodeScanner(); // فتح نافذة الماسح الضوئي فقط لتسجيل الحضور
                  } else {
                    _processAttendance(); // تسجيل الانصراف مباشرة
                  }
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // تحقق من إذن الموقع
    if (isLocationPermissionGranted) {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position) {
        double distance = Geolocator.distanceBetween(
          targetLatitude,
          targetLongitude,
          position.latitude,
          position.longitude,
        );

        if (distance > allowedDistance) {
          // عرض رسالة تحذير
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
            _openQRCodeScanner(); // فتح نافذة الماسح الضوئي فقط عند تسجيل الحضور
          } else {
            _processAttendance(); // تسجيل الانصراف مباشرة
          }
          return;
        }

        // إذا كانت الشروط صحيحة (داخل النطاق)
        if (!isAttendanceStarted) {
          _openQRCodeScanner(); // فتح نافذة الماسح الضوئي فقط عند تسجيل الحضور
        } else {
          _processAttendance(); // تسجيل الانصراف مباشرة
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
  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (startTime != null) {
          elapsedTime = DateTime.now().difference(startTime!);
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel(); // إلغاء الـ Timer
  }

  void _processAttendance() async {
    // التحقق من اتصال الإنترنت
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
      return; // إنهاء الوظيفة إذا لم يكن هناك اتصال
    }

    // إذا كان الإنترنت متصلاً، قم بتحديث الحالة
    setState(() {
      isCheckedIn = !isCheckedIn;
      if (!isAttendanceStarted) {
        // تسجيل حضور
        startTime = DateTime.now();
        isCheckedIn = true;
        elapsedTime = Duration.zero;
        buttonText = 'تسجيل انصراف';
      } else {
        // تسجيل انصراف
        endTime = DateTime.now();
        isCheckedIn = false;
        _sendCheckOutRequest(); // استدعاء الدالة الخاصة بتسجيل الانصراف
        buttonText = 'تسجيل حضور';
      }
      isAttendanceStarted = !isAttendanceStarted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAttendanceStarted ? 'تم تسجيل حضور بنجاح' : 'تم تسجيل انصراف',
          style: GoogleFonts.cairo(color: Colors.white),
        ),
        backgroundColor: isAttendanceStarted ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _sendCheckOutRequest() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');  // قراءة الـ user_id

    // تحقق من أن user_id موجود
    if (userId == null) {
      print('لم يتم العثور على user_id في SharedPreferences');
      return;
    }
    // رابط الانصراف
    String url = 'https://demos.elboshy.com/attendance/wp-json/attendance/v1/check-out?user_id=$userId';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        print('تم تسجيل الانصراف بنجاح');
        print(response.body);
        // التعامل مع الاستجابة الناجحة إذا لزم الأمر
      } else {
        print('فشل تسجيل الانصراف: ${response.statusCode}');
        // التعامل مع الخطأ في حال فشل الطلب
      }
    } catch (e) {
      print('حدث خطأ أثناء إرسال طلب الانصراف: $e');
      // التعامل مع الخطأ الشبكي إذا لزم الأمر
    }
  }


// وظيفة للتحقق من الاتصال بالإنترنت
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
                    padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
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
                                    border: Border.all(color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.all(Radius.circular(35)),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 32,
                                    backgroundImage: AssetImage('assets/img1.jpg'),
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
                                      border: Border.all(color: Colors.white, width: 2),
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
                                  style: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
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
                    style: GoogleFonts.cairo(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    DateFormat('MMMM dd, yyyy - EEEE', 'ar').format(DateTime.now()),
                    style: GoogleFonts.cairo(color: Colors.grey[400], fontSize: 14),
                  ),
                  SizedBox(height: 25),
                  Center(
                    child: GestureDetector(
                      onTap: _handleAttendance,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: isCheckedIn
                                ? [Color(0xff3880ee), Color(0xff3880ee), Color(0xffc087e5), Color(0xffc087e5)]
                                : [Color(0xff992f92), Color(0xffe02f73), Color(0xffe02f73)],
                            begin: isCheckedIn ? Alignment.topRight : Alignment.topCenter,
                            end: isCheckedIn ? Alignment.bottomLeft : Alignment.bottomCenter,
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
                                style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
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
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String label, required String time}) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.grey[400]),
        SizedBox(height: 5),
        Text(time, style: GoogleFonts.cairo(color: Colors.black, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(label, style: GoogleFonts.cairo(color: Colors.grey[400], fontSize: 13)),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
