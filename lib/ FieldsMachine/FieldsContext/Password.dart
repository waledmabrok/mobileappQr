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
    this.hintText = 'الباسورد',
    this.validator,
    this.isRequired = false,
  });

  @override
  State<CustomPassword> createState() => _CustomPasswordState();
}

class _CustomPasswordState extends State<CustomPassword> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
        boxShadow: [
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
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.cairo(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue, width: 1),  // You can replace this with your custom color
          ),
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
            color: Colorss.icons,  // Replace with your custom color
          )
              : null,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colorss.icons,  // Replace with your custom color
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
