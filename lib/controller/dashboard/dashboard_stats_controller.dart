import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashboardStatsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int ticketCount = 0;
  int userCount = 0;
  int availableCars = 0;
  int totalCars = 0;
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    isLoading = true;
    update();

    try {
      // Get ticket count
      final ticketSnapshot = await _firestore.collection('tickets').get();
      ticketCount = ticketSnapshot.docs.length;

      // Get user count
      final userSnapshot = await _firestore.collection('users').get();
      userCount = userSnapshot.docs.length;

      // Get cars statistics
      await _fetchCarStats();

      isLoading = false;
      update();
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      isLoading = false;
      update();
    }
  }

  Future<void> _fetchCarStats() async {
    // Try to use the car controller if it exists
    if (Get.isRegistered<CarController>()) {
      final carController = Get.find<CarController>();
      if (carController.cars.isNotEmpty) {
        // Cars are already loaded in the controller
        totalCars = carController.cars.length;
        availableCars =
            carController.cars.where((car) => !car.isAssigned).length;
        return;
      }
    }

    // Fallback: Fetch cars directly from Firestore
    try {
      final carSnapshot = await _firestore.collection('cars').get();
      totalCars = carSnapshot.docs.length;
      availableCars = carSnapshot.docs
          .where((doc) =>
              doc.data().containsKey('isAssigned') &&
              doc.data()['isAssigned'] == false)
          .length;
    } catch (e) {
      print('Error fetching car stats: $e');
      totalCars = 0;
      availableCars = 0;
    }
  }

  // Method to manually refresh stats (can be called from UI)
  void refreshStats() {
    fetchStats();
  }
}
