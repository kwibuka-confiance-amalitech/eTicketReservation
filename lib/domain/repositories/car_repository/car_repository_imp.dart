import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/domain/models/carSeats.dart';
import 'package:car_ticket/domain/models/seat.dart';
import 'package:car_ticket/domain/repositories/car_repository/car_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarRepositoryImp implements CarRepository {
  final _carsCollection = FirebaseFirestore.instance.collection('cars');
  final _carSeatsCollection = FirebaseFirestore.instance.collection('carSeats');

  seatPosition(seatsLength) {
    return List.generate(
        seatsLength,
        (index) => Seat(
            id: index + 1,
            seatNumber: (index + 1).toString(),
            isReserved: false,
            isBooked: false));
  }

  @override
  Future<void> createCar(ExcelCar car) async {
    //  I want the index of last rightSeat to start from the index of the last leftSeat
    try {
      List<Seat> seatsList = seatPosition(car.seatNumbers);
      await _carsCollection.doc(car.id).set(car.toDocument());
      await createCarSeats(
        carId: car.id,
        seatsList: seatsList,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCar(ExcelCar car) async {
    try {
      await _carsCollection.doc(car.id).delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ExcelCar> getCar(String id) async {
    try {
      final response = await _carsCollection.doc(id).get();
      return ExcelCar.fromDocument(response.data()!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ExcelCar>> getCars() async {
    try {
      final response = await _carsCollection.get();
      return response.docs.map((e) => ExcelCar.fromDocument(e.data())).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateCar(ExcelCar car) async {
    try {
      await _carsCollection.doc(car.id).update(car.toDocument());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> assignDriverToCar(String driverId, String carId) async {
    try {
      await _carsCollection
          .doc(carId)
          .update({'driverId': driverId, 'isAssigned': true});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unAssignDriverToCar(String carId) async {
    try {
      await _carsCollection
          .doc(carId)
          .update({'driverId': '', 'isAssigned': false});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createCarSeats({
    required String carId,
    required List<Seat> seatsList,
  }) async {
    try {
      await _carSeatsCollection.doc(carId).set(CarSeats(
            id: carId,
            seatNumber: "24",
            carId: carId,
            seatsList: seatsList,
          ).toDocument());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CarSeats> getCarSeats(String id) async {
    try {
      final response = await _carSeatsCollection.doc(id).get();
      return CarSeats.fromDocument(response.data()!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateCarSeatsBooked(
      String carId, List<Seat> bookedSeats) async {
    try {
      final response = await _carSeatsCollection.doc(carId).get();
      final carSeats = CarSeats.fromDocument(response.data()!);
      final seatsList = carSeats.seatsList.map((e) {
        if (bookedSeats.any((element) => element.id == e.id)) {
          return e.copyWith(isBooked: true);
        }
        return e;
      }).toList();

      await _carSeatsCollection.doc(carId).update({
        'seatsList': seatsList.map((e) => e.toDocument()).toList(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
