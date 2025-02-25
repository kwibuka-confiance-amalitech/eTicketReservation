import 'dart:io';

import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/domain/models/seat.dart';
import 'package:car_ticket/domain/repositories/car_repository/car_repository_imp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

enum CarStatus { edit, delete }

class CarController extends GetxController {
  CarRepositoryImp carRepository = Get.put(CarRepositoryImp());
  final carformKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final plateNumberController = TextEditingController();
  final colorController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  bool isDownloadingQrCode = false;
  bool isAssigningDriver = false;

  ScreenshotController screenshotController = ScreenshotController();

  bool isCarCreating = false;
  bool isGettingCars = false;
  bool isCarDeleting = false;
  bool isUpdatingCar = false;

  String deleteCarId = '';

  CarStatus? selectedItem;
  List<ExcelCar> cars = [];
  List<Seat> selectedSeats = [];

  @override
  void onInit() {
    getCars();
    super.onInit();
  }

  void changeCarStatus(CarStatus? status) {
    selectedItem = status;
    update();
  }

  Future addCar(ExcelCar car) async {
    isCarCreating = true;
    update();
    try {
      await carRepository.createCar(car);
      Get.back();
      await getCars();

      Get.snackbar("Car Created", "Car has been created successfully",
          snackPosition: SnackPosition.BOTTOM);
      isCarCreating = false;
      update();
    } catch (e) {
      isCarCreating = false;
      update();
      rethrow;
    }
  }

  Future getCars() async {
    isGettingCars = true;
    update();
    try {
      final response = await carRepository.getCars();

      cars = response;
      isGettingCars = false;
      update();
    } catch (e) {
      isGettingCars = false;
      update();
      rethrow;
    }
  }

  Future assignDriverToCar(
      {required String carId, required String driverId}) async {
    try {
      isAssigningDriver = true;
      update();
      await carRepository.assignDriverToCar(driverId, carId);
      isAssigningDriver = false;
      update();
      Get.back();
      Get.snackbar(
          "Driver Assigned", "Driver has been assigned to car successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isAssigningDriver = false;
      update();
      Get.snackbar("Error", "An error occurred while assigning driver to car",
          snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future unAssignDriverToCar({required String carId}) async {
    try {
      isAssigningDriver = true;
      update();
      await carRepository.unAssignDriverToCar(carId);
      isAssigningDriver = false;
      update();
      Get.back();
      Get.snackbar(
          "Driver Unassigned", "Driver has been unassigned to car successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isAssigningDriver = false;
      update();
      Get.snackbar("Error", "An error occurred while unassigning driver to car",
          snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  downloadScreenShot(ExcelCar car) async {
    isDownloadingQrCode = true;
    update();
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    print(appDocDirectory);

    await screenshotController.captureAndSave(
      appDocDirectory.path,
      pixelRatio: 2.0,
      fileName: "${appDocDirectory.path}/${car.name}/plate:${car.plateNumber}",
    );

    Get.snackbar("Downloaded", "Qr Code has been downloaded successfully",
        snackPosition: SnackPosition.BOTTOM);

    isDownloadingQrCode = false;
    update();
  }

  Future deleteCar(ExcelCar car) async {
    isCarDeleting = true;
    deleteCarId = car.id;
    update();
    try {
      await carRepository.deleteCar(car);
      await getCars();
      Get.snackbar("Car Deleted", "Car has been deleted successfully",
          snackPosition: SnackPosition.BOTTOM);
      isCarDeleting = false;
      deleteCarId = '';
      update();
    } catch (e) {
      isCarDeleting = false;
      deleteCarId = '';
      update();
      rethrow;
    }
  }

  Future updateCar(ExcelCar car) async {
    isUpdatingCar = true;
    update();
    try {
      await carRepository.updateCar(car);
      await getCars();
      Get.back();
      Get.snackbar("Car Updated", "Car has been updated successfully",
          snackPosition: SnackPosition.BOTTOM);
      isUpdatingCar = false;
      update();
    } catch (e) {
      isUpdatingCar = false;
      update();
      rethrow;
    }
  }
}
