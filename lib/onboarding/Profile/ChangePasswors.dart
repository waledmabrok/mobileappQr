import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ FieldsMachine/FieldsContext/Button.dart';
import '../../ FieldsMachine/FieldsContext/Password.dart';
import '../../ FieldsMachine/FieldsContext/Text.dart';

class changePassword extends StatefulWidget {
  static const routeName = "/change_password";

  const changePassword({super.key});

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: Text(
          'تغير الباسورد',
          style: GoogleFonts.balooBhaijaan2(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomPassword(
              hintText: 'كلمه المرور الحاليه',
            ),
            SizedBox(
              height: 16,
            ),
            CustomPassword(
              hintText: 'كلمه المرور الجديده',
            ),
            Spacer(),
            CustomButton(
              text: 'تحديث كلمه المرور',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
