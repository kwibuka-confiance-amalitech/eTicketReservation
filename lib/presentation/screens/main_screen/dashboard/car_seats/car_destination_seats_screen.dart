import 'package:car_ticket/controller/dashboard/car_seats_controller.dart';
import 'package:car_ticket/domain/models/passenger/passenger_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CarDestinationSeatsScreen extends StatelessWidget {
  final String carId;
  final String destinationId;

  const CarDestinationSeatsScreen({
    super.key,
    required this.carId,
    required this.destinationId,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarSeatsController>(
      init: CarSeatsController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.destination?.description ?? 'Car Seats'),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Car and Journey Info Card
                    Card(
                      margin: EdgeInsets.all(16.w),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.directions_car,
                                    color: Theme.of(context).primaryColor),
                                SizedBox(width: 8.w),
                                Text(
                                  controller.car?.plateNumber ?? 'Unknown Car',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(Icons.schedule,
                                    color: Theme.of(context).primaryColor),
                                SizedBox(width: 8.w),
                                Text(
                                  '${controller.destination?.from ?? "--:--"} - ${controller.destination?.to ?? "--:--"}',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Seats Grid
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(16.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                        ),
                        itemCount: controller.seats.length,
                        itemBuilder: (context, index) {
                          final seat = controller.seats[index];
                          final passenger = controller.seatPassengers[seat.id];

                          return GestureDetector(
                            onTap: () {
                              if (passenger != null) {
                                _showPassengerDetails(context, passenger);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: passenger != null
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Seat ${seat.seatNumber}',
                                    style: TextStyle(
                                      color: passenger != null
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (passenger != null) ...[
                                    SizedBox(height: 4.h),
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Legend
                    Container(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem(
                            context,
                            Colors.grey[200]!,
                            'Available',
                          ),
                          SizedBox(width: 16.w),
                          _buildLegendItem(
                            context,
                            Theme.of(context).primaryColor,
                            'Booked',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
        ),
        SizedBox(width: 8.w),
        Text(label),
      ],
    );
  }

  void _showPassengerDetails(BuildContext context, PassengerDetails passenger) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Passenger Details',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow('Name', passenger.name, Icons.person),
            SizedBox(height: 8.h),
            _buildDetailRow(
              'Pickup Location',
              passenger.pickupLocation,
              Icons.location_on,
            ),
            SizedBox(height: 8.h),
            _buildDetailRow(
              'Seat Number',
              passenger.selectedSeats.join(', '),
              Icons.event_seat,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Colors.grey[600]),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
