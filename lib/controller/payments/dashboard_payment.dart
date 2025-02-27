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

  int get todayRevenue {
    return _calculateTodayRevenue(userPayments);
  }

  int get weekRevenue {
    return _calculateWeekRevenue(userPayments);
  }

  int _calculateTodayRevenue(List<UserPayment> payments) {
    if (payments.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayPayments = payments.where((payment) {
      DateTime paymentDate;
      try {
        paymentDate = DateTime.parse(payment.paymentDate);
      } catch (e) {
        return false;
      }

      final paymentDay =
          DateTime(paymentDate.year, paymentDate.month, paymentDate.day);
      return paymentDay.isAtSameMomentAs(today);
    });

    int totalRevenue = 0;
    for (var payment in todayPayments) {
      try {
        totalRevenue += int.parse(payment.paymentAmount);
      } catch (e) {
        continue;
      }
    }

    return totalRevenue;
  }

  int _calculateWeekRevenue(List<UserPayment> payments) {
    if (payments.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final daysToSubtract = now.weekday - 1;
    final startOfWeek = today.subtract(Duration(days: daysToSubtract));

    final weekPayments = payments.where((payment) {
      DateTime paymentDate;
      try {
        paymentDate = DateTime.parse(payment.paymentDate);
      } catch (e) {
        return false;
      }

      final paymentDay =
          DateTime(paymentDate.year, paymentDate.month, paymentDate.day);
      return paymentDay.isAtSameMomentAs(today) ||
          (paymentDay.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              paymentDay.isBefore(today.add(const Duration(days: 1))));
    });

    int totalRevenue = 0;
    for (var payment in weekPayments) {
      try {
        totalRevenue += int.parse(payment.paymentAmount);
      } catch (e) {
        continue;
      }
    }

    return totalRevenue;
  }
}
