import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http_parser/http_parser.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String address = "";
  String email = "";
  String phone = "";
  String id = "";
  String position = "";
  bool isLoading = true;
  File? profileImage;
  String? _profileImageUrl;

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController idController;
  late TextEditingController positionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    addressController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    idController = TextEditingController();
    positionController = TextEditingController();
    _fetchEmployeeData();
    _loadProfileImage();
  }

  void _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileImagePath = prefs.getString('profile_image_path');
    if (profileImagePath != null && profileImagePath.isNotEmpty) {
      setState(() {
        profileImage = File(profileImagePath);
      });
    }
  }

  Future<void> _fetchEmployeeData() async {
    if (name.isNotEmpty) {
      return; // البيانات محملة مسبقًا
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    String url = 'https://demos.elboshy.com/attendance/wp-json/attendance/v1/employee?id=$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = data['name'] ?? "";
          id = data['id']?.toString() ?? "";
          email = data['email'] ?? "";
          phone = data['phone'] ?? "";
          position = data['position'] ?? "";
          address = data['address'] ?? "";
          _profileImageUrl = data['profile_picture'];
          nameController.text = name;
          emailController.text = email;
          phoneController.text = phone;
          idController.text = id;
          addressController.text = address;
          positionController.text = position;
          isLoading = false;
        });
      } else {
        _showSnackBar("خطأ في جلب البيانات: ${response.statusCode}", Colors.red);
      }
    } catch (e) {
      _showSnackBar("حدث خطأ أثناء جلب البيانات: $e", Colors.red);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', pickedFile.path);
    } else {
      _showSnackBar('لم يتم اختيار أي صورة', Colors.orange);
    }
  }

  void _saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // تحقق من الحقول الفارغة
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      _showSnackBar("يرجى ملء جميع الحقول الضرورية", Colors.red);
      return;
    }

    String url = 'https://demos.elboshy.com/attendance/wp-json/attendance/v1/employee';

    Map<String, String> updatedData = {
      "id": idController.text,
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "position": positionController.text,
      "address": addressController.text,
    };

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      updatedData.forEach((key, value) {
        request.fields[key] = value;
      });

      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profileImage!.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        // تفريغ البيانات القديمة من SharedPreferences
        await prefs.clear();

        // تخزين البيانات الجديدة
        await prefs.setString('user_id', idController.text);
        await prefs.setString('name', nameController.text);
        await prefs.setString('email', emailController.text);
        await prefs.setString('phone', phoneController.text);
        await prefs.setString('position', positionController.text);
        await prefs.setString('address', addressController.text);

        if (profileImage != null) {
          await prefs.setString('profile_image_path', profileImage!.path);
        }

        setState(() {
          name = nameController.text;
          email = emailController.text;
          phone = phoneController.text;
          position = positionController.text;
          address = addressController.text;
        });

        _showSnackBar("تم تحديث البيانات بنجاح", Colors.green);
      } else {
        _showSnackBar("حدث خطأ أثناء التحديث", Colors.red);
      }
    } catch (e) {
      _showSnackBar("حدث خطأ أثناء الاتصال بالخادم", Colors.red);
    }
  }


  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('الملف الشخصي', style: GoogleFonts.cairo()),
      ),
      body: isLoading
          ? Center(child: _buildSkeleton())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Container(
                    width: 80,
                    height: 80,
                    child: profileImage != null
                        ? Image.file(profileImage!, fit: BoxFit.cover)
                        : _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: _profileImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                        : Image.asset('assets/images/emptyimage.jpg', fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildEditableField(label: 'الاسم', controller: nameController, icon: Icons.person),
              _buildEditableField(label: 'العنوان', controller: addressController, icon: Icons.location_on),
              _buildEditableField(label: 'البريد الإلكتروني', controller: emailController, icon: Icons.email, keyboardType: TextInputType.emailAddress),
              _buildEditableField(label: 'رقم الهاتف', controller: phoneController, icon: Icons.phone, keyboardType: TextInputType.phone),
            //  _buildEditableField(label: 'الرقم التعريفي', controller: idController, icon: Icons.badge),
              _buildEditableField(label: 'الوظيفة', controller: positionController, icon: Icons.computer),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  shadowColor: Colors.black.withOpacity(0.5),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'حفظ التغييرات',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0)),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
Widget _buildSkeleton() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSkeletonAvatar(),
          SizedBox(height: 20),
          _buildSkeletonField(),
          _buildSkeletonField(),
          _buildSkeletonField(),
          _buildSkeletonField(),
          _buildSkeletonField(),
          _buildSkeletonField(),
          SizedBox(height: 20),
          _buildSkeletonButton(),
        ],
      ),
    ),
  );
}

// اسكتلون للصورة
Widget _buildSkeletonAvatar() {
  return Container(
    width: 160,
    height: 160,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(80),
    ),
  );
}

// اسكتلون للحقل النصي
Widget _buildSkeletonField() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

// اسكتلون للزر
Widget _buildSkeletonButton() {
  return Container(
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(25),
    ),
  );
}
