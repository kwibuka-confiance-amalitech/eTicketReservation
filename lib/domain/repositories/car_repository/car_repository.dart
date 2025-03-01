import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/domain/models/carSeats.dart';
import 'package:car_ticket/domain/models/seat.dart';

abstract class CarRepository {
  Future<void> createCar(ExcelCar car);
  Future<void> updateCar(ExcelCar car);
  Future<void> deleteCar(ExcelCar car);
  Future<ExcelCar> getCar(String id);
  Future<void> assignDriverToCar(String driverId, String carId,
      {required String driverName});
  Future<void> unAssignDriverToCar(String carId);
  Future<List<ExcelCar>> getCars();
  Future<void> createCarSeats({
    required String carId,
    required List<Seat> seatsList,
  });
  Future<CarSeats> getCarSeats(String id);
  Future<void> updateCarSeatsBooked(String carId, List<Seat> bookedSeats);
}
