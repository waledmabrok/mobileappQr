import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ FieldsMachine/setup/MainColors.dart';
import '../../ FieldsMachine/setup/background.dart';
import '../profile.dart';
import 'DarkMode.dart';
import 'Wallet/Wallet.dart';
import 'custom section.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String useremail = '';
  String userProfilePicture = '';
  String position = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'غير معروف';
      userProfilePicture = prefs.getString('user_profile_picture') ?? '';
      useremail = prefs.getString('user_email') ?? '';
      position = prefs.getString('user_position') ?? '';
    });
  }

  Future<bool> _onWillPop() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return Future.value(false);
    } else {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              title: Center(
                child: Text(
                  "تأكيد الخروج",
                  style: GoogleFonts.balooBhaijaan2(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colorss.MainText,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              content: Text(
                "هل أنت متأكد أنك تريد الخروج؟",
                style: GoogleFonts.balooBhaijaan2(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colorss.SecondText,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // لا تغلق التطبيق
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colorss.mainColor,
                          side: BorderSide(color: Colorss.mainColor),
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "لا",
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // اغلق التطبيق
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colorss.mainColor,
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "نعم",
                          style: GoogleFonts.balooBhaijaan2(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 170.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.only(top: 140.0),
                child: Column(
                  children: [
                    CustomFrameWidget(
                      showThemeSwitch: true,
                      title: "الحساب",
                      options: [
                        OptionItem(
                          icon: Icons.person,
                          label: "معلومات شخصيه",
                          color: const Color(0xFF7A5AF8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()),
                            );
                          },
                        ),
                        OptionItem(
                          icon: Icons.wallet,
                          label: "المحفظه",
                          color: const Color(0xFF7A5AF8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Wallet()),
                            );
                          },
                        ),
                      ],
                    ),
                    CustomFrameWidget(
                      title: "الاعدادات",
                      options: [
                        OptionItem(
                          icon: Icons.lock,
                          label: "تغير الباسورد",
                          color: const Color(0xFF7A5AF8),
                          onTap: () {
                            Navigator.pushNamed(context, "/change_password");
                          },
                        ),
                        /*      OptionItem(
                          icon: Icons.settings,
                          label: "اعدادات",
                          color: const Color(0xFF7A5AF8),
                          onTap: () {
                            Navigator.pushNamed(context, "/darkMode");
                          },
                        ),*/
                        /*  OptionItem(
                          icon: Icons.help_outline,
                          label: "المساعده",
                          color: const Color(0xFF7A5AF8),
                          onTap: () {
                            print("FAQ and Help clicked");
                          },
                        ),*/
                        OptionItem(
                          icon: Icons.logout,
                          label: "تسجيل خروج",
                          color: const Color(0xFFF14E4E),
                          onTap: _onWillPop,
                          // Navigator.of(context).pop(true);
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20, // نفس قيمة الـ CSS top: 116px;
            left: MediaQuery.of(context).size.width / 2 -
                120 / 2, // نفس القيمة left: calc(50% - 120px / 2);
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "My Profile",
                  style: GoogleFonts.balooBhaijaan2(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                    image: userProfilePicture.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(userProfilePicture),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Positioned(
            top: 248,
            left: MediaQuery.of(context).size.width / 2 - 144 / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 144,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/checkdone.svg",
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              userName,
                              style: GoogleFonts.balooBhaijaan2(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                //  النصية للإيميل
                Container(
                  width: 144,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      useremail,
                      style: GoogleFonts.balooBhaijaan2(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 300, // نفس قيمة top: 274px;
            left: MediaQuery.of(context).size.width / 2 -
                156 / 2, // نفس القيمة left: calc(50% - 156px / 2);
            child: Container(
              width: 156,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Center(
                child: Text(
                  position,
                  style: GoogleFonts.balooBhaijaan2(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xFF7A5AF8),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  Widget _buildOptionContainer({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    //  var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, size: 18.0, color: Colors.black),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: GoogleFonts.balooBhaijaan2(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 15.0, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
