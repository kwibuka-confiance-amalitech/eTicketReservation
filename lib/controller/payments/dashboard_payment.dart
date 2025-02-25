import 'package:car_ticket/domain/models/payment/customer_payment.dart';
import 'package:car_ticket/domain/repositories/payment_repository/payment_repository_imp.dart';
import 'package:get/get.dart';

class DashboardPaymentController extends GetxController {
  PaymentRepositoryImpl paymentRepository = Get.put(PaymentRepositoryImpl());

  bool isGettingUserPayments = false;
  List<UserPayment> userPayments = [];

  @override
  void onInit() {
    getUserPayments();
    super.onInit();
  }

  getUserPayments() async {
    isGettingUserPayments = true;
    update();
    List<UserPayment> allPayments = [];
    List<UserPayment> response = await paymentRepository.getAllPayments();
    allPayments = response;
    userPayments = allPayments;

    isGettingUserPayments = false;
    update();
  }

  get totalAmount {
    double total = 0;
    total = userPayments.fold(0, (previousValue, element) {
      return previousValue + double.parse(element.paymentAmount);
    });
    return total;
  }
}
