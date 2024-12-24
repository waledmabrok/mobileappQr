import 'package:flutter/material.dart';
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
class QRScannerView extends StatelessWidget {
  final String userId;

  QRScannerView({required this.userId});
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
  @override
  Widget build(BuildContext context) {
    return Container(
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

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Attendance Registered')),
                  );
                  Navigator.pop(context);
                } else {
                  print('User ID does not match. Access denied.');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User ID mismatch.')),
                  );
                  Navigator.pop(context);
                }
              } else {
                print('User ID is missing in the scanned QR Code.');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User ID missing in QR code.')),
                );
                Navigator.pop(context);
              }
            } catch (e) {
              print('Error processing QR Code: $e');
            }
          }
        },
      ),
    );
  }}