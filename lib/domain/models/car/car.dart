import 'package:equatable/equatable.dart';

class ExcelCar extends Equatable {
  final String id;
  final String name;
  final String plateNumber;
  final int seatNumbers;
  final String color;
  final String model;
  final String year;
  final String driverId;
  final bool isAssigned;

  const ExcelCar({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.color,
    required this.model,
    required this.year,
    required this.driverId,
    required this.seatNumbers,
    required this.isAssigned,
  });

  addSeats(Function f) {
    f();
  }

  static ExcelCar empty = const ExcelCar(
    id: '',
    name: '',
    plateNumber: '',
    color: '',
    model: '',
    year: '',
    driverId: '',
    seatNumbers: 0,
    isAssigned: false,
  );

  ExcelCar copyWith({
    String? id,
    String? name,
    String? plateNumber,
    String? color,
    String? model,
    String? year,
    String? driverId,
    int? seatNumbers,
    bool? isAssigned,
  }) {
    return ExcelCar(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      color: color ?? this.color,
      model: model ?? this.model,
      year: year ?? this.year,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      driverId: driverId ?? this.driverId,
      isAssigned: isAssigned ?? this.isAssigned,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'name': name,
      'plateNumber': plateNumber,
      'color': color,
      'model': model,
      'year': year,
      'driverId': driverId,
      'isAssigned': isAssigned,
      'seatNumbers': seatNumbers,
    };
  }

  static ExcelCar fromDocument(Map<String, dynamic> document) {
    return ExcelCar(
      id: document['id'],
      name: document['name'],
      plateNumber: document['plateNumber'],
      color: document['color'],
      model: document['model'],
      year: document['year'],
      seatNumbers: document['seatNumbers'],
      driverId: document['driverId'],
      isAssigned: document['isAssigned'],
    );
  }

  @override
  List<Object?> get props =>
      [id, name, plateNumber, color, model, year, driverId, isAssigned];
}
