import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http_parser/http_parser.dart';

import '../ FieldsMachine/FieldsContext/Button.dart';
import '../ FieldsMachine/FieldsContext/Text.dart';
import '../ FieldsMachine/setup/background.dart';

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

    String url =
        'https://demos.elboshy.com/attendance/wp-json/attendance/v1/employee?id=$userId';

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
        _showSnackBar(
            "خطأ في جلب البيانات: ${response.statusCode}", Colors.red);
      }
    } catch (e) {
      _showSnackBar("حدث خطأ أثناء جلب البيانات: $e", Colors.red);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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

    String url =
        'https://demos.elboshy.com/attendance/wp-json/attendance/v1/employee';

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
      body: isLoading
          ? Center(child: _buildSkeleton())
          : Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 20, right: 20),
                            child: Row(
                              children: [
                                // Ellipse with Icon (Arrow Left)
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(
                                        context); // هذا يرجع إلى الشاشة السابقة
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(
                                          0xFFE1E0F3), // Ellipse background color
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          // You can replace this with another icon or image
                                          size: 16,
                                          color: Color(0xff7A5AF8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Title Text
                                SizedBox(
                                  width: 60,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'الحساب الشخصي', // Your title in Arabic
                                    style: GoogleFonts.balooBhaijaan2(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              // Frame
                              Container(
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  //   color: Color(0xFFFEFEFE),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    // Photo Upload Section
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        // Circle Image
                                        Container(
                                          width: 110,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                                color: Colors.white, width: 1),
                                            image: DecorationImage(
                                              image: profileImage != null
                                                  ? FileImage(profileImage!)
                                                  : _profileImageUrl != null &&
                                                          _profileImageUrl!
                                                              .isNotEmpty
                                                      ? CachedNetworkImageProvider(
                                                          _profileImageUrl!)
                                                      : AssetImage(
                                                              'assets/images/emptyimage.jpg')
                                                          as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        // Ellipse 22 (absolute positioning)
                                        Positioned(
                                          bottom: -5,
                                          right: -5,
                                          child: InkWell(
                                            onTap: _pickImage,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25)),
                                                color: Colors.white,
                                              ),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(25)),
                                                  color: Color(0xFF7585ec),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 3),
                                                ),
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),

                                    // Input Fields Section
                                    CustomText(
                                      isRequired: true,
                                      controller: nameController,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CustomText(
                                      isRequired: true,
                                      controller: positionController,
                                      hintText: 'الوظيفه',
                                      prefixIcon: Icons.computer,
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),
                                    CustomText(
                                      isRequired: true,
                                      hintText: 'البريد الإلكتروني',
                                      controller: emailController,
                                      prefixIcon: Icons.email,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CustomText(
                                      isRequired: true,
                                      hintText: 'رقم الهاتف',
                                      controller: phoneController,
                                      prefixIcon: Icons.phone,
                                    ),
                                    SizedBox(height: 20),
                                    CustomText(
                                      isRequired: true,
                                      hintText: 'العنوان',
                                      controller: addressController,
                                      prefixIcon: Icons.location_on,
                                    ),

                                    ///=============================
                                    ///
                                  ],
                                ),
                              ),

                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(55.0),
                          child: CustomButton(
                              text: 'تحديث بيانات', onPressed: _saveChanges),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            label,
            style: GoogleFonts.balooBhaijaan2(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xFF475467),
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              //  color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFDFE2E8)),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: Icon(icon),

                border: InputBorder.none, // التصحيح هنا
              ),
              keyboardType: keyboardType,
            ),
          )
        ]));
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
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(30),
    ),
  );
}

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

// Method to create an input field
Widget _buildInputField(String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.balooBhaijaan2(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFF475467),
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 44,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFDFE2E8)),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: ' ادخل $label',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}
