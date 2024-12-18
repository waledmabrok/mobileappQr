import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

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

  /// Variables for location and Wi-Fi checking
  static const targetLatitude = 30.580996;
  static const double targetLongitude = 31.4904367;
  static const double allowedDistance = 15;
  static const requiredWifiName = '"ElBoshy"';
  Timer? _timer;

  StreamController<bool> _wifiController = StreamController<bool>();
  StreamController<bool> _locationController = StreamController<bool>();
  // Variables for location and Wi-Fi checking
  bool isLocationPermissionGranted = false;
  bool isWifiConnected = false;

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
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
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
  void _openQRCodeScanner() {
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
                }
              },
            ),
          ),
        );
      },
    );

  }

  // Handle the attendance button
  void _handleAttendance() async {
    // تحقق من اتصال Wi-Fi والموقع قبل متابعة العملية
    if (!isWifiConnected) {
      // عرض Dialog إذا لم يكن متصلًا بالشبكة المطلوبة
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
                  _openQRCodeScanner(); // فتح نافذة الماسح الضوئي
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // إذا كان الاتصال بالواي فاي صحيحًا، تحقق من إذن الموقع
    if (isLocationPermissionGranted) {
      // تحقق من الموقع
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position) {
        double distance = Geolocator.distanceBetween(
          targetLatitude,
          targetLongitude,
          position.latitude,
          position.longitude,
        );

        if (distance > allowedDistance) {
          // عرض رسالة إذا كانت المسافة أكبر من المسافة المسموح بها
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'أنت خارج نطاق الشركة. يرجى التواجد في الموقع المناسب.',
                style: GoogleFonts.cairo(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // إذا كانت كل الشروط صحيحة، افتح نافذة الماسح الضوئي
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAttendanceStarted ? 'تم تسجيل حضور بنجاح' : 'تم تسجيل انصراف',
              style: GoogleFonts.cairo(color: Colors.white),
            ),
            backgroundColor: isAttendanceStarted ? Colors.green : Colors.red,
          ),
        );

        if (isAttendanceStarted) {
          // هنا يمكنك إضافة الإجراءات التي تريد أن تحدث بعد فتح نافذة الماسح الضوئي
          // مثال: إضافة سجلات إضافية أو التحقق من قاعدة بيانات مثلاً
          _openQRCodeScanner(); // فتح نافذة الماسح الضوئي عند تسجيل الحضور
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
                        time: startTime != null && endTime != null
                            ? "${endTime!.difference(startTime!).inMinutes} دقائق"
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
