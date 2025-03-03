import 'package:car_ticket/controller/home/qr_code_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({super.key});

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool hasScanned = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Scan Ticket QR Code'),
        actions: [
          IconButton(
            onPressed: () => cameraController.toggleTorch(),
            icon: Icon(Icons.flash_on),
          ),
          IconButton(
            onPressed: () => cameraController.switchCamera(),
            icon: const Icon(Icons.flip_camera_ios),
          ),
        ],
      ),
      body: GetBuilder<QRcodeController>(
        init: QRcodeController(),
        builder: (qrController) {
          return Column(
            children: [
              Container(
                color: Colors.blue.withOpacity(0.1),
                padding: EdgeInsets.all(16.w),
                width: double.infinity,
                child: Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 32.sp,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Scan Ticket QR Code',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Position the QR code inside the frame to verify the ticket',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    MobileScanner(
                      controller: cameraController,
                      onDetect: (capture) {
                        if (hasScanned) return;

                        final List<Barcode> barcodes = capture.barcodes;
                        if (barcodes.isNotEmpty) {
                          final String qrCode = barcodes.first.rawValue ?? '';
                          if (qrCode.isNotEmpty) {
                            hasScanned = true;
                            _handleQRScan(qrController, qrCode);
                          }
                        }
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Container(
                        width: 280.w,
                        height: 280.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 240.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                'Scanning...',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (qrController.isVerifying)
                      Container(
                        color: Colors.black.withOpacity(0.7),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Verifying Ticket...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.w),
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Make sure the QR code is clearly visible and well lit',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.crop_free,
                          color: Colors.amber,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Position the QR code within the frame above',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleQRScan(QRcodeController qrController, String qrData) async {
    await qrController.verifyQrCode(qrData);

    if (mounted) {
      setState(() {
        hasScanned = false;
      });
    }
  }
}
