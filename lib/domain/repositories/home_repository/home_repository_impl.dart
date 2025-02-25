import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/domain/repositories/home_repository/home_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeJourneyDestionationsRepositoryImpl
    extends HomeJourneyDestionationsRepository {
  final _userCollection = FirebaseFirestore.instance.collection('destinations');

  @override
  Future<JourneyDestination> getCarSeats(String id) async {
    try {
      final response = await _userCollection.doc(id).get();
      return JourneyDestination.fromDocument(response.data()!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<JourneyDestination>> getDestinations() async {
    try {
      final response = await _userCollection.get();
      return response.docs
          .map((e) => JourneyDestination.fromDocument(e.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
