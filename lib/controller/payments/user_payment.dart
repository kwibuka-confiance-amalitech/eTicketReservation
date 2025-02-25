import 'package:car_ticket/domain/models/payment/customer_payment.dart';
import 'package:car_ticket/domain/repositories/payment_repository/payment_repository_imp.dart';
import 'package:car_ticket/domain/repositories/shared/shared_preference_repository.dart';
import 'package:get/get.dart';

class UserPaymentController extends GetxController {
  PaymentRepositoryImpl paymentRepository = Get.put(PaymentRepositoryImpl());
  TicketAppSharedPreferenceRepository sharedPreferenceRepository =
      TicketAppSharedPreferenceRepository();

  List<UserPayment> userPayments = [];
  bool isGettingUserPayments = false;

  @override
  void onInit() {
    getCustomerPayments();
    super.onInit();
  }

  Future<void> getCustomerPayments() async {
    try {
      isGettingUserPayments = true;
      update();
      final user = await sharedPreferenceRepository.getUser();
      List<UserPayment> userPaymentsTransformed = [];

      List<UserPayment> response =
          await paymentRepository.getCustomerPayments(user.id);
      userPaymentsTransformed = response;
      userPayments = userPaymentsTransformed;
      isGettingUserPayments = false;
      update();
    } catch (e) {
      isGettingUserPayments = false;
      update();
      rethrow;
    }
  }
}
