import 'package:car_ticket/controller/home/qr_code_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrCodeScreen extends StatelessWidget {
  const ScanQrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Scan QR Code'),
      ),
      body: GetBuilder(
          init: QRcodeController(),
          builder: (QRcodeController qrController) {
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 120.h,
                    ),
                    const Center(
                      child: Text('Scan QR Code to get started'),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                      width: 300.w,
                      height: 300.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text("QR Code Scanner"),
                    ),
                    //    QRView(
                    //       key: qrController.qrKey,
                    //       onQRViewCreated: qrController.onQRViewCreated),
                    // ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
