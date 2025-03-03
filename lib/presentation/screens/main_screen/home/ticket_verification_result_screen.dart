import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TicketVerificationResultScreen extends StatelessWidget {
  final bool isValid;
  final String message;

  const TicketVerificationResultScreen({
    super.key,
    required this.isValid,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Result'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Result Icon
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isValid
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                      ),
                      child: Icon(
                        isValid ? Icons.check_circle : Icons.cancel,
                        size: 80.sp,
                        color: isValid ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Result Title
                    Text(
                      isValid ? 'Valid' : 'Invalid',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: isValid ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Result Message
                    Container(
                      width: 300.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isValid
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isValid
                              ? Colors.green.withOpacity(0.3)
                              : Colors.red.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: isValid ? Colors.green[800] : Colors.red[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom actions
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back(); // Go back to scanner
                      },
                      icon: Icon(Icons.qr_code_scanner),
                      label: Text('Scan Another'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.until((route) => route.isFirst); // Go back to home
                      },
                      icon: Icon(Icons.home),
                      label: Text('Back to Home'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: BorderSide(color: Colors.blue),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
