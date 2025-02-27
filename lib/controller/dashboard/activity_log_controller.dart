import 'package:car_ticket/domain/models/activity/activity_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ActivityLogController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  List<ActivityLog> activityLogs = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchActivityLogs();
  }

  Future<void> fetchActivityLogs() async {
    isLoading = true;
    update();

    try {
      final snapshot = await _firestore
          .collection('activity_logs')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      activityLogs = snapshot.docs
          .map((doc) => ActivityLog.fromDocument(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching activity logs: $e');
      // Handle error accordingly
    } finally {
      isLoading = false;
      update();
    }
  }

  // Add method to log a new activity
  Future<void> logActivity({
    required String title,
    required String description,
    required String type,
    String? userId,
    String? objectId,
  }) async {
    try {
      final newActivity = ActivityLog(
        id: '', // Will be assigned by Firestore
        title: title,
        description: description,
        type: type,
        timestamp: DateTime.now(),
        userId: userId,
        objectId: objectId,
      );

      final docRef = await _firestore.collection('activity_logs').add(
            newActivity.toDocument(),
          );

      // Update the id with Firestore document id
      await docRef.update({'id': docRef.id});

      // Refresh the activity logs
      fetchActivityLogs();
    } catch (e) {
      print('Error logging activity: $e');
      // Handle error accordingly
    }
  }

  // Refresh activity logs
  Future<void> refreshActivityLogs() async {
    await fetchActivityLogs();
  }
}
