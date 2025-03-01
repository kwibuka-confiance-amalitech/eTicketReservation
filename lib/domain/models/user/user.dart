import 'package:car_ticket/domain/entities/user/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime? createdAt;
  final int? bookingsCount;

  const MyUser({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.createdAt,
    this.bookingsCount,
  });

  static MyUser empty = const MyUser(id: '', email: '', name: '', photoUrl: '');

  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? createdAt,
    int? bookingsCount,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      bookingsCount: bookingsCount ?? this.bookingsCount,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(id: id, email: email, name: name);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        id: entity.id, email: entity.email, name: entity.name, photoUrl: null);
  }

  factory MyUser.fromDocument(Map<String, dynamic> data) {
    DateTime? createdAt;
    if (data['createdAt'] != null) {
      if (data['createdAt'] is Timestamp) {
        createdAt = (data['createdAt'] as Timestamp).toDate();
      } else if (data['createdAt'] is String) {
        try {
          createdAt = DateTime.parse(data['createdAt']);
        } catch (_) {
          createdAt = null;
        }
      }
    }

    return MyUser(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: createdAt,
      bookingsCount:
          data['bookingsCount'] != null ? data['bookingsCount'] as int : null,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt':
          createdAt, // Firestore will automatically convert DateTime to Timestamp
      'bookingsCount': bookingsCount ?? 0, // Use 0 as default if null
    };
  }

  @override
  List<Object?> get props =>
      [id, email, name, photoUrl, createdAt, bookingsCount];
}
