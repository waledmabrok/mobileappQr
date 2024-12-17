import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

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
