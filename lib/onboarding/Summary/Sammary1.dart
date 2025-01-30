import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../ FieldsMachine/FieldsContext/Button.dart';
import '../../ FieldsMachine/FieldsContext/Text.dart';
import '../../ FieldsMachine/setup/MainColors.dart';
import '../Requests_Main/Requests.dart';

class LeaveRequestPage extends StatefulWidget {
  static const routeName = "/request_summary";

  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedReason;
  String selectedLeaveType = 'اعتيادية';

  TextEditingController reasonController = TextEditingController();
  int? _expandedIndex;

  // خريطة تربط أنواع الإجازات بالأسئلة الشائعة الخاصة بها
  final List<Map<String, String>> faqs = [
    {
      "question": "ماهي الإجازة الاعتيادية؟",
      "answer": "الإجازة الاعتيادية هي إجازة يجب أن يتوفر بها الشروط التالية:\n\n"
          "1- يجب طلبها قبل تاريخ البداية بـ 48 ساعة على الأقل.\n"
          "2- يتم خصم مبلغ من المرتب عليها، ويكون المبلغ ثابت ويتم تحديده للفئة هذه."
    },
    {
      "question": "ماهي الإجازة العارضة؟",
      "answer":
          "الإجازة العارضة هي إجازة بسبب حدث مفاجئ، حيث يتم الإبلاغ عنها في يوم الإجازة نفسه أو قبلها بـ 24 ساعة. "
              "الشروط هي:\n\n"
              "1- أقصى مدة للإجازة هي يومين فقط.\n"
              "2- يتم خصم مبلغ من المرتب عليها، ويكون المبلغ ثابت ويتم تحديده للفئة هذه."
    },
    {
      "question": "ماهي الإجازة المرضية؟",
      "answer": "الإجازة المرضية هي إجازة بسبب حالة مرضية مفاجئة، ويتم الإبلاغ عنها في نفس اليوم أو قبلها بـ 24 ساعة. "
          "الشروط هي:\n\n"
          "1- يمكن الإبلاغ عنها في نفس اليوم أو قبلها بـ 24 ساعة مثل الإجازة العارضة.\n"
          "2- قد تكون الإجازة بدون خصم رسوم أو بخصم 50% من سعر اليوم.\n"
          "3- يتم خصم مبلغ من المرتب عليها، ويكون المبلغ ثابت ويتم تحديده للفئة هذه."
    },
  ];

  // Function to pick dates
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(2101);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  // Function to handle leave request submission

  void _submitLeaveRequest() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        // تغيير لون الخلفية
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // تحديد قيمة الحافة الدائرية
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
                  selectedTab: 'الاجازات',
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
      // backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'طلب إجازة',
          style: GoogleFonts.balooBhaijaan2(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 25),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.balooBhaijaan2(fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'تحديد تاريخ من وإلى',
              style: GoogleFonts.balooBhaijaan2(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colorss.BorderColor),
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        /*  boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 6)
                        ],*/
                      ),
                      child: Text(
                        startDate == null
                            ? 'اختيار تاريخ البداية'
                            : DateFormat('yyyy-MM-dd').format(startDate!),
                        style: GoogleFonts.balooBhaijaan2(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colorss.BorderColor),
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        /* boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 6)
                        ],*/
                      ),
                      child: Text(
                        endDate == null
                            ? 'اختيار تاريخ النهاية'
                            : DateFormat('yyyy-MM-dd').format(endDate!),
                        style: GoogleFonts.balooBhaijaan2(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'تحديد نوع الإجازة',
              style: GoogleFonts.balooBhaijaan2(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedLeaveType = 'اعتيادية';
                        _expandedIndex =
                            0; // تحديد الفهرس المناسب للأسئلة الشائعة
                      });
                    },
                    child: Text(
                      'اعتيادية',
                      style: GoogleFonts.balooBhaijaan2(
                        color: selectedLeaveType == 'اعتيادية'
                            ? Colors.white
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shadowColor: Theme.of(context).colorScheme.surfaceVariant,
                      backgroundColor: selectedLeaveType == 'اعتيادية'
                          ? Colorss.mainColor
                          : Theme.of(context).colorScheme.surfaceVariant,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedLeaveType = 'عارضة';
                        _expandedIndex =
                            1; // تحديد الفهرس المناسب للأسئلة الشائعة
                      });
                    },
                    child: Text(
                      'عارضة',
                      style: GoogleFonts.balooBhaijaan2(
                        color: selectedLeaveType == 'عارضة'
                            ? Colors.white
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shadowColor: Theme.of(context).colorScheme.surfaceVariant,
                      backgroundColor: selectedLeaveType == 'عارضة'
                          ? Colorss.mainColor
                          : Theme.of(context).colorScheme.surfaceVariant,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedLeaveType = 'مرضية';
                        _expandedIndex =
                            2; // تحديد الفهرس المناسب للأسئلة الشائعة
                      });
                    },
                    child: Text(
                      'مرضية',
                      style: GoogleFonts.balooBhaijaan2(
                        color: selectedLeaveType == 'مرضية'
                            ? Colors.white
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shadowColor: Theme.of(context).colorScheme.surfaceVariant,
                      backgroundColor: selectedLeaveType == 'مرضية'
                          ? Colorss.mainColor
                          : Theme.of(context).colorScheme.surfaceVariant,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'تحديد سبب الإجازة',
              style: GoogleFonts.balooBhaijaan2(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: CustomText(
                hintText: "سبب الاجازه",
              ),
            ),
            SizedBox(height: 30),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: faqs.asMap().entries.map((entry) {
                  int index = entry.key;
                  var faq = entry.value;
                  bool isExpanded = _expandedIndex == index;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _expandedIndex = isExpanded ? null : index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    faq["question"]!,
                                    style: GoogleFonts.balooBhaijaan2(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      height: 1.9,
                                    ),
                                  ),
                                ),
                                FaIcon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: isExpanded
                                      ? Colorss.mainColor
                                      : Theme.of(context).colorScheme.onPrimary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              faq["answer"]!,
                              style: GoogleFonts.balooBhaijaan2(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                                height: 1.9,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40, top: 20, bottom: 10),
              child: CustomButton(
                  text: 'تقديم الطلب', onPressed: _submitLeaveRequest),
            ),
          ],
        ),
      ),
    );
  }
}
