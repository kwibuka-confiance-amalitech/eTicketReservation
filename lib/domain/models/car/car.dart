import 'package:equatable/equatable.dart';

class ExcelCar extends Equatable {
  final String id;
  final String name;
  final String plateNumber;
  final int seatNumbers;
  final String color;
  final String model;
  final String type; // Added: vehicle type (sedan, bus, etc.)
  final String year;
  final String driverId;
  final String driverName; // Added: name of assigned driver
  final bool isAssigned;
  final double mileage; // Added: current mileage
  final DateTime lastMaintenance; // Added: date of last maintenance
  final DateTime nextMaintenance; // Added: date of next scheduled maintenance
  final int bookedSeats;
  final int remainingSeats;

  ExcelCar({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.seatNumbers,
    required this.color,
    required this.model,
    required this.type,
    required this.year,
    required this.driverId,
    this.driverName = '',
    required this.isAssigned,
    this.mileage = 0.0,
    DateTime? lastMaintenance,
    DateTime? nextMaintenance,
    this.bookedSeats = 0, // Default to 0
    this.remainingSeats = 0, // Default to 0
  })  :
        // Initialize DateTime fields with default values if null
        lastMaintenance =
            lastMaintenance ?? DateTime.now().subtract(Duration(days: 90)),
        nextMaintenance =
            nextMaintenance ?? DateTime.now().add(Duration(days: 90));

  addSeats(Function f) {
    f();
  }

  static ExcelCar empty = ExcelCar(
    id: '',
    name: '',
    plateNumber: '',
    seatNumbers: 0,
    color: '',
    model: '',
    type: '',
    year: '',
    driverId: '',
    isAssigned: false,
  );

  ExcelCar copyWith({
    String? id,
    String? name,
    String? plateNumber,
    int? seatNumbers,
    String? color,
    String? model,
    String? type,
    String? year,
    String? driverId,
    String? driverName,
    bool? isAssigned,
    double? mileage,
    DateTime? lastMaintenance,
    DateTime? nextMaintenance,
    int? bookedSeats,
    int? remainingSeats,
  }) {
    return ExcelCar(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      color: color ?? this.color,
      model: model ?? this.model,
      type: type ?? this.type,
      year: year ?? this.year,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      isAssigned: isAssigned ?? this.isAssigned,
      mileage: mileage ?? this.mileage,
      lastMaintenance: lastMaintenance ?? this.lastMaintenance,
      nextMaintenance: nextMaintenance ?? this.nextMaintenance,
      bookedSeats: bookedSeats ?? this.bookedSeats,
      remainingSeats: remainingSeats ?? this.remainingSeats,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'name': name,
      'plateNumber': plateNumber,
      'seatNumbers': seatNumbers,
      'color': color,
      'model': model,
      'type': type,
      'year': year,
      'driverId': driverId,
      'driverName': driverName,
      'isAssigned': isAssigned,
      'mileage': mileage,
      'lastMaintenance': lastMaintenance.millisecondsSinceEpoch,
      'nextMaintenance': nextMaintenance.millisecondsSinceEpoch,
      'bookedSeats': bookedSeats,
      'remainingSeats': remainingSeats,
    };
  }

  static ExcelCar fromDocument(Map<String, dynamic> document) {
    return ExcelCar(
      id: document['id'] ?? '',
      name: document['name'] ?? '',
      plateNumber: document['plateNumber'] ?? '',
      seatNumbers: document['seatNumbers'] ?? 0,
      color: document['color'] ?? '',
      model: document['model'] ?? '',
      type: document['type'] ?? document['model'] ?? '',
      year: document['year'] ?? '',
      driverId: document['driverId'] ?? '',
      driverName: document['driverName'] ?? '',
      isAssigned: document['isAssigned'] ?? false,
      mileage: (document['mileage'] ?? 0.0).toDouble(),
      lastMaintenance: document['lastMaintenance'] != null
          ? DateTime.fromMillisecondsSinceEpoch(document['lastMaintenance'])
          : DateTime.now().subtract(const Duration(days: 90)),
      nextMaintenance: document['nextMaintenance'] != null
          ? DateTime.fromMillisecondsSinceEpoch(document['nextMaintenance'])
          : DateTime.now().add(const Duration(days: 90)),
      bookedSeats: document['bookedSeats'] ?? 0,
      remainingSeats: document['remainingSeats'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        plateNumber,
        seatNumbers,
        color,
        model,
        type,
        year,
        driverId,
        driverName,
        isAssigned,
        mileage,
        lastMaintenance,
        nextMaintenance,
        bookedSeats,
        remainingSeats,
      ];
}
