import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/destination/edit_destination.dart';
import 'package:car_ticket/presentation/widgets/dashboard/assignings/assign_car_to_destination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DestinationCard extends StatelessWidget {
  final JourneyDestination destination;

  const DestinationCard({
    super.key,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 15.h),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(
                destination.description,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.payments_outlined,
                        size: 16.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "${destination.price} Rwf",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.timeline,
                        size: 16.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "${destination.from} to ${destination.to}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 16.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        destination.duration,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  if (destination.startDate != null) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Start Date: ${_formatDate(destination.startDate!)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return AddCarToDestination(
                                  destination: destination,
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.directions_car,
                            size: 18.sp,
                          ),
                          label: Text(
                            'Add Car to Destination',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 16.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: DestinationOptionWidget(destination: destination),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Date not set';
    }
  }
}

class DestinationOptionWidget extends StatelessWidget {
  final JourneyDestination destination;
  const DestinationOptionWidget({required this.destination, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        builder: (JourneyDestinationController destinationController) {
      return destination.id == destinationController.deleteDestinationId &&
              destinationController.isDestinationDeleting
          ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : SizedBox(
              width: 32.w, // Reduced width
              child: PopupMenuButton<JourneyDestinationStatus>(
                padding: EdgeInsets.zero, // Remove padding
                icon: Icon(
                  Icons.more_vert,
                  size: 20.sp, // Smaller icon
                  color: Colors.grey[600],
                ),
                initialValue: destinationController.selectedItem,
                onSelected: destinationController.changeDestinationStatus,
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<JourneyDestinationStatus>>[
                  PopupMenuItem<JourneyDestinationStatus>(
                    value: JourneyDestinationStatus.edit,
                    onTap: () {
                      destinationController.initializeItemsForEdit(destination);
                      bottomSheetEditCar(context, destination);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18.sp),
                        SizedBox(width: 8.w),
                        const Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem<JourneyDestinationStatus>(
                    value: JourneyDestinationStatus.delete,
                    onTap: () =>
                        destinationController.deleteDestination(destination),
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18.sp, color: Colors.red),
                        SizedBox(width: 8.w),
                        const Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }
  
  bottomSheetEditCar(BuildContext context, JourneyDestination destination) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: EditDestinationWidget(destination: destination),
      ),
    );
  }
}
