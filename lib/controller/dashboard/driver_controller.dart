import 'dart:async';

import 'package:car_ticket/domain/models/driver/driver.dart';
import 'package:car_ticket/domain/repositories/user/driver_repository_imp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DriverStatus { edit, delete }

class DriverController extends GetxController {
  DriverRepositoryImp driverRepository = Get.put(DriverRepositoryImp());

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final driverLicenseCategoryController = TextEditingController();

  bool isDriverCreating = false;
  bool isGettingDrivers = false;
  bool isDriverDeleting = false;
  bool isDriverUpdating = false;

  String deleteDriverId = "";
  String updateDriverId = "";
  List<CarDriver> drivers = [];

  DriverStatus? selectedItem;

  @override
  void onInit() {
    getDrivers();
    super.onInit();
  }

  Future addDriver(CarDriver driver) async {
    isDriverCreating = true;
    update();
    try {
      await driverRepository.createDriver(driver);
      Get.back();
      await getDrivers();
      Get.snackbar("Driver Created", "Driver has been created successfully",
          snackPosition: SnackPosition.BOTTOM);
      isDriverCreating = false;
      update();
    } catch (e) {
      isDriverCreating = false;
      update();
      rethrow;
    }
  }

  Future getDrivers() async {
    isGettingDrivers = true;
    update();
    try {
      final response = await driverRepository.getDrivers();
      drivers = response;
      isGettingDrivers = false;
      update();
    } catch (e) {
      isGettingDrivers = false;
      update();
      rethrow;
    }
  }

  changeDriverStatus(DriverStatus status) {
    selectedItem = status;
    update();
  }

  Future deleteDriver(CarDriver driver) async {
    isDriverDeleting = true;
    deleteDriverId = driver.id;
    update();
    try {
      await driverRepository.deleteDriver(driver);
      await getDrivers();
      Get.snackbar("Driver Deleted", "Driver has been deleted successfully",
          snackPosition: SnackPosition.BOTTOM);
      isDriverDeleting = false;
      deleteDriverId = "";
      update();
    } catch (e) {
      isDriverDeleting = false;
      deleteDriverId = "";
      update();
      rethrow;
    }
  }

  Future updateDriver(CarDriver driver) async {
    isDriverUpdating = true;
    updateDriverId = driver.id;
    update();
    try {
      await driverRepository.updateDriver(driver);
      await getDrivers();
      Get.back();
      Get.snackbar("Driver Updated", "Driver has been updated successfully",
          snackPosition: SnackPosition.BOTTOM);
      isDriverUpdating = false;
      updateDriverId = "";
      update();
    } catch (e) {
      isDriverUpdating = false;
      updateDriverId = "";
      update();
      rethrow;
    }
  }
}
