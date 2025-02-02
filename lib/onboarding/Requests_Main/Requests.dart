import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ FieldsMachine/setup/MainColors.dart';
import '../../CustomNavbar/Drawer.dart';
import '../../CustomNavbar/customnav.dart';
import '../../MainHome/CustomFilter.dart';

import '../../home/CustomMainHome/Leave.dart';

import '../calender.dart';

class RequestsMain extends StatefulWidget {
  final String selectedTab;
  static const routeName = "/All_requests";

  const RequestsMain({Key? key, this.selectedTab = "الكل"}) : super(key: key);

  @override
  State<RequestsMain> createState() => _RequestsMainState();
}

final _advancedDrawerController = AdvancedDrawerController();

class _RequestsMainState extends State<RequestsMain> {
  String selectedFilter = "الكل";
  DateTime? selectedDate;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  bool showFilters = true;
  late String selectedTab;
  String selectedStatus = "";
  bool isSelected = false;
  bool isVisible = false;

  List<LeaveCard> allRequests = [
    LeaveCard(
      requestType: "إجازة اعتيادية",
      requestTitle: "إجازة - 15 Apr 2023",
      status: "مقبول",
      details: {
        'detail1Label': "عدد أيام ",
        'detail1Value': "3 أيام",
        'detail2Label': "نوع الإجازة",
        'detail2Value': "اعتيادي",
        'approvedBy': "البوب",
      },
    ),
    LeaveCard(
      requestType: "سلف منتهيه",
      requestTitle: "سلفة - 5000 جنيه",
      status: "مقبول",
      details: {
        'detail1Label': "طريقة الدفع",
        'detail1Value': "قسط",
        'detail2Label': "الرصيد المتبقي",
        'detail2Value': "2000 جنيه",
        'approvedBy': "السيسي",
      },
    ),
    LeaveCard(
      requestType: "إذن  مرواح مبكر",
      requestTitle: "إذن خروج - 5 May 2023",
      status: "المراجعة",
      details: {
        'detail1Label': "المده المتبقية",
        'detail1Value': "4 ساعات",
        'detail2Label': "الرصيد المتبقي",
        'detail2Value': "3 ساعات",
        'approvedBy': "",
      },
    ),
    LeaveCard(
      requestType: "إجازة اعتيادية",
      requestTitle: "إجازة - 15 Apr 2023",
      status: "مرفوض",
      details: {
        'detail1Label': "عدد أيام ",
        'detail1Value': "3 أيام",
        'detail2Label': "نوع الإجازة",
        'detail2Value': "اعتيادي",
        'approvedBy': "البوب",
      },
    ),
    LeaveCard(
      requestType: "سلف قسط",
      requestTitle: "سلفة - 5000 جنيه",
      status: "المراجعة",
      details: {
        'detail1Label': "طريقة الدفع",
        'detail1Value': "قسط",
        'detail2Label': "الرصيد المتبقي",
        'detail2Value': "2000 جنيه",
        'approvedBy': "السيسي",
      },
    ),
    LeaveCard(
      requestType: "إذن  مرواح مبكر",
      requestTitle: "إذن خروج - 5 May 2023",
      status: "المراجعة",
      details: {
        'detail1Label': "المدة المتبقية",
        'detail1Value': "4 ساعات",
        'detail2Label': "الرصيد المتبقي",
        'detail2Value': "3 ساعات",
        'approvedBy': "",
      },
    ),
    LeaveCard(
      requestType: "إجازة عارضة",
      requestTitle: "إجازة - 15 Apr 2023",
      status: "مقبول",
      details: {
        'detail1Label': "عدد أيام ",
        'detail1Value': "3 أيام",
        'detail2Label': "نوع الإجازة",
        'detail2Value': "اعتيادي",
        'approvedBy': "البوب",
      },
    ),
    LeaveCard(
      requestType: "سلف كاش",
      requestTitle: "سلفة - 5000 جنيه",
      status: "المراجعة",
      details: {
        'detail1Label': "طريقة الدفع",
        'detail1Value': "كاش",
        'detail2Label': "الرصيد المتبقي",
        'detail2Value': "2000 جنيه",
        'approvedBy': "",
      },
    ),
    LeaveCard(
      requestType: "إذن  مرواح مبكر",
      requestTitle: "إذن خروج - 5 May 2023",
      status: "مقبول",
      details: {
        'detail1Label': "المدة المتبقية",
        'detail1Value': "4 ساعات",
        'detail2Label': "الرصيد المتبقي",
        'detail2Value': "3 ساعات",
        'approvedBy': "السيسي",
      },
    ),
    LeaveCard(
      requestType: "اذن تاخير",
      requestTitle: "اذن تاخير - 5 May 2023",
      status: "مقبول",
      details: {
        'detail1Label': "المدة المتبقية",
        'detail1Value': "4 ساعات",
        'detail2Label': "الرصيد المتبقي",
        'detail2Value': "3 ساعات",
        'approvedBy': "السيسي",
      },
    ),
    LeaveCard(
      requestType: "اذن نص يوم",
      requestTitle: "اذن نص يوم - 5 May 2023",
      status: "مقبول",
      details: {
        'detail1Label': "المدة المتبقية",
        'detail1Value': "4 ساعات",
        'detail2Label': "الرصيد المتبقي",
        'detail2Value': "3 ساعات",
        'approvedBy': "السيسي",
      },
    ),
  ];
  final Map<String, List<String>> filterOptions = {
    "الكل": ["الكل", "إجازة", "إذن خروج", "سلفة"],
    "الاجازات": ["الكل", "إجازة عارضة", "إجازة اعتيادية", "إجازة مرضية"],
    "الاذونات": ["الكل", "إذن مرواح مبكر", "اذن نص يوم", "اذن تاخير"],
    "السلف": ["الكل", "سلف كاش", "سلف قسط", "سلف منتهيه"],
  };

