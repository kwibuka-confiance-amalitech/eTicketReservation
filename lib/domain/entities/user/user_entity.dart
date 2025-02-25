import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
  });

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      "photoUrl": photoUrl,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      id: doc['id'],
      email: doc['email'],
      name: doc['name'],
      photoUrl: doc['photoUrl'],
    );
  }

  MyUserEntity fromUserEntity(MyUserEntity entity) {
    return MyUserEntity(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photoUrl: entity.photoUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        photoUrl,
      ];
}
