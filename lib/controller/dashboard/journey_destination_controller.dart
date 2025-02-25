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

  Future updateDestination(JourneyDestination destination) async {
    try {
      await journeyRepository.updateDestination(destination);
    } catch (e) {
      rethrow;
    }
  }

  Future assignCarToDestination(
      {required String carId, required String destinationId}) async {
    try {
      isAssigningCar = true;
      update();
      // if (destinations.any((element) => element.carId == carId)) {
      //   Get.snackbar("Error", "Car has already been assigned to a destination",
      //       snackPosition: SnackPosition.BOTTOM);
      //   isAssigningCar = false;
      //   update();
      //   return;
      // } else if (destinations.any((element) => element.id == destinationId)) {
      //   Get.snackbar("Error", "Destination already has a car assigned to it",
      //       snackPosition: SnackPosition.BOTTOM);
      //   isAssigningCar = false;
      //   update();
      //   return;
      // }

      await journeyRepository.assignCarToDestination(
          carId: carId, destinationId: destinationId);
      await getDestinations();
      isAssigningCar = false;
      update();
      Get.back();
      Get.snackbar("Car Assigned", "Car has been assigned to destination",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isAssigningCar = false;
      update();
      Get.snackbar("Error", "Error assigning car to destination",
          snackPosition: SnackPosition.BOTTOM);
      rethrow;
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
}
