import 'package:car_ticket/domain/models/driver/driver.dart';
import 'package:car_ticket/domain/repositories/user/driver_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverRepositoryImp extends DriverRepository {
  final _userCollection = FirebaseFirestore.instance.collection('drivers');
  @override
  Future<void> createDriver(CarDriver driver) async {
    try {
      await _userCollection.doc(driver.id).set(driver.toDocument());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteDriver(CarDriver driver) async {
    try {
      return _userCollection.doc(driver.id).delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CarDriver> getDriver(String id) async {
    try {
      final doc = await _userCollection.doc(id).get();
      return CarDriver.fromDocument(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CarDriver>> getDrivers() async {
    try {
      final snapshot = await _userCollection.get();
      return snapshot.docs
          .map((doc) => CarDriver.fromDocument(doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateDriver(CarDriver driver) async {
    try {
      return _userCollection.doc(driver.id).update(driver.toDocument());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> assignDriverToCar(CarDriver driver) async {
    try {
      return _userCollection.doc(driver.id).update(driver.toDocument());
    } catch (e) {
      rethrow;
    }
  }
}
