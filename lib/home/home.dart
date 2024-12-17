import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ScanQR.dart';

class BarcodeScanner extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  String scannedBarcode = '';
  String buttonText = 'تسجيل حضور';
  Color buttonColor = Colors.blue;
  bool isButtonEnabled = false;

  // Variables for location and Wi-Fi checking
  static const targetLatitude = 30.580996;
  static const double targetLongitude = 31.4904367;
  static const double allowedDistance = 15;
  static const requiredWifiName = '"ElBoshy"';

  Timer? _timer; // Timer for periodic updates

  @override
  void initState() {
    super.initState();
    _checkLocationPermission(); // Check location permission
    _startBackgroundTasks();
  }

  // Check if location permission is granted
  void _checkLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted');
    } else {

    }
  }

  // Start background tasks for checking location and wifi
  void _startBackgroundTasks() {
    // Check location and Wi-Fi every minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _checkLocationInBackground();
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
      _updateButtonState(distance <= allowedDistance);
    });
  }

  // Check if the device is connected to the required Wi-Fi
  void _checkWifiInBackground() async {
    final info = NetworkInfo();

    try {
      if (await Permission.location.request().isGranted) {
        String? wifiName = (await info.getWifiName())?.trim();
        print('Connected Wifi: $wifiName');

        // Check if the Wi-Fi is the required one
        if (wifiName != null && wifiName.toLowerCase() == requiredWifiName.toLowerCase()) {
          // Wi-Fi is correct, check the location as well
          setState(() {
            isButtonEnabled = true; // Enable the button if both Wi-Fi and location are valid
          });
        } else {
          // Wi-Fi is not correct, disable the button
          setState(() {
            isButtonEnabled = false;
          });
        }
      } else {
        print('Location permission denied!');
      }
    } catch (e) {
      print('Error checking Wi-Fi: $e');
    }
  }

  // Update the button state based on both location and Wi-Fi conditions
  void _updateButtonState(bool isLocationValid) {
    if (mounted) {
      setState(() {
        // تحقق من أن المتغيرات غير null
        if (isLocationValid != null && isButtonEnabled != null) {
          if (isLocationValid && isButtonEnabled) {
            isButtonEnabled = true;
          } else {
            isButtonEnabled = false;
          }
        } else {
          // إذا كانت القيم غير صالحة، إخفاء أو تعطيل الزر
          isButtonEnabled = false;
        }
      });
    }
  }


  String personName = 'Waled Ahmed';
  String personImage = 'https://via.placeholder.com/150';
  bool isCheckedIn = false;
  String scannedUrl = ''; // To store the scanned URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YourColor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(personImage),
            ),
            SizedBox(height: 15),
            Text(
              personName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 150),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        isButtonEnabled ? buttonColor : Colors.grey,
                      ),
                    ),
                    onPressed: isButtonEnabled
                        ? () => _checkBeforeScan()
                        : buttonText == 'تسجيل خروج'
                        ? _logoutAndExit
                        : null,  // هنا نضيف إغلاق التطبيق عند الضغط على "تسجيل خروج"
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // دالة لإغلاق التطبيق
  void _logoutAndExit() {
    SystemNavigator.pop();  // إغلاق التطبيق
    // أو يمكنك استخدام exit(0) في حال أردت:
    // exit(0);
  }

  // التحقق من الموقع والشبكة
  void _checkBeforeScan() {
    if (!isButtonEnabled) {

    } else {
      _showScannerPage(context);
    }
  }

  // عرض صفحة الماسح الضوئي
  void _showScannerPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanPage(onBarcodeScan: (url) {
        setState(() {
          scannedUrl = url; // حفظ الرابط الممسوح
          buttonText = 'تسجيل خروج'; // تغيير النص إلى "تسجيل خروج"
          buttonColor = Colors.red; // تغيير اللون إلى الأحمر
        });
        _launchUrl(url); // فتح الرابط بعد مسحه
      })),
    );
  }

  // فتح الرابط بعد المسح
  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}

class ScanPage extends StatefulWidget {
  final Function(String) onBarcodeScan;
  ScanPage({required this.onBarcodeScan});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String scannedBarcode = "";

  // التحقق من الأذونات
  Future<void> _checkPermissions() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      print("Permission granted.");
    } else {
      print("Permission denied.");
      _showPermissionDialog();
    }
  }

  // عرض رسالة إذن الكاميرا
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إذن الوصول إلى الكاميرا'),
        content: Text('يجب أن تمنح الإذن للوصول إلى الكاميرا لاستخدام الماسح الضوئي.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Barcode"),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (BarcodeCapture barcodeCapture) {
                final barcode = barcodeCapture.barcodes.isNotEmpty
                    ? barcodeCapture.barcodes.first
                    : null;

                if (barcode != null && barcode.rawValue != null) {
                  final url = barcode.rawValue!;

                  widget.onBarcodeScan(url); // Pass the scanned URL back to the parent

                  // تحقق من أن الـ widget لا يزال مركبًا قبل استدعاء setState
                  if (mounted) {
                    setState(() {
                      scannedBarcode = url;
                    });
                  }

                  // إغلاق صفحة المسح بعد مسح الباركود
                  Navigator.pop(context); // إغلاق الصفحة بعد مسح الباركود
                }
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            scannedBarcode.isNotEmpty ? 'تم مسح الباركود: $scannedBarcode' : 'مسح الباركود',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
