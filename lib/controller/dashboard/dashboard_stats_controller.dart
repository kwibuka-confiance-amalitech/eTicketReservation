import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashboardStatsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = true;
  int ticketCount = 0;
  int availableCars = 0;
  int userCount = 0;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardStats();
  }

  Future<void> fetchDashboardStats() async {
    isLoading = true;
    update();

    try {
      await Future.wait([
        fetchTicketCount(),
        fetchAvailableCars(),
        fetchUserCount(),
      ]);
    } catch (e) {
      print('Error fetching dashboard stats: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchTicketCount() async {
    try {
      // Get count of all payments related to tickets
      final paymentSnapshot = await _firestore.collection('payments').get();
      ticketCount = paymentSnapshot.docs.length;
    } catch (e) {
      print('Error fetching ticket count: $e');
    }
  }

  Future<void> fetchAvailableCars() async {
    try {
      // Get count of cars not assigned to routes
      final carSnapshot = await _firestore
          .collection('cars')
          .where('isAssigned', isEqualTo: false)
          .get();

      availableCars = carSnapshot.docs.length;
    } catch (e) {
      print('Error fetching available cars: $e');
    }
  }

  Future<void> fetchUserCount() async {
    try {
      // Get count of active users
      final userSnapshot = await _firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .get();

      userCount = userSnapshot.docs.length;
    } catch (e) {
      print('Error fetching user count: $e');
    }
  }

  Future<void> refreshStats() async {
    await fetchDashboardStats();
  }
}
