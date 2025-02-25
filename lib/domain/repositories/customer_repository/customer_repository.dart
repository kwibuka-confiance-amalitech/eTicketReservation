import 'package:car_ticket/domain/models/user/user.dart';

abstract class CustomerRepository {
  Future<void> deleteCustomer({required String email});
  Future<void> getCustomer({required String email});
  Future<List<MyUser>> getCustomers();
}
