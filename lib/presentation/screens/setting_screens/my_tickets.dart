import 'dart:convert';

import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/controller/home/my_tickets.dart';
import 'package:car_ticket/domain/models/ticket/ticket.dart';
import 'package:car_ticket/domain/repositories/payment_repository/payment_repository_imp.dart';
import 'package:car_ticket/domain/usecases/helpers/seats_length.dart';
import 'package:car_ticket/presentation/screens/setting_screens/ticket_details_screen.dart';
import 'package:car_ticket/presentation/widgets/common/refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyTicketScreen extends StatelessWidget {
  static const String routeName = '/my-tickets';
  const MyTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: MyTicketController(),
        builder: (myTicketController) {
          final tickets = myTicketController.ticketsList;
          return Scaffold(
            appBar: AppBar(
              title: const Text('My Invoices'),
              centerTitle: true,
              elevation: 0,
              actions: [
                RefreshButton(
                  isLoading: myTicketController.isGettingTickets,
                  onRefresh: () => myTicketController.getTickets(),
                ),
                SizedBox(width: 8.w),
              ],
            ),
            body: myTicketController.isGettingTickets
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20.h),
                        Text("Loading your tickets...",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.sp,
                            )),
                      ],
                    ),
                  )
                : tickets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.confirmation_number_outlined,
                              size: 80.sp,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'No tickets found',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'You haven\'t purchased any tickets yet',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = tickets[index];

                          // Safe QR data generation with null checks
                          final qrData = ticket.id != null
                              ? _generateTicketQRData(ticket)
                              : '';

                          // Replace the existing ticket card content with this modern design
                          return GestureDetector(
                            onTap: () => Get.to(
                                () => TicketDetailsScreen(ticket: ticket)),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 24.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Modern Header with Gradient
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.8),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.r),
                                        topRight: Radius.circular(16.r),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.confirmation_number,
                                            color: Colors.white, size: 18.sp),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "E-TICKET #${_formatTicketId(ticket.id ?? '')}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        const Spacer(),
                                        _buildTicketStatus(ticket),
                                      ],
                                    ),
                                  ),

                                  // Content Section
                                  Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      children: [
                                        // Journey Title with Route Icon
                                        GetBuilder<
                                            JourneyDestinationController>(
                                          init: JourneyDestinationController(),
                                          builder: (journeyController) {
                                            final destination =
                                                journeyController.destinations
                                                    .firstWhereOrNull(
                                                        (d) =>
                                                            d.carId ==
                                                            ticket.carId);

                                            return Column(
                                              children: [
                                                // Route Info
                                                Container(
                                                  padding: EdgeInsets.all(12.w),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.r),
                                                    border: Border.all(
                                                        color:
                                                            Colors.grey[200]!),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      // Left Side - Journey Details
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              destination
                                                                      ?.description ??
                                                                  'Journey Details',
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.sp,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 12.h),
                                                            Row(
                                                              children: [
                                                                _buildLocationDot(
                                                                    Colors
                                                                        .green,
                                                                    'FROM'),
                                                                SizedBox(
                                                                    width: 8.w),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        destination?.from ??
                                                                            'Unknown',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        ticket.carDestinationFromTime ??
                                                                            '--:--',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.sp,
                                                                          color:
                                                                              Colors.grey[600],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 16.h),
                                                            Row(
                                                              children: [
                                                                _buildLocationDot(
                                                                    Colors.red,
                                                                    'TO'),
                                                                SizedBox(
                                                                    width: 8.w),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        destination?.to ??
                                                                            'Unknown',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        ticket.carDestinationToTime ??
                                                                            '--:--',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.sp,
                                                                          color:
                                                                              Colors.grey[600],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Right Side - QR Code
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(8.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .grey[200]!),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            QrImageView(
                                                              data: qrData,
                                                              version:
                                                                  QrVersions
                                                                      .auto,
                                                              size: 80.w,
                                                            ),
                                                            SizedBox(
                                                                height: 4.h),
                                                            Text(
                                                              'Scan to verify',
                                                              style: TextStyle(
                                                                fontSize: 10.sp,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                // Pickup Location
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 12.h),
                                                  padding: EdgeInsets.all(12.w),
                                                  decoration: BoxDecoration(
                                                    color: ticket.pickupLocation
                                                                .isNotEmpty ==
                                                            true
                                                        ? Colors.grey[50]
                                                        : Colors.orange[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    border: Border.all(
                                                      color: ticket
                                                                  .pickupLocation
                                                                  .isNotEmpty ==
                                                              true
                                                          ? Colors.grey[200]!
                                                          : Colors.orange[200]!,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        size: 16.sp,
                                                        color: ticket
                                                                    .pickupLocation
                                                                    .isNotEmpty ==
                                                                true
                                                            ? Colors.grey[700]
                                                            : Colors
                                                                .orange[700],
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Expanded(
                                                        child: Text(
                                                          ticket.pickupLocation
                                                                      .isNotEmpty ==
                                                                  true
                                                              ? ticket
                                                                  .pickupLocation
                                                              : 'Pickup location not selected',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ticket
                                                                        .pickupLocation
                                                                        .isNotEmpty ==
                                                                    true
                                                                ? Colors
                                                                    .grey[800]
                                                                : Colors.orange[
                                                                    700],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),

                                        // Actions Section
                                        Padding(
                                          padding: EdgeInsets.only(top: 16.h),
                                          child: Row(
                                            children: [
                                              // View Details Button
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () => Get.to(() =>
                                                      TicketDetailsScreen(
                                                          ticket: ticket)),
                                                  icon: Icon(
                                                      Icons.visibility_outlined,
                                                      size: 18.sp),
                                                  label: Text('View Details'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(0.1),
                                                    elevation: 0,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12.h),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Cancel Button if applicable
                                              if (!ticket.isCancelled &&
                                                  !ticket.isExpired &&
                                                  !ticket.isUsed) ...[
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: ElevatedButton.icon(
                                                    onPressed: () =>
                                                        _showCancelConfirmation(
                                                            context, ticket),
                                                    icon: Icon(
                                                        Icons.cancel_outlined,
                                                        size: 18.sp),
                                                    label: Text('Cancel'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          Colors.red,
                                                      backgroundColor: Colors
                                                          .red
                                                          .withOpacity(0.1),
                                                      elevation: 0,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12.h),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          );
        });
  }

  // Helper method to build location dots with labels
  Widget _buildLocationDot(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 14.w,
          height: 14.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10.sp,
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
                    color:
                        index % 2 == 0 ? Colors.transparent : Colors.grey[300],
                  ),
                )));
  }

  // Helper method to build ticket detail row
  Widget _buildTicketDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.sp,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  // Generate QR code data from ticket info
  String _generateTicketQRData(ExcelTicket ticket) {
    try {
      final journeyController = Get.find<JourneyDestinationController>();
      final carController = Get.find<CarController>();

      final destination = journeyController.destinations
          .firstWhereOrNull((d) => d.carId == ticket.carId);

      final car =
          carController.cars.firstWhereOrNull((car) => car.id == ticket.carId);

      final Map<String, dynamic> ticketData = {
        'ticketId': ticket.id ?? '',
        'carId': ticket.carId ?? '',
        'carPlate': car?.plateNumber ?? 'Unknown',
        'from': destination?.from ?? 'Unknown Location',
        'to': destination?.to ?? 'Unknown Location',
        'seats': seatsLength(ticket.seatNumbers ?? ''),
        'price': ticket.price ?? '0',
        'fromTime': ticket.carDestinationFromTime ?? '--:--',
        'toTime': ticket.carDestinationToTime ?? '--:--',
        'isCancelled': ticket.isCancelled ?? false,
        'isExpired': ticket.isExpired ?? false,
        'isUsed': ticket.isUsed ?? false,
        'pickupLocation': ticket.pickupLocation ?? '',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      return jsonEncode(ticketData);
    } catch (e) {
      print('Error generating QR data: $e');
      return '';
    }
  }

  // Add this helper method to your MyTicketScreen class
  String _formatTicketId(String? ticketId) {
    if (ticketId == null || ticketId.isEmpty) {
      return 'N/A';
    }

    // Take the first 5 characters if available, otherwise pad with zeros
    final formattedId = ticketId.length >= 5
        ? ticketId.substring(0, 5)
        : ticketId.padRight(5, '0');

    return formattedId.toUpperCase();
  }

  // Add this helper method to your MyTicketScreen class
  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Add this helper method for more compact details
  Widget _buildCompactDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14.sp,
          color: Colors.grey[700],
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$label: ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showCancelConfirmation(BuildContext context, ExcelTicket ticket) {
    if (ticket.isCancelled || ticket.isExpired || ticket.isUsed) {
      Get.snackbar(
        'Cannot Cancel',
        'This ticket cannot be cancelled because it is ${_getStatusText(ticket).toLowerCase()}',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Cancel Ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to cancel this ticket?'),
            SizedBox(height: 8.h),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No, Keep Ticket'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _cancelTicket(ticket);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Yes, Cancel Ticket'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelTicket(ExcelTicket ticket) async {
    try {
      final paymentRepo = Get.find<PaymentRepositoryImpl>();

      // Update ticket status
      final updatedTicket = ticket.copyWith(
        isCancelled: true,
        cancelledAt: DateTime.now(),
      );

      await paymentRepo.updateTicket(updatedTicket);

      // Free up the seats
      final seatNumbers = seatsLength(ticket.seatNumbers);
      await paymentRepo.updateCarSeatsAfterCancellation(
        ticket.carId,
        seatNumbers,
      );

      // Force refresh tickets
      final ticketController = Get.find<MyTicketController>();
      await ticketController.getTickets();
      ticketController.update(); // Force UI update

      Get.snackbar(
        'Success',
        'Ticket cancelled successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel ticket: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add this helper method to get status color
  Color _getStatusColor(ExcelTicket ticket) {
    if (ticket.isCancelled) return Colors.red;
    if (ticket.isExpired) return Colors.orange;
    if (ticket.isUsed) return Colors.blue;
    return Colors.green;
  }

  Widget _buildTicketStatus(ExcelTicket ticket) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor(ticket).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _getStatusColor(ticket)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(ticket),
            size: 14.sp,
            color: _getStatusColor(ticket),
          ),
          SizedBox(width: 4.w),
          Text(
            _getStatusText(ticket),
            style: TextStyle(
              fontSize: 12.sp,
              color: _getStatusColor(ticket),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(ExcelTicket ticket) {
    if (ticket.isCancelled) return Icons.cancel_outlined;
    if (ticket.isExpired) return Icons.timer_off;
    if (ticket.isUsed) return Icons.check_circle;
    return Icons.pending;
  }

  String _getStatusText(ExcelTicket ticket) {
    if (ticket.isCancelled) return 'Cancelled';
    if (ticket.isExpired) return 'Expired';
    if (ticket.isUsed) return 'Used';
    return 'Active';
  }

  Widget _buildLocationSection(
      String label, String location, String time, Color dotColor) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: dotColor.withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                location,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
