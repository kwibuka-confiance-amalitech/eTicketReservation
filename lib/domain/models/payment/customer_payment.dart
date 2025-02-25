import 'package:car_ticket/domain/models/seat.dart';

class UserPayment {
  final String id;
  final String userId;
  final String paymentIntentId;
  final String destinationId;
  final String paymentStatus;
  final String paymentAmount;
  final String paymentCurrency;
  final String paymentDescription;
  final String paymentDate;
  final String paymentTime;
  final List<Seat> seats;
  final String carId;

  UserPayment({
    required this.id,
    required this.userId,
    required this.paymentIntentId,
    required this.paymentStatus,
    required this.paymentAmount,
    required this.destinationId,
    required this.paymentCurrency,
    required this.paymentDescription,
    required this.paymentDate,
    required this.paymentTime,
    required this.seats,
    required this.carId,
  });

  UserPayment.empty()
      : id = '',
        userId = '',
        paymentIntentId = '',
        paymentStatus = '',
        paymentAmount = '',
        paymentCurrency = '',
        destinationId = '',
        paymentDescription = '',
        paymentDate = '',
        paymentTime = '',
        seats = [],
        carId = '';

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'userId': userId,
      'paymentIntentId': paymentIntentId,
      'paymentStatus': paymentStatus,
      'paymentAmount': paymentAmount,
      'destinationId': destinationId,
      'paymentCurrency': paymentCurrency,
      'paymentDescription': paymentDescription,
      'paymentDate': paymentDate,
      'paymentTime': paymentTime,
      'seats': seats.map((e) => e.toDocument()).toList(),
      'carId': carId,
    };
  }

  static UserPayment fromDocument(Map<String, dynamic> doc) {
    return UserPayment(
      id: doc['id'],
      userId: doc['userId'],
      paymentIntentId: doc['paymentIntentId'],
      paymentStatus: doc['paymentStatus'],
      paymentAmount: doc['paymentAmount'],
      paymentCurrency: doc['paymentCurrency'],
      destinationId: doc['destinationId'],
      paymentDescription: doc['paymentDescription'],
      paymentDate: doc['paymentDate'],
      paymentTime: doc['paymentTime'],
      seats: (doc['seats'] as List).map((e) => Seat.fromDocument(e)).toList(),
      carId: doc['carId'],
    );
  }
}
