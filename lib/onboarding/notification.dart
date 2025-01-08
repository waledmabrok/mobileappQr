import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ FieldsMachine/setup/MainColors.dart';
import 'calender.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String userName = '';
  String useremail = '';
  String userProfilePicture = '';
  String position = "";
  bool required = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]['isRead'] = true;
    });
  }

  List<Map<String, dynamic>> notifications = [
    {
      'title': 'انذار',
      'content': 'إشعار انذار: "التأخير نص ساعة عن معاد عملك"',
      'date': ' 10 دقائق',
      'isRead': false,
      'icon': 'assets/SvgNotifi/alert.svg',
      'icon2': 'assets/Calender/OIP (1).jpeg',
    },
    {
      'title': 'طلب اجازة',
      'content': 'إشعار الإجازات: "تم الموافقة على إجازتك"',
      'date': ' 1 ساعة',
      'isRead': true,
      'icon': 'assets/SvgNotifi/Notifi.svg',
      'icon2': 'assets/Calender/OIP (1).jpeg',
    },
  ];

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'غير معروف';
      userProfilePicture = prefs.getString('user_profile_picture') ?? '';
      useremail = prefs.getString('user_email') ?? '';
      position = prefs.getString('user_position') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> unreadNotifications =
        notifications.where((notification) => !notification['isRead']).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Positioning Widgets for Background (as in your original code)
          Positioned(
            top: 0,
            left: 0,
            child: SvgPicture.asset("assets/top_shap.svg"),
          ),
          Positioned(
            top: 247,
            right: 0,
            child: Container(
              child: SvgPicture.asset("assets/center_shap.svg"),
            ),
          ),
          Positioned(
            bottom: 18,
            left: 0,
            child: Container(
              child: SvgPicture.asset("assets/bottom_shap.svg"),
            ),
          ),
          Positioned(
            top: 382,
            left: 33,
            child: Container(
              child: SvgPicture.asset("assets/3right.svg"),
            ),
          ),
          Positioned(
            top: 382,
            right: 0,
            child: Opacity(
              opacity: 0.3,
              child: Container(
                child: SvgPicture.asset("assets/4center.svg"),
              ),
            ),
          ),

          // Header Section
          Padding(
            padding: const EdgeInsets.only(top: 45.0, right: 15),
            child: Container(
              alignment: Alignment.topRight,
              width: double.infinity,
              child: Row(
                children: [
                  Image.asset(
                    'assets/img.png',
                    width: 25,
                    height: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'الإشعارات',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.balooBhaijaan2(
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                      height: 51 / 32,
                      letterSpacing: 0.03,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Your content here (Notifications, etc.)
          Padding(
            padding: const EdgeInsets.only(top: 180.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align content to the left
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20.0,
                    ), // Add padding to the right and top
                    child: Text(
                      "الاحدث",
                      textAlign: TextAlign.right, // Correct textAlign usage
                      style: GoogleFonts.balooBhaijaan2(
                        fontWeight: FontWeight.w700, // Optional: make text bold
                        fontSize: 18, // Optional: adjust font size
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_tabController.index == 1)
                    ...unreadNotifications.map((notification) {
                      return NotificationCard(
                        title: notification['title'],
                        content: notification['content'],
                        date: notification['date'],
                        icon: notification['icon'],
                        icon2: notification['icon2'],
                        isRead: notification['isRead'],
                      );
                    }).toList(),
                  if (_tabController.index == 1)
                    ...unreadNotifications.map((notification) {
                      return NotificationCard(
                        title: notification['title'],
                        content: notification['content'],
                        date: notification['date'],
                        icon: notification['icon'],
                        icon2: notification['icon2'],
                        isRead: notification['isRead'],
                      );
                    }).toList(),
                  // Add some space between the title and notifications
                  NotificationCard(
                    title: 'انذار',
                    content: 'إشعار انذار : "التاخير نص ساعه عن معاد عملك"',
                    date: ' 10 دقائق',
                    icon: 'assets/SvgNotifi/alert.svg',
                    icon2: 'assets/SvgNotifi/alert.svg',
                    required: true,
                  ),
                  NotificationCard(
                    title: 'طلب اجازة',
                    content:
                        'إشعار الإجازات : "تم الموافقة على إجازتك من تاريخ [1/11/2023] إلى تاريخ [1/12/2023]. استمتع بإجازتك!"',
                    date: ' 1 ساعه',
                    icon: 'assets/SvgNotifi/Notifi.svg',
                    icon2: 'assets/SvgNotifi/Notifi.svg',
                    requiredColor: Colorss.mainColor,
                    required: true,
                    //       required: true,
                  ),
                  NotificationCard(
                      title: 'طلب اجازة',
                      content:
                          'إشعار الإجازات : "تم الموافقة على إجازتك من تاريخ [1/11/2023] إلى تاريخ [1/12/2023]. استمتع بإجازتك!"',
                      date: ' 13 ساعه',
                      icon: 'assets/SvgNotifi/Notifi.svg',
                      icon2: 'assets/SvgNotifi/Notifi.svg',
                      requiredColor: Colorss.mainColor,
                      isLast: true),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 20),
                    child: Text(
                      "الاقدم",
                      textAlign: TextAlign.right, // Correct textAlign usage
                      style: GoogleFonts.balooBhaijaan2(
                        fontWeight: FontWeight.w700, // Optional: make text bold
                        fontSize: 18, // Optional: adjust font size
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  NotificationCard(
                    title: 'طلب اجازة',
                    content:
                        'إشعار الإجازات : "تم الموافقة على إجازتك من تاريخ [1/11/2023] إلى تاريخ [1/12/2023]. استمتع بإجازتك!"',
                    date: ' 24 ساعه',
                    icon: 'assets/SvgNotifi/Notifi.svg',
                    icon2: 'assets/SvgNotifi/Notifi.svg',
                    requiredColor: Colorss.mainColor,
                  ),
                  NotificationCard(
                    title: 'طلب اجازة',
                    content:
                        'إشعار الإجازات : "تم الموافقة على إجازتك من تاريخ [1/11/2023] إلى تاريخ [1/12/2023]. استمتع بإجازتك!"',
                    date: ' 24 ساعه',
                    icon: 'assets/SvgNotifi/Notifi.svg',
                    icon2: 'assets/SvgNotifi/Notifi.svg',
                    requiredColor: Colorss.mainColor,
                  ),
                  NotificationCard(
                    title: 'طلب اجازة',
                    content:
                        'إشعار الإجازات : "تم الموافقة على إجازتك من تاريخ [1/11/2023] إلى تاريخ [1/12/2023]. استمتع بإجازتك!"',
                    date: ' 24 ساعه',
                    icon: 'assets/SvgNotifi/Notifi.svg',
                    icon2: 'assets/SvgNotifi/Notifi.svg',
                    requiredColor: Colorss.mainColor,
                  ),
                  NotificationCard(
                      title: 'طلب اجازة',
                      content:
                          'إشعار الإجازات : "تم الموافقة على إجازتك من تاريخ [1/11/2023] إلى تاريخ [1/12/2023]. استمتع بإجازتك!"',
                      date: ' 24 ساعه',
                      icon: 'assets/SvgNotifi/Notifi.svg',
                      icon2: 'assets/SvgNotifi/Notifi.svg',
                      requiredColor: Colorss.mainColor,
                      isLast: true),

                  SizedBox(
                    height: 110,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 115.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              width: double.infinity,
              child: DefaultTabController(
                  length: 6,
                  child: TabBar(
                    labelPadding: EdgeInsets.symmetric(horizontal: 0),
                    overlayColor: const WidgetStatePropertyAll(Colors.white),
                    automaticIndicatorColorAdjustment: false,
                    controller: _tabController,
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    dividerHeight: 0,
                    dividerColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabAlignment: TabAlignment.start,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(color: Colors.white),
                    indicatorColor: Colors.white,
                    onTap: (index) {
                      setState(() {
                        _tabController.index = index;
                      });
                    },
                    tabs: [
                      Tab(
                        child: FilterChipWidget(
                          label: 'الكل',
                          isSelected: _tabController.index == 0,
                          onSelected: () {
                            setState(() {
                              _tabController.index = 0;
                            });
                          },
                          required: false,
                        ),
                      ),
                      Tab(
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                FilterChipWidget(
                                  label: 'غير مقروء',
                                  isSelected: _tabController.index == 1,
                                  onSelected: () {
                                    setState(() {
                                      required = false;
                                      _tabController.index = 1;
                                      for (var notification in notifications) {
                                        notification['isRead'] = true;
                                      }
                                    });
                                  },
                                  required: required,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: FilterChipWidget(
                          label: 'الغياب',
                          isSelected: _tabController.index == 2,
                          onSelected: () {
                            setState(() {
                              _tabController.index = 2;
                            });
                          },
                          required: false,
                        ),
                      ),
                      Tab(
                        child: FilterChipWidget(
                          label: 'الحضور',
                          isSelected: _tabController.index == 3,
                          onSelected: () {
                            setState(() {
                              _tabController.index = 3;
                            });
                          },
                          required: false,
                        ),
                      ),
                      Tab(
                        child: FilterChipWidget(
                          label: 'الاجازات',
                          isSelected: _tabController.index == 4,
                          onSelected: () {
                            setState(() {
                              _tabController.index = 4;
                            });
                          },
                          required: false,
                        ),
                      ),
                      Tab(
                        child: FilterChipWidget(
                          label: 'الانذارات',
                          isSelected: _tabController.index == 5,
                          onSelected: () {
                            setState(() {
                              _tabController.index = 5;
                            });
                          },
                          required: false,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String icon;
  final String icon2;
  final Color requiredColor;
  final bool isRead;
  final bool required;
  final bool isLast; // Add this property to determine if it's the last item

  NotificationCard({
    required this.title,
    required this.content,
    required this.date,
    required this.icon,
    required this.icon2,
    this.requiredColor = Colors.red,
    this.isRead = false,
    this.required = false,
    this.isLast = false, // Initialize it with false by default
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: required
                ? LinearGradient(
                    colors: [
                      Color(0xffF2F8FF),
                      Colors.white,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  )
                : null,
            color: required ? null : Colors.white.withOpacity(0.8),
            //  borderRadius: BorderRadius.circular(6),
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: Colorss.BorderColor,
                      width: 1,
                    ),
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 25, bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: requiredColor.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        width: 35,
                        height: 35,
                        icon2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 16,
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                title,
                                                style:
                                                    GoogleFonts.balooBhaijaan2(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                          Divider(
                                              thickness: 1,
                                              color: Colors.grey.shade300),
                                          SizedBox(height: 10),
                                          Text(
                                            content,
                                            style: GoogleFonts.balooBhaijaan2(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              height: 1.5,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                children: content.split(" ").map((word) {
                                  return TextSpan(
                                    text: word + " ",
                                    style: (word.contains("الإجازات") ||
                                            word.contains("انذار"))
                                        ? GoogleFonts.balooBhaijaan2(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            height: 1.5,
                                            color: Colors.black,
                                          )
                                        : GoogleFonts.balooBhaijaan2(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            height: 1.5,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                  );
                                }).toList(),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: GoogleFonts.balooBhaijaan2(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Color(0xffC2C2C2),
                                ),
                              ),
                              SizedBox(width: 2),
                              Text(
                                ".",
                                style: GoogleFonts.balooBhaijaan2(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xffC2C2C2),
                                ),
                              ),
                              SizedBox(width: 2),
                              Text(
                                "Teamleader",
                                style: GoogleFonts.balooBhaijaan2(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    if (required)
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colorss.mainColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
        /* if (!isLast) // Only show the divider if it's not the last item
          Divider(
            thickness: 1,
            color: Colors.grey.shade300,
            indent: 15,
            endIndent: 15,
          ),*/
      ],
    );
  }
}
