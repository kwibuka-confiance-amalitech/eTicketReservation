import 'package:car_ticket/domain/models/user/user.dart';
import 'package:car_ticket/domain/repositories/customer_repository/customer_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerRepositoryImp implements CustomerRepository {
  final _customersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> deleteCustomer({required String email}) {
    // TODO: implement deleteCustomer
    throw UnimplementedError();
  }

  @override
  Future<void> getCustomer({required String email}) {
    // TODO: implement getCustomer
    throw UnimplementedError();
  }

  @override
  Future<List<MyUser>> getCustomers() async {
    try {
      final response = await _customersCollection.get();
      return response.docs.map((e) => MyUser.fromDocument(e.data())).toList();
    } catch (e) {
      rethrow;
    }
  }
}
