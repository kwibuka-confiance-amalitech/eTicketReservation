import 'package:car_ticket/domain/models/destination/journey_destination.dart';

abstract class HomeJourneyDestionationsRepository {
  Future<List<JourneyDestination>> getDestinations();
  Future<void> getCarSeats(String id);
}
