import 'dart:convert';
import 'dart:io';

import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/models/car/car.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class VehicleQRCodeScreen extends StatelessWidget {
  final ExcelCar car;

  const VehicleQRCodeScreen({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Vehicle QR Code'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  _buildQRCodeCard(context),
                  SizedBox(height: 24.h),
                  _buildVehicleDetails(context),
                  SizedBox(height: 24.h),
                  _buildActionButtons(context, controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQRCodeCard(BuildContext context) {
    // Generate QR code data
    final qrData = _generateQRData();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Text(
              'Vehicle Entry QR Code',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            // Use Screenshot to capture QR code for saving
            Screenshot(
              controller: Get.find<CarController>().screenshotController,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 240.w,
                      backgroundColor: Colors.white,
                      errorStateBuilder: (_, __) => Center(
                        child: Text(
                          'Error generating QR code',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      car.plateNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      'Scan to verify entry',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDetails(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow('Vehicle', car.name),
            _buildDetailRow('Model', car.model),
            _buildDetailRow('Plate Number', car.plateNumber),
            _buildDetailRow('Capacity', '${car.seatNumbers} seats'),

            // Safely get destination info
            Builder(
              builder: (context) {
                // Try to get destination info if controller is available
                if (Get.isRegistered<JourneyDestinationController>()) {
                  try {
                    final controller = Get.find<CarController>();
                    final destination = controller.getDestinationForCar(car.id);

                    if (destination != null) {
                      return Column(
                        children: [
                          _buildDetailRow('Route',
                              '${destination.from} to ${destination.to}'),
                          _buildDetailRow('Duration', destination.duration),
                        ],
                      );
                    }
                  } catch (e) {
                    print('Error loading destination info: $e');
                  }
                }

                // If controller is not available or there's an error, show nothing
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, CarController controller) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => _saveQRCodeToGallery(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            minimumSize: Size(double.infinity, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          icon: Icon(Icons.save),
          label: Text('Save to Gallery'),
        ),
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: () => _shareQRCode(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
            side: BorderSide(color: Theme.of(context).primaryColor),
            padding: EdgeInsets.symmetric(vertical: 14.h),
            minimumSize: Size(double.infinity, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          icon: Icon(Icons.share),
          label: Text('Share QR Code'),
        ),
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: () => _printQRCode(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.teal,
            side: BorderSide(color: Colors.teal),
            padding: EdgeInsets.symmetric(vertical: 14.h),
            minimumSize: Size(double.infinity, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          icon: Icon(Icons.print),
          label: Text('Print QR Code'),
        ),
      ],
    );
  }

  String _generateQRData() {
    // Create a map with vehicle data
    final Map<String, dynamic> vehicleData = {
      'type': 'vehicle_entry',
      'id': car.id,
      'plateNumber': car.plateNumber,
      'name': car.name,
      'model': car.model,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'verificationKey': _generateVerificationKey(),
    };

    // Convert to JSON
    return jsonEncode(vehicleData);
  }

  // Generate a verification key based on vehicle data
  String _generateVerificationKey() {
    // Use timestamp if createdAt is null
    final timestamp = car.createdAt?.toString() ?? DateTime.now().toString();
    final String baseString = '${car.id}:${car.plateNumber}:$timestamp';
    final bytes = utf8.encode(baseString);
    return base64Encode(bytes);
  }

  Future<void> _saveQRCodeToGallery(BuildContext context) async {
    final controller = Get.find<CarController>();
    controller.setSaving(true);

    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw 'Storage permission denied';
      }

      // Capture QR code as image
      final image = await controller.screenshotController.capture();
      if (image == null) throw 'Failed to capture QR code';

      // Create file name
      final fileName =
          'Vehicle_QR_${car.plateNumber}_${DateTime.now().millisecondsSinceEpoch}';

      // Save the file using file_saver
      final savedPath = await FileSaver.instance.saveFile(
        name: fileName,
        bytes: image,
        ext: 'png',
        mimeType: MimeType.png,
      );

      Get.snackbar(
        'Success',
        'QR Code saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save QR Code: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      controller.setSaving(false);
    }
  }

  Future<void> _shareQRCode(BuildContext context) async {
    final controller = Get.find<CarController>();
    controller.setSharing(true);

    try {
      final image = await controller.screenshotController.capture();
      if (image == null) throw 'Failed to capture QR code';

      // Create a temporary file
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/vehicle_qr_${car.plateNumber}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      // Share the image
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'Vehicle QR Code for ${car.name} (${car.plateNumber})',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share QR Code: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      controller.setSharing(false);
    }
  }

  Future<void> _printQRCode(BuildContext context) async {
    // Implement printing functionality if needed
    // For now just show a message
    Get.snackbar(
      'Print',
      'Printing functionality will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
