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
    _focusNode.dispose();
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
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFocused
              ? Colorss.mainColor
              : Colors.grey, // تغيير اللون بناءً على التركيز
          width: 1,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            focusNode: _focusNode,
            decoration: InputDecoration(
              // hintText: widget.hintText,
              hintStyle: GoogleFonts.balooBhaijaan2(
                  color: Colorss.SecondText, fontSize: 15),
              labelText: widget.hintText,
              labelStyle: GoogleFonts.balooBhaijaan2(
                  color: _isFocused ? Colorss.mainColor : Colorss.SecondText,
                  fontSize: 18),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              // يجعل الـ hintText يطفو فوق الحقل عند الكتابة
              border: InputBorder.none,
              // إزالة الحدود
              focusedBorder: InputBorder.none,
              // إزالة الحدود عند التركيز
              enabledBorder: InputBorder.none,
              // إزالة الحدود عند التمكين

              filled: true,
              fillColor: Colors.transparent,
              // اجعل خلفية الحقل شفافة
              // Prefix icon appears if isRequired is true
              prefixIcon: widget.isRequired
                  ? Icon(
                      Icons.lock,
                      color: _iconColor,
                      size: 25, // لون الأيقونة بناءً على حالة التركيز
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
        ),
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
