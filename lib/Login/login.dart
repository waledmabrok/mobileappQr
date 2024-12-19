import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../CustomApi/ApiLogin/LoginService.dart';
import '../onboarding/navgate.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Consumer<LoginController>(
        builder: (context, controller, _) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey, // Add form key here
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "من فضلك ادخل البيانات",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'BalooBhaijaan2',
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        // Username input with validator
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'الاسم',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'BalooBhaijaan2',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'من فضلك ادخل اسم المستخدم';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25),
                        // Password input with validator
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'الباسورد',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'BalooBhaijaan2',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscurePassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'من فضلك ادخل كلمة المرور';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40),
                        if (controller.errorMessage.isNotEmpty)
                          Text(
                            controller.errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        // Login Button
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF7557e4),
                                    Color(0xFF7585ec),
                                  ],
                                  stops: [0.3, 1.2],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  // Validate the form before attempting login
                                  if (_formKey.currentState?.validate() ?? false) {
                                    // If valid, proceed with login
                                    await controller.login(
                                      _usernameController.text,
                                      _passwordController.text,
                                    );

                                    if (controller.errorMessage.isEmpty) {
                                      // Navigate to HomeScreen after a successful login
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeScreen()),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontFamily: 'BalooBhaijaan2',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
