import 'package:car_ticket/domain/models/driver/driver.dart';

abstract class DriverRepository {
  Future<void> createDriver(CarDriver driver);
  Future<void> updateDriver(CarDriver driver);
  Future<void> deleteDriver(CarDriver driver);
  Future<void> assignDriverToCar(CarDriver driver);
  Future<CarDriver> getDriver(String id);
  Future<List<CarDriver>> getDrivers();
}