  List<LeaveCard> getFilteredRequests() {
    if (selectedTab == "الكل") {
      return allRequests;
    }

    String defaultFilter = filterOptions[selectedTab]![0];
    if (selectedFilter == defaultFilter) {
      return allRequests.where((request) {
        if (selectedTab == "الاجازات" &&
            (request.requestType == "إجازة مرضية" ||
                request.requestType == "إجازة اعتيادية" ||
                request.requestType == "إجازة عارضة")) {
          return true;
        }

        if (selectedTab == "الاذونات" &&
                request.requestType == "إذن  مرواح مبكر" ||
            request.requestType == "اذن نص يوم" ||
            request.requestType == "اذن تاخير") {
          return true;
        }
        if (selectedTab == "السلف" && request.requestType == "سلف منتهيه" ||
            request.requestType == "سلف قسط" ||
            request.requestType == "سلف كاش") {
          return true;
        }
        return false;
      }).toList();
    }

    // تصفية الطلبات بناءً على الفلتر المختار
    return allRequests
        .where((request) => request.requestType == selectedFilter)
        .toList();
  }

  Future<void> _selectMonth(BuildContext context) async {
    int selectedMonth = selectedDate?.month ?? DateTime.now().month;
    int selectedYear = selectedDate?.year ?? DateTime.now().year;
    String tempSelectedStatus = selectedStatus;
    bool isAllSelected = true;
    bool isApproved = true;
    bool isUnapproved = true;
    bool isPending = true;
    final List<String> months = [
      "يناير",
      "فبراير",
      "مارس",
      "أبريل",
      "مايو",
      "يونيو",
      "يوليو",
      "أغسطس",
      "سبتمبر",
      "أكتوبر",
      "نوفمبر",
      "ديسمبر"
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final FixedExtentScrollController monthController =
            FixedExtentScrollController(initialItem: selectedMonth - 1);
        final FixedExtentScrollController yearController =
            FixedExtentScrollController(
                initialItem: selectedYear - DateTime.now().year);

        double screenHeight = MediaQuery.of(context).size.height;
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              color: Theme.of(context).colorScheme.background,
              height: screenHeight < 850
                  ? screenHeight * 0.76
                  : screenHeight * 0.71,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'حدد التاريخ',
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          /*  decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xff7b68ee)),*/
                          child: Text(
                            ' ${months[selectedMonth - 1]} -  $selectedYear',
                            style: GoogleFonts.balooBhaijaan2(
                              fontSize: 16,
                              color: Colorss.mainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 170,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: ListWheelScrollView.useDelegate(
                                    controller: monthController,
                                    // ← استخدم المتحكم هنا
                                    itemExtent: 50,
                                    perspective: 0.004,
                                    magnification: 1.2,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        selectedMonth = index + 1;
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                      childCount: months.length,
                                      builder: (context, index) {
                                        bool isSelected =
                                            (index + 1) == selectedMonth;
                                        return Center(
                                          child: Text(
                                            months[index],
                                            style: GoogleFonts.balooBhaijaan2(
                                              fontSize: 20,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.grey[400],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: ListWheelScrollView.useDelegate(
                                    controller: yearController,
                                    itemExtent: 50,
                                    perspective: 0.004,
                                    magnification: 1.2,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        selectedYear =
                                            DateTime.now().year + index;
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                      childCount: 30,
                                      builder: (context, index) {
                                        int year = DateTime.now().year + index;
                                        bool isSelected = year == selectedYear;
                                        return Center(
                                          child: Text(
                                            '$year',
                                            style: GoogleFonts.balooBhaijaan2(
                                              fontSize: 20,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.grey[400],
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
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "الفلتر",
                          style: GoogleFonts.balooBhaijaan2(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RadioListTile<String>(
                          title:
                              Text("الكل", style: GoogleFonts.balooBhaijaan2()),
                          value: "الكل",
                          groupValue: selectedStatus,
                          contentPadding: EdgeInsets.zero,
                          selectedTileColor: Colorss.mainColor,
                          activeColor: Colorss.mainColor,
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Text("مقبول",
                              style: GoogleFonts.balooBhaijaan2()),
                          value: "مقبول",
                          groupValue: selectedStatus,
                          activeColor: Colorss.mainColor,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Text("مرفوض",
                              style: GoogleFonts.balooBhaijaan2()),
                          value: "مرفوض",
                          groupValue: selectedStatus,
                          activeColor: Colorss.mainColor,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Text("قيد المراجعة",
                              style: GoogleFonts.balooBhaijaan2()),
                          value: "قيد المراجعة",
                          groupValue: selectedStatus,
                          activeColor: Colorss.mainColor,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.grey.withOpacity(0.1),
                            ),
                            child: Text(
                              'إلغاء',
                              style: GoogleFonts.balooBhaijaan2(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedDate =
                                    DateTime(selectedYear, selectedMonth);
                                selectedStatus =
                                    tempSelectedStatus; // حفظ الفلتر المختار
                              });
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colorss.mainColor,
                            ),
                            child: Text(
                              'تأكيد',
                              style: GoogleFonts.balooBhaijaan2(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
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
      },
    );
  }

  @override
  void initState() {
    super.initState();
    selectedTab = widget.selectedTab;
  }

  @override
  Widget build(BuildContext context) {
    return CustomAdvancedDrawer(
      controller: _advancedDrawerController,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          //    backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      forceMaterialTransparency: true,
                      shadowColor: Colors.white,
                      forceElevated: false,
                      toolbarHeight: 80,
                      floating: true,
                      // snap: true,
                      //backgroundColor: Colors.white,
                      elevation: 2,
                      flexibleSpace: Container(
                        color: Theme.of(context).colorScheme.background,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: FaIcon(FontAwesomeIcons.arrowRight,
                                        size: 22),
                                  ),
                                  Text(
                                    selectedTab == "الاجازات"
                                        ? 'سجل الإجازات'
                                        : selectedTab == "الاذونات"
                                            ? 'سجل الإذن'
                                            : selectedTab == "السلف"
                                                ? 'سجل السلف'
                                                : 'الطلبات',
                                    // Default case if no filter is selected
                                    style: GoogleFonts.balooBhaijaan2(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    selectedDate != null
                                        ? '${selectedDate?.month} - ${selectedDate?.year}'
                                        : '',
                                    // Hide text if no date is selected
                                    style: GoogleFonts.balooBhaijaan2(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isVisible = !isVisible;
                                          });
                                        },
                                        icon: FaIcon(
                                          FontAwesomeIcons.chartSimple,
                                          size: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _selectMonth(context),
                                        icon: FaIcon(
                                          FontAwesomeIcons.sliders,
                                          size: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // أزرار الفئات
                    SliverToBoxAdapter(
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10, top: 10),
                            child: Row(
                              children: [
                                CustomNotificationWidget(
                                  isSelected: selectedTab == "الكل",
                                  onTap: () {
                                    setState(() {
                                      selectedTab = "الكل";
                                      selectedFilter = "الكل";
                                      showFilters = true;
                                    });
                                  },
                                  iconPath: "assets/Customhome/list.svg",
                                  label: 'الكل',
                                ),
                                SizedBox(width: 15),
                                CustomNotificationWidget(
                                  isSelected: selectedTab == "الاجازات",
                                  onTap: () {
                                    setState(() {
                                      showFilters = false;
                                      selectedTab = "الاجازات";
                                      selectedFilter = "الكل";
                                    });
                                  },
                                  iconPath:
                                      "assets/Customhome/calendar-svgrepo-com.svg",
                                  label: 'الاجازات',
                                ),
                                SizedBox(width: 15),
                                CustomNotificationWidget(
                                  isSelected: selectedTab == "الاذونات",
                                  onTap: () {
                                    setState(() {
                                      showFilters = false;
                                      selectedTab = "الاذونات";
                                      selectedFilter = "الكل";
                                    });
                                  },
                                  iconPath:
                                      "assets/Customhome/permissions-svgrepo-com.svg",
                                  label: 'الاذونات',
                                ),
                                SizedBox(width: 15),
                                CustomNotificationWidget(
                                  isSelected: selectedTab == "السلف",
                                  onTap: () {
                                    setState(() {
                                      showFilters = false;
                                      selectedTab = "السلف";
                                      selectedFilter = "الكل";
                                    });
                                  },
                                  iconPath:
                                      "assets/Customhome/loan-interest-time-value-of-money-effective-svgrepo-com.svg",
                                  label: 'السٌلَف',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // إحصائيات
                    if (isVisible)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              StatCard2(
                                title: 'طلبات الاجازات',
                                value: '05/10',
                                borderColor: Colors.blue,
                                backgroundColor: Colors.blue[50]!,
                              ),
                              SizedBox(height: 10),
                              StatCard2(
                                title: 'الاجازات الاعتياديه',
                                value: '15/21',
                                borderColor: Colors.green,
                                backgroundColor: Colors.green[50]!,
                              ),
                              SizedBox(height: 10),
                              StatCard2(
                                title: 'الاجازات المرضية',
                                value: '15/21',
                                borderColor: Colors.red,
                                backgroundColor: Colors.red[50]!,
                              ),
                              SizedBox(height: 10),
                              StatCard2(
                                title: 'الاجازات العارضة',
                                value: '10/5 ',
                                borderColor: Colors.indigo,
                                backgroundColor: Colors.indigo[50]!,
                              ),
                            ],
                          ),
                        ),
                      ),

                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color:
                                Theme.of(context).colorScheme.surfaceVariant),
                        child: Column(
                          children: [
                            if (!showFilters)
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 20.0,
                                  top: 20,
                                ),
                                child: buildFilterChips(),
                              ),

                            // ✅ قائمة الطلبات
                            getFilteredRequests().isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 20,
                                        bottom: 80),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: getFilteredRequests().length,
                                    itemBuilder: (context, index) {
                                      return getFilteredRequests()[index];
                                    },
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Center(
                                      child: Text(
                                        "لا توجد طلبات متاحة",
                                        style: GoogleFonts.balooBhaijaan2(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
          )),
    );
  }

  Widget buildFilterChips() {
    if (selectedTab == "الكل" && selectedFilter == "الكل")
      return SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filterOptions[selectedTab]!.map((filter) {
          return FilterChipWidget(
            label: filter,
            isSelected: selectedFilter == filter,
            onSelected: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            required: false,
          );
        }).toList(),
      ),
    );
  }
}

class StatCard2 extends StatelessWidget {
  final String title;
  final String value;
  final Color borderColor;
  final Color backgroundColor;

  StatCard2({
    required this.title,
    required this.value,
    required this.borderColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(15),
          color: backgroundColor.withOpacity(0.2),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.balooBhaijaan2(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                value,
                style: GoogleFonts.balooBhaijaan2(
                    color: borderColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
