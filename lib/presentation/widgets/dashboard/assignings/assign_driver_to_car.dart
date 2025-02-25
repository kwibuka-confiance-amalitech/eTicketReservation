import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/controller/dashboard/driver_controller.dart';
import 'package:car_ticket/domain/models/car/car.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignDriverToCar extends StatelessWidget {
  final ExcelCar car;
  const AssignDriverToCar({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    CarController carController = Get.put(CarController());

    return GetBuilder(
        init: DriverController(),
        builder: (DriverController driverController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              children: [
                Text(
                  "Assign Driver to Car",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 40),
                driverController.isGettingDrivers
                    ? const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : carController.isAssigningDriver
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (driverController.drivers.isEmpty) {
                                return const Center(
                                  child: Text("No Drivers"),
                                );
                              }

                              Text Occupied = const Text("Assign");

                              if (car.driverId ==
                                  driverController.drivers[index].id) {
                                Occupied = const Text("Unassign");
                              }

                              if (driverController.drivers[index].isAssigned &&
                                  car.driverId !=
                                      driverController.drivers[index].id) {
                                Occupied = const Text("Assigned");
                              }

                              return Container(
                                child: ListTile(
                                  title: Text(driverController
                                      .drivers[index].firstName),
                                  subtitle: Text(
                                      driverController.drivers[index].email),
                                  trailing: ElevatedButton(
                                      onPressed: driverController
                                                  .drivers[index].isAssigned &&
                                              car.driverId !=
                                                  driverController
                                                      .drivers[index].id
                                          ? null
                                          : () {
                                              car.isAssigned
                                                  ? carController
                                                      .unAssignDriverToCar(
                                                          carId: car.id)
                                                  : carController
                                                      .assignDriverToCar(
                                                          carId: car.id,
                                                          driverId:
                                                              driverController
                                                                  .drivers[
                                                                      index]
                                                                  .id);
                                            },
                                      child: Occupied),
                                ),
                              );
                            },
                            itemCount: driverController.drivers.length),
              ],
            ),
          );
        });
  }
}
