import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../controller/dashboard/passenger_controller.dart';

class PassengersScreen extends StatelessWidget {
  const PassengersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PassengerController>(
      init: PassengerController(),
      builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Passengers List'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.getPassengers(),
              ),
            ],
          ),
          body: Column(
            children: [
              // Filters
              Container(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search passengers...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Passenger List
              Expanded(
                child: ListView.builder(
                  itemCount: controller.passengers.length,
                  padding: EdgeInsets.all(16.w),
                  itemBuilder: (context, index) {
                    final passenger = controller.passengers[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 16.h),
                      child: ExpansionTile(
                        title: Text(
                          passenger.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        subtitle: Text(
                          'Seats: ${passenger.selectedSeats.join(", ")}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            passenger.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(
                                  'Pickup Location',
                                  passenger.pickupLocation,
                                  Icons.location_on,
                                ),
                                SizedBox(height: 8.h),
                                _buildDetailRow(
                                  'Travel Date',
                                  DateFormat('MMM dd, yyyy')
                                      .format(passenger.travelDate),
                                  Icons.calendar_today,
                                ),
                                SizedBox(height: 8.h),
                                _buildDetailRow(
                                  'Ticket ID',
                                  passenger.ticketId,
                                  Icons.confirmation_number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Colors.grey[600]),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.sp,
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
    );
  }
}
