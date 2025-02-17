import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../ FieldsMachine/FieldsContext/Button.dart';
import '../../ FieldsMachine/FieldsContext/Text.dart';
import '../../ FieldsMachine/setup/MainColors.dart';
import '../../CustomNavbar/Drawer.dart';
import '../Requests_Main/Requests.dart';

class LoanRequestPage extends StatefulWidget {
  static const routeName = "/request_money2";

  @override
  _LoanRequestPageState createState() => _LoanRequestPageState();
}

class _LoanRequestPageState extends State<LoanRequestPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final _advancedDrawerController = AdvancedDrawerController();
  DateTime? selectedDate;
  String paymentMethod = "كاش";
  int? installmentMonths;
  double? monthlyPayment;
  double previousAmount = 0.0; // لحفظ القيمة السابقة للمبلغ
  final List<int> suggestedAmounts = [1000, 2000, 3000, 5000, 10000];

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _calculateInstallments() {
    if (amountController.text.isNotEmpty &&
        installmentMonths != null &&
        installmentMonths! > 0) {
      double amount = double.parse(amountController.text);
      setState(() {
        monthlyPayment = amount / installmentMonths!;
      });
    } else {
      setState(() {
        monthlyPayment =
            null; // إعادة تعيين الأقساط إذا كانت البيانات غير مكتملة أو غير صحيحة
      });
    }
  }

  void _submitRequest() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
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
                builder: (context) => RequestsMain(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomAdvancedDrawer(
      controller: _advancedDrawerController,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text("طلب سلفة", style: GoogleFonts.balooBhaijaan2()),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text("اختر مبلغ السلفة",
                                style: GoogleFonts.balooBhaijaan2(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 12,
                              runSpacing: 10,
                              children: suggestedAmounts.map((amount) {
                                return ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      amountController.text = amount.toString();
                                      previousAmount = amount
                                          .toDouble(); // تحديث المبلغ السابق
                                      monthlyPayment =
                                          null; // إعادة تعيين الأقساط عند التغيير
                                    });
                                  },
                                  child: Text("${amount} ج.م",
                                      style: GoogleFonts.balooBhaijaan2()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colorss.mainColor,
                                    foregroundColor: Colors.white,
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            CustomText(
                              controller: amountController,
                              hintText: "أدخل مبلغًا",
                              onChanged: (value) {
                                setState(() {
                                  if (value!.isNotEmpty) {
                                    previousAmount =
                                        double.tryParse(value) ?? 0.0;
                                    monthlyPayment =
                                        null; // مسح الأقساط القديمة
                                  }

                                  // حساب الأقساط إذا كانت طريقة الدفع "قسط" والشهور محددة
                                  if (paymentMethod == "قسط" &&
                                      installmentMonths != null &&
                                      installmentMonths! > 0) {
                                    _calculateInstallments(); // حساب الأقساط من جديد
                                  } else {
                                    monthlyPayment =
                                        null; // إعادة تعيين الأقساط إذا لم تتوفر الشروط
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: _buildInputField(
                                icon: Icons.date_range,
                                text: selectedDate == null
                                    ? ' اختر تاريخ السلفه'
                                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                              ),
                            ),
                            SizedBox(height: 16),
                            CustomText(
                                controller: reasonController,
                                hintText: "سبب السلفة"),
                            SizedBox(height: 16),
                            CustomText(
                              controller:
                                  TextEditingController(text: paymentMethod),
                              hintText: "أسلوب السداد",
                              isDropdown: true,
                              items: ["كاش", "قسط"],
                              onChanged: (value) {
                                setState(() {
                                  paymentMethod = value!;
                                  if (paymentMethod == "كاش") {
                                    installmentMonths = null;
                                    monthlyPayment = null;
                                  }
                                });
                              },
                            ),
                            if (paymentMethod == "قسط") ...[
                              SizedBox(height: 16),
                              CustomText(
                                controller: TextEditingController(
                                  text: installmentMonths != null
                                      ? "$installmentMonths شهر"
                                      : '',
                                ),
                                hintText: "مدة السداد",
                                isDropdown: true,
                                items: List.generate(
                                    12, (index) => "${index + 1} شهر"),
                                onChanged: (value) {
                                  setState(() {
                                    installmentMonths =
                                        int.tryParse(value!.split(" ")[0]);
                                    monthlyPayment =
                                        null; // إعادة تعيين الأقساط لإخفاء زر الإرسال
                                  });
                                },
                              ),
                              SizedBox(height: 16),
                              if (monthlyPayment != null) ...[
                                SizedBox(height: 16),
                                Text(
                                  "سيتم خصم ${monthlyPayment!.toStringAsFixed(2)} كل شهر",
                                  style: GoogleFonts.baloo2(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colorss.mainColor),
                                ),
                              ],
                            ],
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: SafeArea(
                  child: KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                      return Padding(
                        padding:
                            EdgeInsets.only(bottom: isKeyboardVisible ? 10 : 0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (paymentMethod == "قسط" &&
                                    monthlyPayment == null) {
                                  _calculateInstallments(); // احسب الأقساط عند الحاجة
                                } else {
                                  _submitRequest(); // إرسال الطلب
                                }
                              },
                              child: Text(
                                (paymentMethod == "قسط" &&
                                        monthlyPayment == null)
                                    ? 'احسب الأقساط'
                                    : 'إرسال الطلب',
                                style: GoogleFonts.balooBhaijaan2(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colorss.mainColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 25),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
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
}
