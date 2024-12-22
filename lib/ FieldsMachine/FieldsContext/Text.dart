import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../setup/MainColors.dart';

class CustomText extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool iconleft;
  CustomText({
    this.controller,
    this.hintText = 'الاسم',
    this.validator,
    this.isRequired = false,
    this.iconleft = false,
  });

  @override
  Widget build(BuildContext context) {
 
    final effectiveValidator = validator ?? (value) {
      if (value == null || value.isEmpty) {
        return 'من فضلك ادخل $hintText';
      }
      return null;
    };

    return
      Container(
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
    child:
      TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.cairo(
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colorss.mainColor, width:1),
        ),
        enabledBorder: OutlineInputBorder(

          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),

      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      // إضافة ظل
      filled: true,
      fillColor: Colors.white,
        prefixIcon: isRequired
            ? Icon(
          Icons.person,
          color: Colorss.icons,  // Replace with your custom color
        )
            : null,
        suffixIcon: iconleft
            ? Icon(
          Icons.person,
          color: Colorss.icons,  // Replace with your custom color
        )
            : null,
    ),
      validator: effectiveValidator,
    ) );
  }
}


///hint use----------------
/*CustomTextFormField(
controller: _usernameController,
hintText: 'الاسم',
validator: (value) {
if (value == null || value.isEmpty) {
return 'من فضلك ادخل اسم المستخدم';
}
return null;
},
),*/
///or
/*CustomTextFormField(
controller: _usernameController,
),*/
