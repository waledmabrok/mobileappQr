import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../setup/MainColors.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomPassword extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isRequired;

  CustomPassword({
    this.controller,
    this.hintText = 'الرقم السري',
    this.validator,
    this.isRequired = false,
  });

  @override
  State<CustomPassword> createState() => _CustomPasswordState();
}

class _CustomPasswordState extends State<CustomPassword> {
  bool _obscureText = true;
  late FocusNode _focusNode;
  bool _isFocused = false;
  Color _iconColor = Colorss.icons;
  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        _iconColor = _focusNode.hasFocus ? Colorss.mainColor : Colorss.icons;
      });
    });
  }
  @override
  void dispose() {
    _focusNode.dispose(); // تأكد من التخلص من الـ FocusNode عند التخلص من الويدجت
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveValidator = widget.validator ??
            (value) {
          if (value == null || value.isEmpty) {
            return 'من فضلك ادخل ${widget.hintText}';
          }
          return null;
        };

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: _isFocused
            ? [
          BoxShadow(
            color: Colorss.mainColor.withOpacity(0.4),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.balooBhaijaan2(
            color: Colorss.SecondText,

            fontSize: 20
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0x13859de4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue, width: 1),
            // You can replace this with your custom color
          ),suffixIconColor: Colorss.mainColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey, width: 0.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          filled: true,
          fillColor: Colors.white,
          // Prefix icon appears if isRequired is true
          prefixIcon: widget.isRequired
              ? Icon(
            Icons.lock,
            color: _iconColor, // لون الأيقونة بناءً على حالة التركيز
          )
              : null,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: _iconColor, // لون الأيقونة بناءً على حالة التركيز
            ),
            onPressed: _toggleVisibility,
          ),
        ),
        validator: effectiveValidator,
      ),
    );
  }
}


///Hint use

/*CustomPassword(
controller: _passwordController,
obscureText: _obscurePassword,
toggleVisibility: _togglePasswordVisibility,
hintText: 'ادخل كلمة المرور الجديدة',
validator: (value) {
if (value == null || value.isEmpty) {
return 'من فضلك ادخل كلمة المرور الجديدة';
}
return null;
},
),*/

///or

/*
CustomPasswordField({
  this.controller,
  required this.obscureText,
  required this.toggleVisibility,
  this.hintText = 'الباسورد',
  this.validator,
});
*/
