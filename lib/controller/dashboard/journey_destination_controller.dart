import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/domain/repositories/destination_repository/destination_journey_imp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum JourneyDestinationStatus { edit, delete }

class JourneyDestinationController extends GetxController {
  JourneyDestinationImp journeyRepository = Get.put(JourneyDestinationImp());
  bool isGettingDestinations = false;
  bool isDestinationCreating = false;
  bool isAssigningCar = false;
  String deleteDestinationId = '';
  bool isDestinationDeleting = false;
  bool isDestinationUpdating = false;

  List<JourneyDestination> destinations = [];

  final destinationformKey = GlobalKey<FormState>();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  final availableSeatsController = TextEditingController();
  // final fromController = TextEditingController();
  // final toController = TextEditingController();
  // final startDateController = TextEditingController();

  JourneyDestinationStatus? selectedItem;

  String? selectedDestination;
  String initialTime = "00:00";
  String finalTime = "00:00";

  DateTime? startDate;

  @override
  void onInit() {
    getDestinations();
    super.onInit();
  }

  void changeDestinationStatus(JourneyDestinationStatus? status) {
    selectedItem = status;
    update();
  }

  Future createDestination(JourneyDestination destination) async {
    isDestinationCreating = true;
    update();
    try {
      destination = destination.copyWith(startDate: startDate?.toString());
      await journeyRepository.createDestination(destination);
      await getDestinations();
      Get.back();
      isDestinationCreating = false;
      update();
    } catch (e) {
      rethrow;
    }
  }

  Future deleteDestination(JourneyDestination destination) async {
    isDestinationDeleting = true;
    deleteDestinationId = destination.id;
    update();
    try {
      await journeyRepository.deleteDestination(destination.id);
      await getDestinations();
      isDestinationDeleting = false;
      deleteDestinationId = '';
      update();
    } catch (e) {
      isDestinationDeleting = false;
      deleteDestinationId = '';
      update();
      rethrow;
    }
  }

  Future getDestinationById(JourneyDestination destination) async {
    try {
      await journeyRepository.getDestinationById(destination.id);
    } catch (e) {
      rethrow;
    }
  }

  Future getDestinations() async {
    isGettingDestinations = true;
    update();
    try {
      final newDestination = await journeyRepository.getDestinations();
      destinations = newDestination;
      isGettingDestinations = false;
      update();
    } catch (e) {
      isGettingDestinations = false;
      update();
      rethrow;
    }
  }

  Future searchDestinations(String time, String location) async {
    try {
      await journeyRepository.searchDestinations(time, location);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDestination(JourneyDestination destination) async {
    try {
      isDestinationUpdating = true;
      update();

      await journeyRepository.updateDestination(destination);

      // Refresh destination list
      await getDestinations();

      isDestinationUpdating = false;
      update();
      return;
    } catch (e) {
      isDestinationUpdating = false;
      update();
      Get.snackbar(
        "Error",
        "Failed to update destination: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future assignCarToDestination({
    required String carId,
    required String destinationId,
  }) async {
    try {
      isAssigningCar = true;
      update();

      // Check if destination already has a car assigned (that isn't this car)
      final destination = destinations.firstWhere((d) => d.id == destinationId);
      if (destination.isAssigned &&
          destination.carId.isNotEmpty &&
          destination.carId != carId) {
        isAssigningCar = false;
        update();
        Get.snackbar(
          "Error",
          "This route already has a car assigned. Please unassign first or use the Change Vehicle option.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      // Check if car is already assigned to another destination
      final isAssigned = await isCarAlreadyAssigned(carId);
      if (isAssigned) {
        isAssigningCar = false;
        update();
        return; // Error message already shown in isCarAlreadyAssigned method
      }

      // If all checks pass, proceed with assignment
      await journeyRepository.assignCarToDestination(
        carId: carId,
        destinationId: destinationId,
      );

      await getDestinations();
      isAssigningCar = false;
      update();

      Get.snackbar(
        "Success",
        "Vehicle has been assigned to route",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      isAssigningCar = false;
      update();
      Get.snackbar(
        "Error",
        "Failed to assign vehicle: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future unAssignCarToDestination({required String destinationId}) async {
    try {
      isAssigningCar = true;
      update();
      await journeyRepository.unAssignCarToDestination(destinationId);
      await getDestinations();
      isAssigningCar = false;
      update();
      Get.back();
      Get.snackbar("Car Unassigned", "Car has been unassigned to destination",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isAssigningCar = false;
      update();
      Get.snackbar("Error", "Error unassigning car to destination",
          snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  // Add this new method to check if car is already assigned
  Future<bool> isCarAlreadyAssigned(String carId) async {
    try {
      // Check if car is assigned to any destination
      final existingDestination = destinations.firstWhereOrNull(
        (dest) => dest.carId == carId && dest.isAssigned,
      );

      if (existingDestination != null) {
        Get.snackbar(
          "Vehicle Already Assigned",
          "This vehicle is already assigned to route: ${existingDestination.description}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Error checking car assignment: $e');
      return false;
    }
  }

  initializeItemsForEdit(JourneyDestination destination) {
    selectedDestination = destination.description;
    initialTime = destination.from;
    finalTime = destination.to;
    update();
  }

  clearInitializedItems() {
    selectedDestination = null;
    initialTime = "00:00";
    finalTime = "00:00";
    update();
  }

  selectedDestinationChange(String? value) {
    selectedDestination = value;

    update();
  }

// get range in hour between initial and final time
  String get durationTime {
    final initial = initialTime.split(":");
    final finalS = finalTime.split(":");

    final initialHour = int.parse(initial[0]);
    final initialMinute = int.parse(initial[1]);

    final finalHour = int.parse(finalS[0]);
    final finalMinute = int.parse(finalS[1]);

    final hour = finalHour - initialHour;
    final minute = finalMinute - initialMinute;

    return "$hour:$minute";
  }

  List<String> getUniqueLocations() {
    // Extract all from and to locations
    final Set<String> uniqueLocations = <String>{};

    for (var destination in destinations) {
      uniqueLocations.add(destination.from);
      uniqueLocations.add(destination.to);
    }

    // Convert to sorted list
    final locations = uniqueLocations.toList()..sort();
    return locations;
  }
}
