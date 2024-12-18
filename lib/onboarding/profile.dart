import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // بيانات المستخدم
  String name = "Waled Ahmed";
  String address = "القاهرة، مصر";
  String email = "waled.ahmed@example.com";
  String phone = "+201234567890";
  String id = "12345";

  // الصورة الشخصية
  File? profileImage;

  // Controllers للحفاظ على البيانات عند التعديل
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    // تعيين القيم الأولية للـ TextEditingControllers
    nameController = TextEditingController(text: name);
    addressController = TextEditingController(text: address);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('الملف الشخصي'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
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
              _buildReadOnlyField(
                label: 'الرقم التعريفي',
                value: id,
                icon: Icons.badge,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('حفظ التغييرات', style: TextStyle(fontSize: 18)),
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
          labelText: label,
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


  void _saveChanges() {
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
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
