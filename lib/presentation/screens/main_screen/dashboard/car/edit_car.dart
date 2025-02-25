import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/presentation/widgets/custom_textfields_decoration.dart';
import 'package:car_ticket/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class EditCarWidget extends StatelessWidget {
  final ExcelCar car;
  const EditCarWidget({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CarController(),
        builder: (CarController carController) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                child: Form(
                  key: carController.carformKey,
                  child: Column(
                    children: [
                      TextFormField(
                          initialValue: car.name,
                          decoration: customTextFieldDecoration(
                              labelText: "Name",
                              hintText: "Name",
                              context: context),
                          onChanged: (value) {
                            carController.nameController.text = value;
                          }),
                      Gap(15.h),
                      TextFormField(
                          initialValue: car.plateNumber,
                          decoration: customTextFieldDecoration(
                              labelText: "Plate Number",
                              hintText: "Plate Number",
                              context: context),
                          onChanged: (value) {
                            carController.plateNumberController.text = value;
                          }),
                      Gap(15.h),
                      TextFormField(
                          initialValue: car.color,
                          decoration: customTextFieldDecoration(
                              labelText: "Color",
                              hintText: "Color",
                              context: context),
                          onChanged: (value) {
                            carController.colorController.text = value;
                          }),
                      Gap(15.h),
                      TextFormField(
                          initialValue: car.model,
                          decoration: customTextFieldDecoration(
                              labelText: "Model",
                              hintText: "Model",
                              context: context),
                          onChanged: (value) {
                            carController.modelController.text = value;
                          }),
                      Gap(15.h),
                      TextFormField(
                          initialValue: car.year,
                          decoration: customTextFieldDecoration(
                              labelText: "Year",
                              hintText: "Year",
                              context: context),
                          onChanged: (value) {
                            carController.yearController.text = value;
                          }),
                      Gap(15.h),
                      MainButton(
                        isColored: true,
                        title: "Update Car",
                        isDisabled: carController.isUpdatingCar,
                        isLoading: carController.isUpdatingCar,
                        onPressed: () async {
                          await carController.updateCar(ExcelCar(
                            id: car.id,
                            name: carController.nameController.text.isEmpty
                                ? car.name
                                : carController.nameController.text,
                            plateNumber:
                                carController.plateNumberController.text.isEmpty
                                    ? car.plateNumber
                                    : carController.plateNumberController.text,
                            color: carController.colorController.text.isEmpty
                                ? car.color
                                : carController.colorController.text,
                            model: carController.modelController.text.isEmpty
                                ? car.model
                                : carController.modelController.text,
                            year: carController.yearController.text.isEmpty
                                ? car.year
                                : carController.yearController.text,
                            driverId: car.driverId,
                            isAssigned: car.isAssigned,
                            seatNumbers: car.seatNumbers,
                          ));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
