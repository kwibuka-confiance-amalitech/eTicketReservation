import 'package:car_ticket/domain/models/user/user.dart';
import 'package:car_ticket/domain/repositories/customer_repository/customer_repository_impl.dart';
import 'package:get/get.dart';

class CustomersController extends GetxController {
  CustomerRepositoryImp customerRepository = Get.put(CustomerRepositoryImp());
  bool isGettingCustomers = false;
  List<MyUser> customers = [];

  @override
  void onInit() {
    getCustomers();
    super.onInit();
  }

  getCustomers() async {
    try {
      isGettingCustomers = true;
      update();
      final customersUpdated = await customerRepository.getCustomers();
      customers = customersUpdated;
      isGettingCustomers = false;
      update();
    } catch (e) {
      isGettingCustomers = false;
      update();
      rethrow;
    }
  }

// not implemented yet
  deleteCustomer(String email) async {
    try {
      await customerRepository.deleteCustomer(email: email);
      getCustomers();
    } catch (e) {
      rethrow;
    }
  }
}
