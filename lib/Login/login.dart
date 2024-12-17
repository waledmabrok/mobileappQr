import 'package:flutter/material.dart';

import '../home/home.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String errorMessage = '';
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // تحقق من اسم المستخدم وكلمة المرور
    if (username == 'admin' && password == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BarcodeScanner()),
      );
    } else {
      setState(() {
        errorMessage = 'اسم المستخدم أو كلمة المرور غير صحيحة';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
           /*     Image.asset('assets/logo-icon__1__1_.png',
                    width: 100,
                    height: 100),*/ // Adjust path to your logo

                SizedBox(height: 10),

                SizedBox(height: 10),
                Center(
                    child: Text(
                      "من فضلك ادخل البيانات",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'BalooBhaijaan2',
                      ),
                    )),
                SizedBox(height: 25),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(0xffefefef),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'اسم المستخدم',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                       // color: Colorss.mainTextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                // Name input
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'الاسم',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'BalooBhaijaan2',
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                     //     color: Colorss.mainColor, width: 0.3
                         ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك ادخل االاسم';
                    }
                    return null;
                  },
                ),

                // Email input

                SizedBox(height: 25),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(0xffefefef),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'الباسورد',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                       // color: Colorss.mainTextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                // Password input
                TextFormField(
                  controller: _passwordController,
               //   obscureText:_passwordController,
                  decoration: InputDecoration(
                    hintText: 'الباسورد',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'BalooBhaijaan2',
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: _togglePasswordVisibility,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black, width: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                      //    color: Colorss.mainColor, width: 0.3
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك ادخل الباسورد';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                // Submit Button
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
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 16),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          ),
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
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}