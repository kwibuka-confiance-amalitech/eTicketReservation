import 'package:car_ticket/domain/models/seat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExcelTicket {
  final String id;
  final String carId;
  final String destinationId;
  final String userId;
  final String seatNumbers;
  final List<Seat> seats;
  final String carDestinationFromTime;
  final String carDestinationToTime;
  final bool isExpired;
  final bool isUsed;
  final String price;
  final DateTime? createdAt;
  final bool isCancelled;
  final DateTime? cancelledAt;
  final String pickupLocation;

  ExcelTicket({
    required this.id,
    required this.carId,
    required this.destinationId,
    required this.userId,
    required this.seatNumbers,
    required this.seats,
    required this.carDestinationFromTime,
    required this.carDestinationToTime,
    required this.isExpired,
    required this.isUsed,
    required this.price,
    this.createdAt,
    this.isCancelled = false,
    this.cancelledAt,
    this.pickupLocation = '',
  });

  ExcelTicket copyWith({
    String? id,
    String? carId,
    String? destinationId,
    String? userId,
    String? seatNumbers,
    List<Seat>? seats,
    String? carDestinationFromTime,
    String? carDestinationToTime,
    bool? isExpired,
    bool? isUsed,
    String? price,
    DateTime? createdAt,
    bool? isCancelled,
    DateTime? cancelledAt,
    String? pickupLocation,
  }) {
    return ExcelTicket(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      destinationId: destinationId ?? this.destinationId,
      userId: userId ?? this.userId,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      seats: seats ?? this.seats,
      carDestinationFromTime:
          carDestinationFromTime ?? this.carDestinationFromTime,
      carDestinationToTime: carDestinationToTime ?? this.carDestinationToTime,
      isExpired: isExpired ?? this.isExpired,
      isUsed: isUsed ?? this.isUsed,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      isCancelled: isCancelled ?? this.isCancelled,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      pickupLocation: pickupLocation ?? this.pickupLocation,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'carId': carId,
      'destinationId': destinationId,
      'userId': userId,
      'seatNumbers': seatNumbers,
      'seats': seats.map((seat) => seat.toDocument()).toList(),
      'carDestinationFromTime': carDestinationFromTime,
      'carDestinationToTime': carDestinationToTime,
      'isExpired': isExpired,
      'isUsed': isUsed,
      'price': price,
      'createdAt': createdAt ?? DateTime.now(),
      'isCancelled': isCancelled,
      'cancelledAt': cancelledAt,
      'pickupLocation': pickupLocation,
    };
  }

  factory ExcelTicket.fromDocument(Map<String, dynamic> document) {
    return ExcelTicket(
      id: document['id'] ?? '',
      carId: document['carId'] ?? '',
      destinationId: document['destinationId'] ?? '',
      userId: document['userId'] ?? '',
      seatNumbers: document['seatNumbers'] ?? '',
      seats: (document['seats'] as List<dynamic>?)
              ?.map((seat) => Seat.fromDocument(seat))
              .toList() ??
          [],
      carDestinationFromTime: document['carDestinationFromTime'] ?? '',
      carDestinationToTime: document['carDestinationToTime'] ?? '',
      isExpired: document['isExpired'] ?? false,
      isUsed: document['isUsed'] ?? false,
      price: document['price'] ?? '0',
      createdAt: document['createdAt'] != null
          ? (document['createdAt'] as Timestamp).toDate()
          : null,
      isCancelled: document['isCancelled'] ?? false,
      cancelledAt: document['cancelledAt'] != null
          ? (document['cancelledAt'] as Timestamp).toDate()
          : null,
      pickupLocation: document['pickupLocation'] ?? '',
    );
  }

  static ExcelTicket empty = ExcelTicket(
    id: '',
    carId: '',
    destinationId: '',
    userId: '',
    seatNumbers: '',
    seats: [],
    carDestinationFromTime: '',
    carDestinationToTime: '',
    isExpired: false,
    isUsed: false,
    price: '',
    createdAt: DateTime.now(),
    isCancelled: false,
    cancelledAt: null,
    pickupLocation: '',
  );

  static List<ExcelTicket> testingTickets = [
    ExcelTicket(
      id: '1',
      carId: '1',
      destinationId: '1',
      userId: '1',
      seatNumbers: '',
      seats: [
        Seat(
          id: 1,
          seatNumber: '1',
          isBooked: false,
          isReserved: false,
        ),
        Seat(
          id: 2,
          seatNumber: '2',
          isBooked: false,
          isReserved: false,
        ),
        Seat(
          id: 3,
          seatNumber: '3',
          isBooked: false,
          isReserved: false,
        ),
      ],
      carDestinationFromTime: '10:00 AM',
      carDestinationToTime: '11:00 AM',
      isExpired: true,
      isUsed: false,
      price: '5000',
      createdAt: DateTime.now(),
    ),
    ExcelTicket(
      id: '2',
      carId: '2',
      destinationId: '2',
      userId: '2',
      seatNumbers: '4,5,6',
      seats: [
        Seat(
          id: 4,
          seatNumber: '4',
          isBooked: false,
          isReserved: false,
        ),
        Seat(
          id: 5,
          seatNumber: '5',
          isBooked: false,
          isReserved: false,
        ),
        Seat(
          id: 6,
          seatNumber: '6',
          isBooked: false,
          isReserved: false,
        ),
      ],
      carDestinationFromTime: '12:00 PM',
      carDestinationToTime: '1:00 PM',
      isExpired: false,
      isUsed: false,
      price: '5000',
      createdAt: DateTime.now(),
    ),
  ];
}
