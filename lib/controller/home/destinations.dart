import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/domain/repositories/destination_repository/destination_journey_imp.dart';
import 'package:car_ticket/domain/repositories/home_repository/home_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeJourneyDestinationController extends GetxController {
  JourneyDestinationImp journeyRepository = Get.put(JourneyDestinationImp());

  List<JourneyDestination> destinations = [];
  bool isGettingDestinations = false;
  JourneyDestination selectedDestination = JourneyDestination.empty;
  String? selectedDestinationOption;
  String? selectedTimeOption;
  bool isAllDestinationsShown = true;

  @override
  void onInit() {
    getDestinations();
    super.onInit();
  }

  Future getDestinations() async {
    isGettingDestinations = true;
    update();
    try {
      destinations =
          await HomeJourneyDestionationsRepositoryImpl().getDestinations();
      isGettingDestinations = false;
      update();
    } catch (e) {
      isGettingDestinations = false;
      update();

      rethrow;
    }
  }

  Future searchDestinations(String time, String location) async {
    isAllDestinationsShown = false;
    isGettingDestinations = true;
    update();
    try {
      List<JourneyDestination> destinationsFiltered = [];
      final response =
          await journeyRepository.searchDestinations(time, location);
      destinationsFiltered.addAll(response);
      destinations = destinationsFiltered;
      isGettingDestinations = false;
      update();
    } catch (e) {
      isGettingDestinations = false;
      update();
      rethrow;
    }
  }

  setSelectedDestination(JourneyDestination destination) {
    selectedDestination = destination;
    update();
  }

  selectedDestinationChange(String? value) {
    if (value != null) {
      selectedDestinationOption = value;
      final destinationId = value.split('-')[0];
      final selectedDest = destinations.firstWhere(
        (dest) => dest.id == destinationId,
        orElse: () => destinations.first,
      );
      update();
    }
  }

  selectedTimeChange(String? value) {
    selectedTimeOption = value!;
    update();
  }

  showAllDestinations() async {
    isAllDestinationsShown = true;
    update();
    await getDestinations();
  }

  String formatTimeString(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }
}
