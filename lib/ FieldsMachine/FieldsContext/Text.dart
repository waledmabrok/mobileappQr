/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../setup/MainColors.dart';

class CustomText extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool iconLeft;

  final IconData? prefixIcon;

  CustomText({
    this.controller,
    this.hintText = 'الاسم',
    this.validator,
    this.isRequired = false,
    this.iconLeft = false,
    this.prefixIcon,
  });

  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  late FocusNode _focusNode;
  Color _iconColor = Colorss.icons;
  bool _isFocused = false;

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
          */
/*if (value == null || value.isEmpty) {
        return 'من فضلك أدخل ${widget.hintText}';
      }*/ /*

          return null;
        };

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        */
/*    boxShadow: _isFocused
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
        ],*/ /*

      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,

        // إضافة FocusNode
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.balooBhaijaan2(
            fontSize: 20,
            color: Colorss.SecondText,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colorss.mainColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey, width: 0.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: widget.isRequired
              ? Icon(
                  widget.prefixIcon ?? Icons.person,
                  color: _iconColor,
                )
              : null,
          suffixIcon: widget.iconLeft
              ? Icon(
                  Icons.person,
                  color: _iconColor,
                )
              : null,
        ),
        validator: effectiveValidator,
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../setup/MainColors.dart';

class CustomText extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool iconLeft;
  final IconData? prefixIcon;
  final bool isDropdown;
  final List<String>? items;
  final ValueChanged<String?>? onChanged;

  CustomText({
    this.controller,
    this.hintText = 'الاسم',
    this.validator,
    this.isRequired = false,
    this.iconLeft = false,
    this.prefixIcon,
    this.isDropdown = false,
    this.items,
    this.onChanged,
  });

  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  late FocusNode _focusNode;
  Color _iconColor = Colorss.icons;
  bool _isFocused = false;

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
          return null;
        };

    if (widget.isDropdown) {
      return Container(
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isFocused ? Colorss.mainColor : Colors.grey,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: DropdownButtonFormField<String>(
              value: widget.controller?.text.isEmpty ?? true
                  ? null
                  : widget.controller?.text,
              // قيمة مبدئية صحيحة
              decoration: InputDecoration(
                labelText: widget.hintText,
                labelStyle: GoogleFonts.balooBhaijaan2(
                  fontSize: 18,
                  color: _isFocused ? Colorss.mainColor : Colorss.SecondText,
                ),
                hintStyle: GoogleFonts.balooBhaijaan2(
                  fontSize: 15,
                  color: Colorss.SecondText,
                ),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
                prefixIcon: widget.isRequired
                    ? Icon(
                        widget.prefixIcon ?? Icons.person,
                        color: _iconColor,
                        size: 25,
                      )
                    : null,
                suffixIcon: widget.iconLeft
                    ? Icon(
                        Icons.person,
                        color: _iconColor,
                        size: 25,
                      )
                    : null,
              ),
              items: widget.items?.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: widget.onChanged,
              validator: effectiveValidator,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFocused ? Colorss.mainColor : Colors.grey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              labelText: widget.hintText,
              labelStyle: GoogleFonts.balooBhaijaan2(
                fontSize: 18,
                color: _isFocused ? Colorss.mainColor : Colorss.SecondText,
              ),
              hintStyle: GoogleFonts.balooBhaijaan2(
                fontSize: 15,
                color: Colorss.SecondText,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              prefixIcon: widget.isRequired
                  ? Icon(
                      widget.prefixIcon ?? Icons.person,
                      color: _iconColor,
                      size: 25,
                    )
                  : null,
              suffixIcon: widget.iconLeft
                  ? Icon(
                      Icons.person,
                      color: _iconColor,
                      size: 25,
                    )
                  : null,
            ),
            validator: effectiveValidator,
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
      ),
    );
  }
}
