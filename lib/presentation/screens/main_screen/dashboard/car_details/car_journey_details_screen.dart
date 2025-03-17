import 'package:car_ticket/domain/models/passenger/passenger_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../controller/dashboard/car_seats_controller.dart';

class CarJourneyDetailsScreen extends StatelessWidget {
  static final routeName = "/car-journey-details";
  final String carId;
  final String destinationId;

  const CarJourneyDetailsScreen({
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
            title:
                Text(controller.destination?.description ?? 'Journey Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    controller.loadCarSeatsData(carId, destinationId),
              ),
            ],
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Journey Info Card
                    _buildJourneyInfoCard(context, controller),

                    // Seats Grid
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            _buildSeatsGrid(context, controller),
                            SizedBox(height: 16.h),
                            _buildPassengersList(context, controller),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildJourneyInfoCard(
      BuildContext context, CarSeatsController controller) {
    return Card(
      margin: EdgeInsets.all(16.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_bus,
                    color: Theme.of(context).primaryColor, size: 24.sp),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.car?.plateNumber ?? 'Unknown Vehicle',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${controller.car?.name ?? 'Unknown'} - ${controller.car?.model ?? ''}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  context,
                  'Total Seats',
                  '${controller.seats.length}',
                  Icons.event_seat,
                ),
                _buildInfoItem(
                  context,
                  'Booked',
                  '${controller.seatPassengers.length}',
                  Icons.person,
                ),
                _buildInfoItem(
                  context,
                  'Available',
                  '${controller.seats.length - controller.seatPassengers.length}',
                  Icons.check_circle_outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSeatsGrid(BuildContext context, CarSeatsController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Seat ${seat.seatNumber}',
                  style: TextStyle(
                    color: passenger != null ? Colors.white : Colors.grey[600],
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
    );
  }

  Widget _buildPassengersList(
      BuildContext context, CarSeatsController controller) {
    final passengers = controller.seatPassengers.values.toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passengers List',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: passengers.length,
          itemBuilder: (context, index) {
            final passenger = passengers[index];
            return Card(
              margin: EdgeInsets.only(bottom: 8.h),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    passenger.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(passenger.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seats: ${passenger.selectedSeats.join(", ")}'),
                    Text(
                      'Pickup: ${passenger.pickupLocation}',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                onTap: () => _showPassengerDetails(context, passenger),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showPassengerDetails(BuildContext context, PassengerDetails passenger) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Text(
              'Passenger Details',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            _buildDetailRow('Name', passenger.name, Icons.person),
            _buildDetailRow(
                'Seats', passenger.selectedSeats.join(', '), Icons.event_seat),
            _buildDetailRow(
                'Pickup Location', passenger.pickupLocation, Icons.location_on),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey[600]),
          SizedBox(width: 12.w),
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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
