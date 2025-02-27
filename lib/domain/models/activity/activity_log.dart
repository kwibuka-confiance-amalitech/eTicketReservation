import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLog {
  final String id;
  final String title;
  final String description;
  final String type;
  final DateTime timestamp;
  final String? userId;
  final String? objectId;

  ActivityLog({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.userId,
    this.objectId,
  });

  factory ActivityLog.fromDocument(Map<String, dynamic> doc) {
    return ActivityLog(
      id: doc['id'] ?? '',
      title: doc['title'] ?? '',
      description: doc['description'] ?? '',
      type: doc['type'] ?? '',
      timestamp: (doc['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: doc['userId'],
      objectId: doc['objectId'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'timestamp': timestamp,
      'userId': userId,
      'objectId': objectId,
    };
  }
}
