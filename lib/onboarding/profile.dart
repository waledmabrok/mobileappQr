import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // بيانات المستخدم
  String name = "";
  String address = "";
  String email = "";
  String phone = "";
  String id = "";
  String postion = "Flutter Developer";

  // الصورة الشخصية
  File? profileImage;

  // Controllers للحفاظ على البيانات عند التعديل
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController idController;
  late TextEditingController positionController;
  /*@override
  void initState() {
    super.initState();
    // تعيين القيم الأولية للـ TextEditingControllers
    nameController = TextEditingController(text: name);
    addressController = TextEditingController(text: address);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);
  }*/
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: name);
    addressController = TextEditingController(text: address);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);
    idController = TextEditingController(text: id);
    positionController = TextEditingController(text: postion);
    _fetchEmployeeData();
  }

// دالة لجلب البيانات
  Future<void> _fetchEmployeeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id'); // قراءة الـ user_id

    String url = 'https://demos.elboshy.com/attendance/wp-json/attendance/v1/employee/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = data['name'] ?? "";
          id = data['id']?.toString() ?? "";
          email = data['email'] ?? "";
          phone = data['phone'] ?? "";
          postion = data['position'] ?? "";
          nameController.text = name;
          emailController.text = email;
          phoneController.text = phone;
          idController.text = id;
          addressController.text = "الزقازيق";
        });
      } else {
        print("خطأ في جلب البيانات: ${response.statusCode}");
      }
    } catch (e) {
      print("حدث خطأ أثناء جلب البيانات: $e");
    }
  }
  void _saveChanges() async {
    String url = 'https://demos.elboshy.com/attendance/wp-json/attendance/v1/employee/1';

    Map<String, dynamic> updatedData = {
      "name": nameController.text,

      "email": emailController.text,
      "phone": phoneController.text,
      "position": postion,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        print("تم تحديث البيانات بنجاح");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.white),
                SizedBox(width: 10),
                Expanded(child: Text("تم التغيير بنجاح")),
              ],
            ),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        print("خطأ في تحديث البيانات: ${response.statusCode}");
      }
    } catch (e) {
      print("حدث خطأ أثناء تحديث البيانات: $e");
    }

    setState(() {
      name = nameController.text;
      address = addressController.text;
      email = emailController.text;
      phone = phoneController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('الملف الشخصي',style: GoogleFonts.cairo(),),
      /*  actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!) as ImageProvider
                      : AssetImage('assets/img1.jpg'),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildEditableField(
                label: 'الاسم',
                controller: nameController,
                icon: Icons.person,
              ),
              _buildEditableField(
                label: 'العنوان',
                controller: addressController,
                icon: Icons.location_on,
              ),
              _buildEditableField(
                label: 'البريد الإلكتروني',
                controller: emailController,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildEditableField(
                label: 'رقم الهاتف',
                controller: phoneController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
          _buildEditableField(
                label: 'الرقم التعريفي',
                //value: id,
                controller:idController,
                icon: Icons.badge,
              ),
              _buildEditableField(
                label: 'الوظيفه',
                controller:positionController,
                icon: Icons.computer,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // زوايا مستديرة
                  ),
                  shadowColor: Colors.black.withOpacity(0.5), // تأثير الظل
                  elevation: 5, // ارتفاع الظل
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save, color: Colors.white), // إضافة أيقونة
                    SizedBox(width: 8), // مسافة صغيرة بين الأيقونة والنص
                    Text(
                      'حفظ التغييرات',
                      style: GoogleFonts.cairo(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }


  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,

  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,labelStyle: GoogleFonts.cairo(),

          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }


  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: value,
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }


  /*void _saveChanges() {
    setState(() {
      name = nameController.text;
      address = addressController.text;
      email = emailController.text;
      phone = phoneController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check, color: Colors.white), // إضافة أيقونة
            SizedBox(width: 10),
            Expanded(
              child: Text("تم التغيير بنجاح"),
            ),
          ],
        ),
        backgroundColor: Colors.green, // تغيير لون الخلفية
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // تحديد قيمة الحافة الدائرية
        ),
        behavior: SnackBarBehavior.floating, // جعل SnackBar يطفو فوق المحتوى
      ),
    );
  }*/

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
