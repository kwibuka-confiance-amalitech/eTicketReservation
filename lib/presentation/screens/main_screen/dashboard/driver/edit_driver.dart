import 'package:car_ticket/controller/dashboard/driver_controller.dart';
import 'package:car_ticket/domain/models/driver/driver.dart';
import 'package:car_ticket/presentation/widgets/custom_textfields_decoration.dart';
import 'package:car_ticket/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class UpdateDriverWidget extends StatelessWidget {
  final CarDriver driver;
  const UpdateDriverWidget({required this.driver, super.key});

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
                  "Update Driver",
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
                          initialValue: driver.firstName,
                          textInputAction: TextInputAction.next,
                          decoration: customTextFieldDecoration(
                              labelText: "First Name",
                              hintText: "First Name",
                              context: context),
                          onChanged: (value) {
                            driverController.firstNameController.text = value;
                          },
                        ),
                        Gap(15.h),
                        TextFormField(
                            initialValue: driver.lastName,
                            decoration: customTextFieldDecoration(
                                labelText: "Last Name",
                                hintText: "Last Name",
                                context: context),
                            onChanged: (value) {
                              driverController.lastNameController.text = value;
                            }),
                        Gap(15.h),
                        TextFormField(
                            initialValue: driver.email,
                            textInputAction: TextInputAction.next,
                            decoration: customTextFieldDecoration(
                                labelText: "Email",
                                hintText: "Email",
                                context: context),
                            onChanged: (value) {
                              driverController.emailController.text = value;
                            }),
                        Gap(15.h),
                        TextFormField(
                            initialValue: driver.phone,
                            textInputAction: TextInputAction.next,
                            decoration: customTextFieldDecoration(
                                labelText: "Phone",
                                hintText: "Phone",
                                context: context),
                            onChanged: (value) {
                              driverController.phoneController.text = value;
                            }),
                        Gap(15.h),
                        TextFormField(
                            initialValue: driver.address,
                            textInputAction: TextInputAction.next,
                            decoration: customTextFieldDecoration(
                                labelText: "Address",
                                hintText: "Address",
                                context: context),
                            onChanged: (value) {
                              driverController.addressController.text = value;
                            }),
                        Gap(15.h),
                        TextFormField(
                            initialValue: driver.city,
                            textInputAction: TextInputAction.next,
                            decoration: customTextFieldDecoration(
                                labelText: "City",
                                hintText: "City",
                                context: context),
                            onChanged: (value) {
                              driverController.cityController.text = value;
                            }),
                        Gap(15.h),
                        TextFormField(
                            initialValue: driver.driverLicenseCategory,
                            textInputAction: TextInputAction.done,
                            decoration: customTextFieldDecoration(
                                labelText: "Driver License Category",
                                hintText: "Driver License Category",
                                context: context),
                            onChanged: (value) {
                              driverController
                                  .driverLicenseCategoryController.text = value;
                            }),
                      ],
                    )),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                child: MainButton(
                    isColored: true,
                    isLoading: driverController.isDriverUpdating,
                    isDisabled: driverController.isDriverUpdating,
                    onPressed: () {
                      CarDriver updatedDriver = CarDriver(
                        id: driver.id,
                        firstName:
                            driverController.firstNameController.text.isEmpty
                                ? driver.firstName
                                : driverController.firstNameController.text,
                        lastName:
                            driverController.lastNameController.text.isEmpty
                                ? driver.lastName
                                : driverController.lastNameController.text,
                        email: driverController.emailController.text.isEmpty
                            ? driver.email
                            : driverController.emailController.text,
                        phone: driverController.phoneController.text.isEmpty
                            ? driver.phone
                            : driverController.phoneController.text,
                        address: driverController.addressController.text.isEmpty
                            ? driver.address
                            : driverController.addressController.text,
                        city: driverController.cityController.text.isEmpty
                            ? driver.city
                            : driverController.cityController.text,
                        driverLicenseCategory: driverController
                                .driverLicenseCategoryController.text.isEmpty
                            ? driver.driverLicenseCategory
                            : driverController
                                .driverLicenseCategoryController.text,
                        isAssigned: driver.isAssigned,
                        sexStatus: driver.sexStatus,
                      );

                      if (driverController.formKey.currentState!.validate()) {
                        driverController.updateDriver(updatedDriver);
                      }
                    },
                    title: "Update Driver"),
              )
            ],
          );
        });
  }
}
