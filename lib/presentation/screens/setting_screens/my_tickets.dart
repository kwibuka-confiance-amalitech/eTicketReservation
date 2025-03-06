import 'dart:convert';

import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/controller/home/my_tickets.dart';
import 'package:car_ticket/domain/usecases/helpers/seats_length.dart';
import 'package:car_ticket/presentation/screens/setting_screens/ticket_details_screen.dart';
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

                          // Generate QR code data
                          final qrData = _generateTicketQRData(ticket);

                          return GestureDetector(
                            onTap: () {
                              Get.to(() => TicketDetailsScreen(ticket: ticket));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 24.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // INVOICE-STYLE HEADER
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 12.h), // Reduced padding
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.r),
                                        topRight: Radius.circular(16.r),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.confirmation_number,
                                          color: Colors.white,
                                          size: 18.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "E-TICKET #${ticket.id.substring(0, 5).toUpperCase()}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Spacer(),
                                        // Time/Date
                                        Text(
                                          timeChanged(ticket.createdAt),
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // INVOICE CONTENT
                                  Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      children: [
                                        // Journey details - Simplified and more compact
                                        Row(
                                          children: [
                                            // From/To locations
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  GetBuilder<
                                                      JourneyDestinationController>(
                                                    init:
                                                        JourneyDestinationController(),
                                                    builder:
                                                        (journeyController) {
                                                      // Find the destination details using carId
                                                      final destination =
                                                          journeyController
                                                              .destinations
                                                              .firstWhereOrNull(
                                                                  (d) =>
                                                                      d.carId ==
                                                                      ticket
                                                                          .carId);

                                                      return Container(
                                                        padding:
                                                            EdgeInsets.all(8.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[50],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                                destination!
                                                                    .description,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize:
                                                                      12.sp,
                                                                )),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  destination
                                                                          .from ??
                                                                      "Unknown",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 4.w),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward,
                                                                  size: 14.sp,
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                ),
                                                                SizedBox(
                                                                    width: 4.w),
                                                                Text(
                                                                  destination
                                                                          .to ??
                                                                      "Unknown",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            // Bus info
                                            GetBuilder<CarController>(
                                              init: CarController(),
                                              builder: (carController) {
                                                final car = carController.cars
                                                    .firstWhereOrNull((car) =>
                                                        car.id == ticket.carId);

                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 4.h),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.r),
                                                    border: Border.all(
                                                        color: Colors.blue
                                                            .withOpacity(0.3)),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .directions_bus_filled,
                                                        color: Colors.blue[700],
                                                        size: 14.sp,
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      Text(
                                                        car?.plateNumber ??
                                                            'Unknown',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blue[700],
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16.h),

                                        // Customer Information Section
                                        Container(
                                          padding: EdgeInsets.all(12.w),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            border: Border.all(
                                                color: Colors.grey[200]!),
                                          ),
                                          child: FutureBuilder<String>(
                                            future: myTicketController
                                                .sharedPreferenceRepository
                                                .getUser()
                                                .then((user) => user.name),
                                            builder: (context, snapshot) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(6.w),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.r),
                                                    ),
                                                    child: Icon(
                                                      Icons.person_outline,
                                                      size: 16.sp,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12.w),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'PASSENGER',
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: Colors
                                                                .grey[600],
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot.data ??
                                                              'Loading...',
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[800],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                            vertical: 4.h),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.verified_user,
                                                          size: 14.sp,
                                                          color:
                                                              Colors.green[700],
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        Text(
                                                          'Verified',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: Colors
                                                                .green[700],
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),

                                        SizedBox(height: 16.h),

                                        // Enhanced divider with ticket icons
                                        Row(
                                          children: [
                                            Icon(Icons.airplane_ticket,
                                                size: 14.sp,
                                                color: Colors.grey[400]),
                                            Expanded(
                                                child: _buildDashedDivider()),
                                            Transform.rotate(
                                              angle: 3.14159 / 2,
                                              child: Icon(Icons.bar_chart,
                                                  size: 14.sp,
                                                  color: Colors.grey[400]),
                                            ),
                                            Expanded(
                                                child: _buildDashedDivider()),
                                            Icon(Icons.confirmation_number,
                                                size: 14.sp,
                                                color: Colors.grey[400]),
                                          ],
                                        ),

                                        SizedBox(height: 20.h),

                                        // QR CODE SECTION WITH INVOICE-STYLE INFO
                                        Container(
                                          padding: EdgeInsets.all(16.w),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            border: Border.all(
                                                color: Colors.grey[200]!,
                                                width: 1),
                                          ),
                                          child: Column(
                                            children: [
                                              // Header text
                                              Row(
                                                children: [
                                                  Icon(Icons.qr_code,
                                                      color: Colors.black87,
                                                      size: 16.sp),
                                                  SizedBox(width: 8.w),
                                                  Text(
                                                    "BOARDING PASS",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.sp,
                                                      letterSpacing: 1.2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(height: 20.h),

                                              // QR Code with shadow
                                              Container(
                                                width: 180.w,
                                                height: 180.w,
                                                padding: EdgeInsets.all(8.w),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.05),
                                                      blurRadius: 8,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                                child: QrImageView(
                                                  data: qrData,
                                                  version: QrVersions.auto,
                                                  backgroundColor: Colors.white,
                                                  eyeStyle: QrEyeStyle(
                                                    eyeShape: QrEyeShape.square,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  dataModuleStyle:
                                                      QrDataModuleStyle(
                                                    dataModuleShape:
                                                        QrDataModuleShape
                                                            .square,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),

                                              Divider(height: 20.h),

                                              // Enhanced ticket details
                                              Container(
                                                padding: EdgeInsets.all(12.w),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  border: Border.all(
                                                      color: Colors.grey[200]!),
                                                ),
                                                child: Column(
                                                  children: [
                                                    // First row
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              _buildDetailItem(
                                                            "SEAT(S)",
                                                            seatsLength(ticket
                                                                    .seatNumbers)
                                                                .join(", "),
                                                            Icons.event_seat,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        Expanded(
                                                          child:
                                                              _buildDetailItem(
                                                            "PRICE",
                                                            "${ticket.price} RWF",
                                                            Icons.attach_money,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 12.h),
                                                    // Second row
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              _buildDetailItem(
                                                            "DATE",
                                                            dateChanged(ticket
                                                                .createdAt),
                                                            Icons
                                                                .calendar_today,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        Expanded(
                                                          child:
                                                              _buildDetailItem(
                                                            "TIME",
                                                            timeChanged(ticket
                                                                .createdAt),
                                                            Icons.access_time,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // TICKET FOOTER
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h,
                                        horizontal: 16.w), // Reduced padding
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16.r),
                                        bottomRight: Radius.circular(16.r),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.touch_app,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 14.sp),
                                        SizedBox(width: 4.w),
                                        Text(
                                          "View Details",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
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
            color: index % 2 == 0 ? Colors.transparent : Colors.grey[300],
          ),
        ),
      ),
    );
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
  String _generateTicketQRData(dynamic ticket) {
    // Get the journey destination controller
    final journeyController = Get.find<JourneyDestinationController>();

    // Find the destination details
    final destination = journeyController.destinations
        .firstWhereOrNull((d) => d.carId == ticket.carId);

    // Create a map with ticket data
    final Map<String, dynamic> ticketData = {
      'type': 'ticket',
      'ticketId': ticket.id,
      'ticketNumber': ticket.id.substring(0, 8),
      'carId': ticket.carId,
      'from': destination?.from ?? 'Unknown',
      'to': destination?.to ?? 'Unknown',
      'seats': seatsLength(ticket.seatNumbers),
      'price': ticket.price,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    return jsonEncode(ticketData);
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
}
