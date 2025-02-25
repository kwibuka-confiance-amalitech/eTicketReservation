import 'package:car_ticket/controller/dashboard/driver_controller.dart';
import 'package:car_ticket/domain/models/driver/driver.dart';
import 'package:car_ticket/presentation/widgets/custom_textfields_decoration.dart';
import 'package:car_ticket/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:uuid/uuid.dart';

class AddDriver extends StatelessWidget {
  const AddDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: DriverController(),
        builder: (DriverController driverController) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                child: Text(
                  "Add Driver",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Form(
                    key: driverController.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: driverController.firstNameController,
                            textInputAction: TextInputAction.next,
                            decoration: customTextFieldDecoration(
                                labelText: "First Name",
                                hintText: "First Name",
                                context: context)),
                        Gap(15.h),
                        TextFormField(
                            controller: driverController.lastNameController,
                            textInputAction: TextInputAction.next,
                            decoration: customTextFieldDecoration(
                                labelText: "Last Name",
                                hintText: "Last Name",
                                context: context)),
                        Gap(15.h),
                        TextFormField(
                            controller: driverController.emailController,
                            textInputAction: TextInputAction.next,
                            decoration: customTextFieldDecoration(
                                labelText: "Email",
                                hintText: "Email",
                                context: context)),
                        Gap(15.h),
                        TextFormField(
                            controller: driverController.phoneController,
                            textInputAction: TextInputAction.next,
                            decoration: customTextFieldDecoration(
                                labelText: "Phone",
                                hintText: "Phone",
                                context: context)),
                        Gap(15.h),
                        TextFormField(
                            controller: driverController.addressController,
                            textInputAction: TextInputAction.next,
                            decoration: customTextFieldDecoration(
                                labelText: "Address",
                                hintText: "Address",
                                context: context)),
                        Gap(15.h),
                        TextFormField(
                            controller: driverController.cityController,
                            textInputAction: TextInputAction.next,
                            decoration: customTextFieldDecoration(
                                labelText: "City",
                                hintText: "City",
                                context: context)),
                        Gap(15.h),
                        TextFormField(
                            controller: driverController
                                .driverLicenseCategoryController,
                            textInputAction: TextInputAction.done,
                            decoration: customTextFieldDecoration(
                                labelText: "Driver License Category",
                                hintText: "Driver License Category",
                                context: context)),
                      ],
                    )),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                child: MainButton(
                    isColored: true,
                    isLoading: driverController.isDriverCreating,
                    isDisabled: driverController.isDriverCreating,
                    onPressed: () {
                      const uuid = Uuid();
                      CarDriver driver = CarDriver(
                          id: uuid.v1(),
                          firstName: driverController.firstNameController.text,
                          lastName: driverController.lastNameController.text,
                          email: driverController.emailController.text,
                          phone: driverController.phoneController.text,
                          address: driverController.addressController.text,
                          city: driverController.cityController.text,
                          driverLicenseCategory: driverController
                              .driverLicenseCategoryController.text,
                          isAssigned: false,
                          sexStatus: "Not Specified");

                      if (driverController.formKey.currentState!.validate()) {
                        // print("driver: $driver");

                        driverController.addDriver(driver);
                      }
                    },
                    title: "Add Driver"),
              )
            ],
          );
        });
  }
}
