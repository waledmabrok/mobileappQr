import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ FieldsMachine/setup/MainColors.dart';
import '../profile.dart';

class ProfilePage extends StatefulWidget {

  @override

  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String useremail = '';
  String userProfilePicture = '';
  @override
  void initState() {
    super.initState();
    _loadUserData();  // استرجاع بيانات المستخدم عند تحميل الصفحة
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'غير معروف';  // استرجاع الاسم
      userProfilePicture = prefs.getString('user_profile_picture') ?? '';  // استرجاع الصورة
      useremail = prefs.getString('user_email') ?? '';  // استرجاع الصورة
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text(
          "الحساب الشخصي",
          style: GoogleFonts.balooBhaijaan2(

            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colorss.mainColor,
                            width: 2.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child:    userProfilePicture.isNotEmpty
                              ? CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(userProfilePicture),
                          )
                              :Icon(Icons.person, size: 100),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName, // بيانات ثابتة
                            style: GoogleFonts.balooBhaijaan2(

                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            useremail, // بيانات ثابتة
                            style: GoogleFonts.balooBhaijaan2(

                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 7,
                  color: Colors.grey[200],
                ),
              ],
            ),

          Column(
              children: [
                _buildOptionContainer(
                  icon: Icons.person_outline,
                  text: "الحساب الشخصي",
                  onTap: () {
                    // الانتقال إلى صفحة الحساب الشخصي
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                ),
                _buildOptionContainer(
                  icon: Icons.schedule,
                  text: "الغياب",
                  onTap: () {
                    // الانتقال إلى صفحة الغياب
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AbsencePage(),
                      ),
                    );
                  },
                ),
                _buildOptionContainer(
                  icon: Icons.settings,
                  text: "الحسابات",
                  onTap: () {
                    // الانتقال إلى صفحة الحسابات
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
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
                Icon(icon, size: 20.0, color: Colors.black),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: GoogleFonts.balooBhaijaan2(

                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )
              ],
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 15.0, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}


class AbsencePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الغياب"),
        centerTitle: true,
      ),
      body: Center(child: Text("محتوى الغياب هنا")),
    );
  }
}

class AccountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الحسابات"),
        centerTitle: true,
      ),
      body: Center(child: Text("محتوى الحسابات هنا")),
    );
  }
}
