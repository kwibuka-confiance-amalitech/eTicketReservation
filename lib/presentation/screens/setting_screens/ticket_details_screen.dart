import 'dart:convert';
import 'dart:io';

import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/usecases/helpers/seats_length.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class TicketDetailsScreen extends StatelessWidget {
  final dynamic ticket;
  final ScreenshotController screenshotController = ScreenshotController();

  TicketDetailsScreen({super.key, required this.ticket}) {
    // Initialize controllers if not already initialized
    if (!Get.isRegistered<JourneyDestinationController>()) {
      Get.put(JourneyDestinationController());
    }
    if (!Get.isRegistered<CarController>()) {
      Get.put(CarController());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate QR code data
    final qrData = _generateTicketQRData(ticket);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _shareTicket(context),
            icon: Icon(Icons.share),
            tooltip: 'Share Ticket',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Screenshot(
                controller: screenshotController,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ticket header
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            topRight: Radius.circular(16.r),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.confirmation_number,
                                color: Colors.white),
                            SizedBox(width: 8.w),
                            Text(
                              "E-TICKET #${_formatTicketId(ticket.id)}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                "Ticket #${_formatTicketId(ticket.id)}",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Ticket content
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          children: [
                            // QR code section
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: 160.w,
                                    height: 160.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    padding: EdgeInsets.all(8.w),
                                    child: QrImageView(
                                      data: qrData,
                                      version: QrVersions.auto,
                                      backgroundColor: Colors.white,
                                      errorStateBuilder: (context, error) {
                                        return Center(
                                          child: Text(
                                            "Error generating QR code",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    "Scan this QR code to validate your ticket",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 24.h),
                            _buildDashedDivider(),
                            SizedBox(height: 24.h),

                            // Route information
                            _buildSectionTitle("Route Information"),
                            SizedBox(height: 16.h),
                            GetBuilder<JourneyDestinationController>(
                              init: JourneyDestinationController(),
                              builder: (journeyController) {
                                // Find the destination details using carId
                                final destination = journeyController
                                    .destinations
                                    .firstWhereOrNull(
                                        (d) => d.carId == ticket.carId);

                                return Column(
                                  children: [
                                    // Description
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        destination?.description ??
                                            "Route description not available",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "From",
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                destination?.from ?? "Unknown",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.sp,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                ticket.carDestinationFromTime ??
                                                    "Time not specified",
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40.w,
                                          height: 40.w,
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "To",
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                destination?.to ?? "Unknown",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.sp,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                ticket.carDestinationToTime ??
                                                    "Time not specified",
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: 24.h),
                            _buildDashedDivider(),
                            SizedBox(height: 24.h),

                            // Vehicle Information Section
                            _buildSectionTitle("Vehicle Information"),
                            SizedBox(height: 16.h),
                            GetBuilder<CarController>(
                              init: CarController(),
                              builder: (carController) {
                                final car = carController.cars.firstWhereOrNull(
                                    (car) => car.id == ticket.carId);

                                return Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12.r),
                                    border:
                                        Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Icon(
                                              Icons.directions_bus,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 24.sp,
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  car?.name ?? 'Vehicle',
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  car?.model ??
                                                      'Model not available',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 12.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                              color:
                                                  Colors.blue.withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons
                                                  .confirmation_number_outlined,
                                              size: 16.sp,
                                              color: Colors.blue[700],
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              car?.plateNumber ??
                                                  'Plate number not available',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: 24.h),
                            _buildDashedDivider(),
                            SizedBox(height: 24.h),

                            // Ticket details
                            _buildSectionTitle("Ticket Details"),
                            SizedBox(height: 16.h),
                            _buildDetailRow("Ticket ID",
                                "#${ticket.id.substring(0, 8)}..."),
                            SizedBox(height: 8.h),
                            _buildDetailRow("Seat(s)",
                                seatsLength(ticket.seatNumbers).join(", ")),
                            SizedBox(height: 8.h),
                            _buildDetailRow("Price", "${ticket.price} RWF"),
                            SizedBox(height: 8.h),
                            _buildDetailRow("Car ID",
                                "#${ticket.carId.substring(0, 8)}..."),
                            SizedBox(height: 8.h),
                            _buildDetailRow(
                                "Date", dateChanged(ticket.createdAt)),
                            SizedBox(height: 8.h),
                            _buildDetailRow(
                                "Time", timeChanged(ticket.createdAt)),

                            SizedBox(height: 24.h),
                            _buildDashedDivider(),
                            SizedBox(height: 24.h),

                            // Payment details
                            _buildSectionTitle("Payment Information"),
                            SizedBox(height: 16.h),
                            _buildDetailRow("Payment Method", "Visa Card"),
                            SizedBox(height: 8.h),
                            _buildDetailRow("Status", "Completed"),
                            SizedBox(height: 8.h),
                            _buildDetailRow("Transaction ID",
                                "#${generateRandomTransactionId(ticket.id)}"),
                          ],
                        ),
                      ),

                      // Ticket footer
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.r),
                            bottomRight: Radius.circular(16.r),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).primaryColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                "Please present this ticket when boarding the vehicle",
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Action buttons
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _saveTicketToGallery(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      icon: Icon(Icons.save),
                      label: Text('Save Ticket'),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _shareTicket(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      icon: Icon(Icons.share),
                      label: Text('Share Ticket'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
        color: Colors.black87,
      ),
    );
  }

  // Helper method to build detail row
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.sp,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  // Helper method to build a dashed divider
  Widget _buildDashedDivider() {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            height: 1,
            color: index % 2 == 0 ? Colors.transparent : Colors.grey[300],
          ),
        ),
      ),
    );
  }

  // Generate QR code data from ticket info
  String _generateTicketQRData(dynamic ticket) {
    final journeyController = Get.find<JourneyDestinationController>();
    final carController = Get.find<CarController>();

    final destination = journeyController.destinations
        .firstWhereOrNull((d) => d.carId == ticket.carId);

    final car =
        carController.cars.firstWhereOrNull((car) => car.id == ticket.carId);

    final Map<String, dynamic> ticketData = {
      'type': 'ticket',
      'ticketId': ticket.id,
      'ticketNumber': _formatTicketId(ticket.id),
      'carId': ticket.carId,
      'carPlate': car?.plateNumber ?? 'Unknown',
      'carName': car?.name ?? 'Unknown',
      'carModel': car?.model ?? 'Unknown',
      'from': destination?.from ?? 'Unknown',
      'to': destination?.to ?? 'Unknown',
      'description': destination?.description ?? '',
      'seats': seatsLength(ticket.seatNumbers),
      'price': ticket.price,
      'fromTime': ticket.carDestinationFromTime,
      'toTime': ticket.carDestinationToTime,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    return jsonEncode(ticketData);
  }

  // Generate a random transaction ID based on ticket ID
  String generateRandomTransactionId(String ticketId) {
    // Ensure ticketId is at least 4 characters long
    final safeId = (ticketId.length >= 4)
        ? ticketId.substring(0, 4)
        : ticketId.padRight(4, '0');

    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomPart = timestamp.substring(timestamp.length - 6);

    return 'TRX-${safeId.toUpperCase()}-$randomPart';
  }

  // Save ticket as image
  Future<void> _saveTicketToGallery(BuildContext context) async {
    try {
      // Capture ticket as image
      final image = await screenshotController.capture();
      if (image == null) throw 'Failed to capture ticket';

      // Create file name
      final fileName =
          'Ticket_${ticket.id.substring(0, 5)}_${DateTime.now().millisecondsSinceEpoch}';

      // Save the file using file_saver
      final savedPath = await FileSaver.instance.saveFile(
        name: fileName,
        bytes: image,
        ext: 'png',
        mimeType: MimeType.png,
      );

      // Show success message
      Get.snackbar(
        'Success',
        'Ticket saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save ticket: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Share ticket
  Future<void> _shareTicket(BuildContext context) async {
    try {
      // Capture ticket as image
      final image = await screenshotController.capture();
      if (image == null) throw 'Failed to capture ticket';

      // Create temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/ticket_share.png').create();
      await file.writeAsBytes(image);

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'My E-Ticket for travel from Kigali to Nyamata',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share ticket: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add this helper method to your TicketDetailsScreen class
  String _formatTicketId(String? ticketId) {
    if (ticketId == null || ticketId.isEmpty) {
      return 'N/A';
    }

    if (ticketId.length >= 5) {
      return ticketId.substring(0, 5).toUpperCase();
    }

    return ticketId.padRight(5, '0').toUpperCase();
  }
}
