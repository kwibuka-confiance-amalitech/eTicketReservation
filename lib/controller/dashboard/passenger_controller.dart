import 'package:car_ticket/domain/models/passenger/passenger_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PassengerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<PassengerDetails> passengers = [];
  bool isLoading = false;
  String? selectedDate;
  String? selectedDestination;

  @override
  void onInit() {
    super.onInit();
    getPassengers();
  }

  Future<void> getPassengers() async {
    try {
      isLoading = true;
      update();

      final ticketsSnapshot = await _firestore
          .collection('tickets')
          .where('isExpired', isEqualTo: false)
          .get();

      final List<PassengerDetails> loadedPassengers = [];

      for (var doc in ticketsSnapshot.docs) {
        // Get user details
        final userData = await _firestore
            .collection('users')
            .doc(doc.data()['userId'])
            .get();

        // Get destination details
        final destinationData = await _firestore
            .collection('destinations')
            .doc(doc.data()['destinationId'])
            .get();

        loadedPassengers.add(
          PassengerDetails(
            id: doc.id,
            name: "${userData.data()?['name'] ?? 'Unknown User'}",
            ticketId: doc.id,
            carId: doc.data()['carId'] ?? '',
            destinationId: doc.data()['destinationId'] ?? '',
            pickupLocation: doc.data()['pickupLocation'] ?? 'Not specified',
            selectedSeats: doc.data()['seatNumbers'].toString().split(','),
            travelDate: doc.data()['createdAt'].toDate(),
          ),
        );
      }

      passengers = loadedPassengers;
      isLoading = false;
      update();
    } catch (e) {
      print('Error loading passengers: $e');
      isLoading = false;
      update();
    }
  }

  void filterByDate(String date) {
    selectedDate = date;
    update();
  }

  void filterByDestination(String destinationId) {
    selectedDestination = destinationId;
    update();
  }
}
