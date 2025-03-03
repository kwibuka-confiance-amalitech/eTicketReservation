import 'dart:io';

import 'package:car_ticket/controller/dashboard/dashboard_stats_controller.dart';
import 'package:car_ticket/controller/dashboard/driver_controller.dart';
import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/domain/models/driver/driver.dart';
import 'package:car_ticket/domain/models/seat.dart';
import 'package:car_ticket/domain/repositories/car_repository/car_repository_imp.dart';
import 'package:car_ticket/domain/repositories/user/driver_repository_imp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isCarCreating = false;
  bool isGettingCars = false;
  bool isCarDeleting = false;
  bool isUpdatingCar = false;

  String deleteCarId = '';

  CarStatus? selectedItem;
  List<ExcelCar> cars = [];
  List<Seat> selectedSeats = [];

  bool isSaving = false;
  bool isSharing = false;

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

      // Refresh dashboard stats if controller exists
      if (Get.isRegistered<DashboardStatsController>()) {
        Get.find<DashboardStatsController>().refreshStats();
      }
    } catch (e) {
      isCarCreating = false;
      update();
      rethrow;
    }
  }

  Future<void> getCars() async {
    try {
      isGettingCars = true;
      update();

      final carsSnapshot = await _firestore.collection('cars').get();

      cars = carsSnapshot.docs
          .map((doc) => ExcelCar.fromDocument(doc.data()))
          .toList();

      // Calculate seat availability for all cars
      await updateSeatAvailability();
    } catch (e) {
      print('Error fetching cars: $e');
    } finally {
      isGettingCars = false;
      update();
    }
  }

  Future<void> updateSeatAvailability() async {
    try {
      final updatedCars = <ExcelCar>[];

      for (final car in cars) {
        // Fetch active bookings for this car
        final bookingsSnapshot = await _firestore
            .collection('payments')
            .where('carId', isEqualTo: car.id)
            .where('paymentStatus', whereIn: ['completed', 'success']).get();

        // Count total booked seats from all bookings
        int totalBookedSeats = 0;
        for (var doc in bookingsSnapshot.docs) {
          final List<dynamic> seats = doc['seats'] ?? [];
          totalBookedSeats += seats.length;
        }

        // Calculate remaining seats
        final int remainingSeats = car.seatNumbers - totalBookedSeats;

        // Create updated car with seat information
        final updatedCar = car.copyWith(
          bookedSeats: totalBookedSeats,
          remainingSeats: remainingSeats,
        );

        updatedCars.add(updatedCar);
      }

      // Replace cars list with updated information
      cars = updatedCars;
      update();
    } catch (e) {
      print('Error updating seat availability: $e');
    }
  }

  // Add this new method to check if a driver is already assigned to any car
  Future<bool> isDriverAlreadyAssigned(String driverId) async {
    try {
      // Query for cars with this driver
      final carsSnapshot = await _firestore
          .collection('cars')
          .where('driverId', isEqualTo: driverId)
          .get();

      // Return true if any cars found with this driver
      return carsSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking driver assignment: $e');
      return false;
    }
  }

  // Now modify the assignDriverToCar method to include this check
  Future assignDriverToCar({
    required String carId,
    required String driverId,
    String? driverName,
  }) async {
    try {
      isAssigningDriver = true;
      update();

      // First check if this driver is already assigned elsewhere
      final bool alreadyAssigned = await isDriverAlreadyAssigned(driverId);

      if (alreadyAssigned) {
        // If driver is already assigned to a different car, throw an error
        isAssigningDriver = false;
        update();

        // Get the car this driver is assigned to
        final assignedCarSnapshot = await _firestore
            .collection('cars')
            .where('driverId', isEqualTo: driverId)
            .get();

        String carName = "another vehicle";
        if (assignedCarSnapshot.docs.isNotEmpty) {
          carName = assignedCarSnapshot.docs.first.data()['name'] ??
              "another vehicle";
        }

        Get.snackbar(
          "Driver Already Assigned",
          "This driver is already assigned to $carName. Please unassign the driver first.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );

        return;
      }

      // Proceed with assignment since driver is available
      String finalDriverName = driverName ?? '';

      // If driver name wasn't provided, try to fetch it
      if (finalDriverName.isEmpty) {
        try {
          final driverDoc =
              await _firestore.collection('drivers').doc(driverId).get();
          if (driverDoc.exists) {
            final firstName = driverDoc.data()?['firstName'] ?? '';
            final lastName = driverDoc.data()?['lastName'] ?? '';
            finalDriverName = '$firstName $lastName'.trim();
          }
        } catch (e) {
          print('Error fetching driver name: $e');
        }
      }

      // Assign the driver to the car
      await carRepository.assignDriverToCar(driverId, carId,
          driverName: finalDriverName);

      // IMPORTANT: Now update the driver's status to assigned
      final driverRepository = Get.find<DriverRepositoryImp>();
      final driverDoc =
          await _firestore.collection('drivers').doc(driverId).get();
      if (driverDoc.exists) {
        final driver = CarDriver.fromDocument(driverDoc.data()!);
        final updatedDriver = driver.copyWith(isAssigned: true);
        await driverRepository.updateDriver(updatedDriver);
      }

      // Refresh data
      await getCars();
      await Get.find<DriverController>().getDrivers();

      // Refresh dashboard stats if controller exists
      if (Get.isRegistered<DashboardStatsController>()) {
        Get.find<DashboardStatsController>().refreshStats();
      }

      isAssigningDriver = false;
      update();
      Get.back();
      Get.snackbar("Driver Assigned",
          "Driver ${finalDriverName.isNotEmpty ? finalDriverName : 'has been'} assigned to car successfully",
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

      // Get the driver ID before unassigning
      final carDoc = await _firestore.collection('cars').doc(carId).get();
      final String? driverId = carDoc.data()?['driverId'];

      // Unassign the driver from car
      await carRepository.unAssignDriverToCar(carId);

      // IMPORTANT: Also update the driver's status if a driver was assigned
      if (driverId != null && driverId.isNotEmpty) {
        final driverRepository = Get.find<DriverRepositoryImp>();
        final driverDoc =
            await _firestore.collection('drivers').doc(driverId).get();
        if (driverDoc.exists) {
          final driver = CarDriver.fromDocument(driverDoc.data()!);
          final updatedDriver = driver.copyWith(isAssigned: false);
          await driverRepository.updateDriver(updatedDriver);
        }
      }

      // Refresh data
      await getCars();
      await Get.find<DriverController>().getDrivers();

      // Refresh dashboard stats if controller exists
      if (Get.isRegistered<DashboardStatsController>()) {
        Get.find<DashboardStatsController>().refreshStats();
      }

      isAssigningDriver = false;
      update();
      Get.snackbar(
          "Driver Unassigned", "Driver has been unassigned successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isAssigningDriver = false;
      update();
      Get.snackbar("Error", "An error occurred while unassigning driver",
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

      // Refresh dashboard stats if controller exists
      if (Get.isRegistered<DashboardStatsController>()) {
        Get.find<DashboardStatsController>().refreshStats();
      }
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

  // Add these methods
  void setSaving(bool value) {
    isSaving = value;
    update();
  }

  void setSharing(bool value) {
    isSharing = value;
    update();
  }

  // Add method to get destination for car
  JourneyDestination? getDestinationForCar(String carId) {
    try {
      // Check if JourneyDestinationController is registered before trying to find it
      if (!Get.isRegistered<JourneyDestinationController>()) {
        print('Warning: JourneyDestinationController not registered');
        return null;
      }

      final journeyController = Get.find<JourneyDestinationController>();
      return journeyController.destinations.firstWhereOrNull(
        (dest) => dest.carId == carId && dest.isAssigned,
      );
    } catch (e) {
      print('Error getting destination for car: $e');
      return null;
    }
  }

  // Add this method to your CarController
  Future<void> updateCarsWithCreatedAt() async {
    try {
      isUpdatingCar = true;
      update();

      // Get cars without createdAt
      await getCars();

      // Update each car
      for (final car in cars) {
        final updatedCar =
            car; // In a real scenario, you'd create a new car with createdAt
        await carRepository.updateCar(updatedCar);
      }

      await getCars(); // Refresh the list
      isUpdatingCar = false;
      update();

      Get.snackbar(
        'Success',
        'All cars updated with created timestamp',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      isUpdatingCar = false;
      update();
      Get.snackbar(
        'Error',
        'Failed to update cars: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
