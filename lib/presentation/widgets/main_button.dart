import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class MainButton extends StatelessWidget {
  bool isColored;
  Function onPressed;
  String title;
  bool isLoading;
  bool isDisabled;
  MainButton(
      {super.key,
      required this.isColored,
      required this.onPressed,
      this.isLoading = false,
      this.isDisabled = false,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              disabledBackgroundColor: isColored
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 15.0.h),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: isColored
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      width: 1.0.w),
                  borderRadius: BorderRadius.circular(25.0.r)),
              backgroundColor: isColored
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white),
          onPressed: isDisabled ? null : () => onPressed(),
          child: isLoading == true
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.w,
                    color: isColored
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                  ))
              : Text(
                  title,
                  style: TextStyle(
                      fontSize: 17.0.sp,
                      color: isColored
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary),
                )),
    );
  }
}
