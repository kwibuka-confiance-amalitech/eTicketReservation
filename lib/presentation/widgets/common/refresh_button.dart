import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;
  final bool isLoading;

  const RefreshButton({
    super.key,
    required this.onRefresh,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isLoading ? null : onRefresh,
      icon: isLoading
          ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).secondaryHeaderColor,
                ),
              ),
            )
          : Icon(
              Icons.refresh,
              color: Theme.of(context).secondaryHeaderColor,
              size: 24.sp,
            ),
    );
  }
}
