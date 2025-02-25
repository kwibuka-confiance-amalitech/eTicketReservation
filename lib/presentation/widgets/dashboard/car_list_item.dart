import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/car/edit_car.dart';
import 'package:car_ticket/presentation/widgets/dashboard/assignings/assign_driver_to_car.dart';
import 'package:car_ticket/presentation/widgets/dashboard/car_qrcode_creation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CarListItem extends StatelessWidget {
  final ExcelCar car;

  const CarListItem({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.car_rental),
              title: Text(car.name),
              subtitle: Text(car.plateNumber),
              trailing: CarOptionWidget(
                car: car,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return CarQrCodeCreation(
                              car: car,
                            );
                          });
                    },
                    child: const Text('Create Qr Code'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return AssignDriverToCar(
                              car: car,
                            );
                          });
                    },
                    child: car.driverId.isEmpty
                        ? const Text("Assign Driver")
                        : const Text('Change Driver'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CarOptionWidget extends StatelessWidget {
  final ExcelCar car;
  const CarOptionWidget({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (CarController carController) {
      return car.id == carController.deleteCarId && carController.isCarDeleting
          ? const CircularProgressIndicator()
          : PopupMenuButton<CarStatus>(
              initialValue: carController.selectedItem,
              onSelected: carController.changeCarStatus,
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<CarStatus>>[
                PopupMenuItem<CarStatus>(
                  value: CarStatus.edit,
                  onTap: () {
                    bottomSheetEditCar(context, car);
                  },
                  child: const Text('Edit'),
                ),
                PopupMenuItem<CarStatus>(
                  value: CarStatus.delete,
                  onTap: () => carController.deleteCar(car),
                  child: const Text('Delete'),
                ),
              ],
            );
    });
  }

  bottomSheetEditCar(BuildContext context, ExcelCar car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: EditCarWidget(car: car),
      ),
    );
  }
}
