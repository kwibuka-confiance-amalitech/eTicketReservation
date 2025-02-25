import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddCarToDestination extends StatelessWidget {
  final JourneyDestination destination;
  const AddCarToDestination({required this.destination, super.key});

  @override
  Widget build(BuildContext context) {
    JourneyDestinationController destinationController =
        Get.find<JourneyDestinationController>();
    return GetBuilder(
        init: CarController(),
        builder: (CarController carController) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Wrap(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                  child: Text(
                    "Add Car to Destination",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                carController.isGettingCars ||
                        destinationController.isAssigningCar
                    ? SizedBox(
                        height: 130.h,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: carController.cars.length,
                        itemBuilder: (context, item) {
                          if (carController.cars.isEmpty) {
                            return const Center(
                              child: Text("No Cars"),
                            );
                          }
                          return Container(
                            margin: EdgeInsets.only(bottom: 20.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.drive_eta),
                                        Text(
                                            " ${carController.cars[item].name}"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 15.sp,
                                        ),
                                        Text(
                                            " ${carController.cars[item].color}"),
                                      ],
                                    ),
                                    Text(
                                        "Plate Number: ${carController.cars[item].plateNumber}",
                                        style: TextStyle(fontSize: 10.sp)),
                                  ],
                                ),
                                destinationController.isAssigningCar
                                    ? SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : ElevatedButton(
                                        onPressed: destination.carId ==
                                                carController.cars[item].id
                                            ? () => destinationController
                                                .unAssignCarToDestination(
                                                    destinationId:
                                                        destination.id)
                                            : () {
                                                destinationController
                                                    .assignCarToDestination(
                                                        destinationId:
                                                            destination.id,
                                                        carId: carController
                                                            .cars[item].id);
                                              },
                                        child: destination.carId ==
                                                carController.cars[item].id
                                            ? const Text('Unassign')
                                            : const Text('Assign'),
                                      ),
                              ],
                            ),
                          );
                        }),
              ],
            ),
          );
        });
  }
}
