import 'package:car_ticket/domain/models/seat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../domain/models/car/car.dart';
import '../../domain/models/destination/journey_destination.dart';
import '../../domain/models/passenger/passenger_details.dart';

class CarSeatsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  ExcelCar? car;
  JourneyDestination? destination;
  List<Seat> seats = [];
  Map<int, PassengerDetails> seatPassengers = {};

  @override
  void onInit() {
    super.onInit();
    final String carId = Get.arguments['carId'];
    final String destinationId = Get.arguments['destinationId'];
    loadCarSeatsData(carId, destinationId);
  }

  Future<void> loadCarSeatsData(String carId, String destinationId) async {
    try {
      isLoading = true;
      update();

      // Load car details
      final carDoc = await _firestore.collection('cars').doc(carId).get();
      car = ExcelCar.fromDocument(carDoc.data()!);

      // Load destination details
      final destDoc =
          await _firestore.collection('destinations').doc(destinationId).get();
      destination = JourneyDestination.fromDocument(destDoc.data()!);

      // Load seats and tickets
      final ticketsQuery = await _firestore
          .collection('tickets')
          .where('carId', isEqualTo: carId)
          .where('destinationId', isEqualTo: destinationId)
          .where('isExpired', isEqualTo: false)
          .where('isCancelled', isEqualTo: false)
          .get();

      // Create seats list
      seats = List.generate(
        car?.seatNumbers ?? 0,
        (index) => Seat(
            id: index + 1,
            seatNumber: (index + 1).toString(),
            isBooked: false,
            isReserved: false),
      );

      // Process tickets and add passenger details
      for (var doc in ticketsQuery.docs) {
        final userData = await _firestore
            .collection('users')
            .doc(doc.data()['userId'])
            .get();

        final seatNumbers = doc.data()['seatNumbers'].toString().split(',');
        final passenger = PassengerDetails(
          id: doc.id,
          name: userData.data()?['name'] ?? 'Unknown',
          ticketId: doc.id,
          carId: carId,
          destinationId: destinationId,
          pickupLocation: doc.data()['pickupLocation'] ?? 'Not specified',
          selectedSeats: seatNumbers,
          travelDate: doc.data()['createdAt'].toDate(),
        );

        // Map seats to passenger
        for (var seatNumber in seatNumbers) {
          final seatIndex = int.parse(seatNumber) - 1;
          if (seatIndex >= 0 && seatIndex < seats.length) {
            seats[seatIndex] = seats[seatIndex].copyWith(isBooked: true);
            seatPassengers[int.parse(seatNumber)] = passenger;
          }
        }
      }

      isLoading = false;
      update();
    } catch (e) {
      print('Error loading car seats data: $e');
      isLoading = false;
      update();
    }
  }
}
