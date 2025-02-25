import 'package:car_ticket/domain/models/ticket/ticket.dart';
import 'package:car_ticket/domain/repositories/payment_repository/payment_repository_imp.dart';
import 'package:car_ticket/domain/repositories/shared/shared_preference_repository.dart';
import 'package:get/get.dart';

class MyTicketController extends GetxController {
  final PaymentRepositoryImpl paymentRepository =
      Get.put(PaymentRepositoryImpl());
  TicketAppSharedPreferenceRepository sharedPreferenceRepository =
      TicketAppSharedPreferenceRepository();
  bool isGettingTickets = false;
  List<ExcelTicket> ticketsList = [];

  @override
  void onInit() {
    getTickets();
    super.onInit();
  }

  getTickets() async {
    try {
      isGettingTickets = true;
      update();
      List<ExcelTicket> tickets = [];
      final user = await sharedPreferenceRepository.getUser();
      tickets = await paymentRepository.getMyTickets(userId: user.id);
      ticketsList = tickets;

      isGettingTickets = false;
      update();
    } catch (e) {
      isGettingTickets = false;
      update();
      rethrow;
    }
  }
}
