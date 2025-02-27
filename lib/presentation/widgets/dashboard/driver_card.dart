import 'package:car_ticket/controller/dashboard/driver_controller.dart';
import 'package:car_ticket/domain/models/driver/driver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverItem extends StatelessWidget {
  final CarDriver driver;

  const DriverItem({required this.driver, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Column(
          children: [
            ListTile(
                leading: const Icon(Icons.person),
                title: Text('${driver.firstName} ${driver.lastName}'),
                subtitle: Text(driver.email),
                trailing: DriverOptionWidget(
                  driver: driver,
                )),
          ],
        ),
      ),
    );
  }
}

class DriverOptionWidget extends StatelessWidget {
  final CarDriver driver;
  const DriverOptionWidget({required this.driver, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (DriverController driverController) {
      return driver.id == driverController.deleteDriverId &&
              driverController.isDriverDeleting
          ? const CircularProgressIndicator()
          : PopupMenuButton<DriverStatus>(
              initialValue: driverController.selectedItem,
              onSelected: driverController.changeDriverStatus,
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<DriverStatus>>[
                PopupMenuItem<DriverStatus>(
                  value: DriverStatus.edit,
                  onTap: () {
                    // bottomSheetEditDriver(context, driver);
                  },
                  child: const Text('Edit'),
                ),
                PopupMenuItem<DriverStatus>(
                  value: DriverStatus.delete,
                  onTap: () => driverController.deleteDriver(driver),
                  child: const Text('Delete'),
                ),
              ],
            );
    });
  }

  // bottomSheetEditDriver(BuildContext context, CarDriver driver) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) => Padding(
  //       padding:
  //           EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  //       child: UpdateDriverWidget(driver: driver),
  //     ),
  //   );
  // }
}
