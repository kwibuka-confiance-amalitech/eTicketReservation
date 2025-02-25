import 'package:car_ticket/domain/models/destination/journey_destination.dart';

abstract class DestinationRepository {
  Future<List<JourneyDestination>> getDestinations();
  Future<JourneyDestination> getDestinationById(String id);
  Future<JourneyDestination> createDestination(JourneyDestination destination);
  Future<JourneyDestination> updateDestination(JourneyDestination destination);
  Future<JourneyDestination> deleteDestination(String id);
  Future<List<JourneyDestination>> searchDestinations(
      String time, String location);
  Future<void> assignCarToDestination(
      {required String carId, required String destinationId});
  Future<void> unAssignCarToDestination(String destinationId);
}
