import 'package:equatable/equatable.dart';

class Seat extends Equatable {
  final int id;
  final String seatNumber;
  bool isReserved;
  bool isBooked;

  Seat({
    required this.id,
    required this.seatNumber,
    required this.isReserved,
    required this.isBooked,
  });

  Seat copyWith({
    int? id,
    String? seatNumber,
    bool? isReserved,
    bool? isBooked,
  }) {
    return Seat(
      id: id ?? this.id,
      seatNumber: seatNumber ?? this.seatNumber,
      isReserved: isReserved ?? this.isReserved,
      isBooked: isBooked ?? this.isBooked,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'seatNumber': seatNumber,
      'isReserved': isReserved,
      'isBooked': isBooked,
    };
  }

  factory Seat.fromDocument(Map<String, dynamic> document) {
    return Seat(
      id: document['id'],
      seatNumber: document['seatNumber'],
      isReserved: document['isReserved'],
      isBooked: document['isBooked'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, seatNumber, isReserved, isBooked];
}
