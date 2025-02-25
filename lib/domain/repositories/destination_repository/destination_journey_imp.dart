import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/domain/repositories/destination_repository/destination_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JourneyDestinationImp implements DestinationRepository {
  final _destinationCollection =
      FirebaseFirestore.instance.collection('destinations');

  @override
  Future<JourneyDestination> createDestination(
      JourneyDestination destination) async {
    try {
      await _destinationCollection
          .doc(destination.id)
          .set(destination.toDocument());
      return destination;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<JourneyDestination> deleteDestination(String id) async {
    try {
      final response = await _destinationCollection.doc(id).get();
      final destination = JourneyDestination.fromDocument(response.data()!);
      await _destinationCollection.doc(id).delete();
      return destination;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<JourneyDestination> getDestinationById(String id) async {
    try {
      final response = await _destinationCollection.doc(id).get();
      return JourneyDestination.fromDocument(response.data()!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<JourneyDestination>> getDestinations() async {
    try {
      final response = await _destinationCollection.get();
      return response.docs
          .map((e) => JourneyDestination.fromDocument(e.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<JourneyDestination>> searchDestinations(
      String from, String description) async {
    try {
      // search in all destinations where from and description are equal to the given values
      final response = await _destinationCollection
          .where('from', isEqualTo: from)
          .where('description', isEqualTo: description)
          .get();
      return response.docs
          .map((e) => JourneyDestination.fromDocument(e.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<JourneyDestination> updateDestination(
      JourneyDestination destination) async {
    try {
      await _destinationCollection
          .doc(destination.id)
          .update(destination.toDocument());
      return destination;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> assignCarToDestination(
      {required String carId, required String destinationId}) async {
    try {
      await _destinationCollection
          .doc(destinationId)
          .update({'carId': carId, 'isAssigned': true});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unAssignCarToDestination(String destinationId) async {
    try {
      await _destinationCollection
          .doc(destinationId)
          .update({'carId': '', 'isAssigned': false});
    } catch (e) {
      rethrow;
    }
  }
}
