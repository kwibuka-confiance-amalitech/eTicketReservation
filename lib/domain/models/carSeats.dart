import 'package:car_ticket/domain/models/seat.dart';

class CarSeats {
  final String id;
  final String seatNumber;
  final String carId;
  final List<Seat> seatsList;

  const CarSeats({
    required this.id,
    required this.seatNumber,
    required this.carId,
    required this.seatsList,
  });

  static CarSeats empty = const CarSeats(
    id: '',
    seatNumber: '',
    carId: '',
    seatsList: [],
  );

  CarSeats copyWith({
    String? id,
    String? seatNumber,
    String? carId,
    List<Seat>? seatsList,
  }) {
    return CarSeats(
      id: id ?? this.id,
      seatNumber: seatNumber ?? this.seatNumber,
      carId: carId ?? this.carId,
      seatsList: seatsList ?? this.seatsList,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'seatNumber': seatNumber,
      'carId': carId,
      "seatsList": seatsList.map((e) => e.toDocument()).toList(),
    };
  }

  static CarSeats fromDocument(Map<String, dynamic> document) {
    return CarSeats(
      id: document['id'],
      seatNumber: document['seatNumber'],
      carId: document['carId'],
      seatsList:
          List<Map<String, dynamic>>.from(document['seatsList']).map((e) {
        return Seat.fromDocument(e);
      }).toList(),
    );
  }
}
