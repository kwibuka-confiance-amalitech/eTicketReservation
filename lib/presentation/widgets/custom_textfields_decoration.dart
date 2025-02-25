import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration customTextFieldDecoration(
    {required String labelText,
    required String hintText,
    required BuildContext context}) {
  return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 10.0.w),
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: 1.0,
          )));
}

InputDecoration customTextFieldDecorationWhite(
    {required String labelText,
    required String hintText,
    required BuildContext context}) {
  return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 10.0.w),
      labelText: labelText,
      hintText: hintText,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0.w,
          )));
}

InputDecoration customTextFieldDecorationUnLabeled(
    {required String labelText,
    required String hintText,
    required BuildContext context}) {
  return InputDecoration(
      // labelText: labelText,
      contentPadding: EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 10.0.w),
      labelStyle: TextStyle(
        color: Colors.grey.withOpacity(0.3),
        fontFamily: GoogleFonts.roboto().fontFamily,
        fontWeight: FontWeight.normal,
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey.withOpacity(0.3),
        fontFamily: GoogleFonts.roboto().fontFamily,
        fontWeight: FontWeight.normal,
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.0.h,
          )));
}
