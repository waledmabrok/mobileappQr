import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ FieldsMachine/CustomSnackBar/Snackbar.dart';
import '../ FieldsMachine/FieldsContext/Button.dart';
import '../ FieldsMachine/FieldsContext/Text.dart';
import '../ FieldsMachine/setup/MainColors.dart';
import '../onboarding/Requests_Main/Requests.dart';

class PermissionRequestPage extends StatefulWidget {
  static const routeName = "/request_Premission2";

  @override
  _PermissionRequestPageState createState() => _PermissionRequestPageState();
}

class _PermissionRequestPageState extends State<PermissionRequestPage> {
  DateTime? selectedDate;
  String? reason;
  String? selectedPermissionType;

  final List<String> permissionTypes = [
    'إذن مروّاح مبكر',
    'نصف يوم',
    'إذن تأخير'
  ];

  void _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2023),
      lastDate: DateTime(now.year + 1, 12, 31),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitRequest() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        // تغيير لون الخلفية
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        // جعل SnackBar يطفو فوق المحتوى

        content: Text(
          "الطلب قيد الانتظار وجاري الموافقة عليه من قبل الإدارة.",
          style: GoogleFonts.balooBhaijaan2(),
        ),
        action: SnackBarAction(
          label: "عرض الطلبات",
          textColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RequestsMain(
                  selectedTab: 'الاذونات',
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('طلب إذن',
            style: GoogleFonts.balooBhaijaan2(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('تاريخ الإذن'),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: _buildInputField(
                    icon: Icons.date_range,
                    text: selectedDate == null
                        ? 'اختر التاريخ'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  ),
                ),
                SizedBox(height: 16),
                _buildSectionTitle('نوع الإذن'),
                SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  runSpacing: 10,
                  children: permissionTypes.map((type) {
                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedPermissionType = type),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: selectedPermissionType == type
                              ? Colorss.mainColor
                              : Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: selectedPermissionType == type
                                  ? Colorss.mainColor
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                              width: 0.5),
                        ),
                        child: Text(
                          type,
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: selectedPermissionType == type
                                ? Colors.white
                                : Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                _buildSectionTitle('سبب الإذن'),
                SizedBox(
                  height: 100,
                  child: CustomText(
                    prefixIcon: Icons.edit,
                    hintText: "أدخل سبب الإذن",
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40,
                  ),
                  child: CustomButton(
                    text: 'إرسال الطلب',
                    onPressed: _submitRequest,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title,
          style: GoogleFonts.balooBhaijaan2(
              fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInputField({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colorss.mainColor),
          SizedBox(width: 10),
          Text(text, style: GoogleFonts.balooBhaijaan2(fontSize: 16)),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon, String hint) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colorss.mainColor),
      hintText: hint,
      hintStyle: GoogleFonts.balooBhaijaan2(),
      filled: true,
      fillColor: Colorss.BorderColor,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}
