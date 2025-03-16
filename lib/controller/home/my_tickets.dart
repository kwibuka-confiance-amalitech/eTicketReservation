import 'package:car_ticket/domain/models/ticket/ticket.dart';
import 'package:car_ticket/domain/repositories/payment_repository/payment_repository_imp.dart';
import 'package:car_ticket/domain/repositories/shared/shared_preference_repository.dart';
import 'package:get/get.dart';

class MyTicketController extends GetxController {
  final PaymentRepositoryImpl paymentRepository =
      Get.put(PaymentRepositoryImpl());
  final TicketAppSharedPreferenceRepository sharedPreferenceRepository =
      TicketAppSharedPreferenceRepository();
  bool isGettingTickets = false;
  List<ExcelTicket> ticketsList = [];

  @override
  void onInit() {
    getTickets();
    super.onInit();
  }

  Future<void> getTickets() async {
    try {
      isGettingTickets = true;
      update();

      final user = await sharedPreferenceRepository.getUser();
      if (user.id.isEmpty) {
        ticketsList = [];
        return;
      }

      final tickets = await paymentRepository.getMyTickets(userId: user.id);

      // Ensure no null tickets in the list
      ticketsList = tickets.where((ticket) => ticket != null).toList();

      // Sort tickets by date (newest first)
      ticketsList.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.now();
        final bDate = b.createdAt ?? DateTime.now();
        return bDate.compareTo(aDate);
      });
    } catch (e) {
      print('Error fetching tickets: $e');
      ticketsList = [];
    } finally {
      isGettingTickets = false;
      update();
    }
  }
}
