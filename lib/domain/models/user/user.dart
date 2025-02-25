import 'package:car_ticket/domain/entities/user/user_entity.dart';
import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;

  const MyUser({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
  });

  static MyUser empty = const MyUser(id: '', email: '', name: '', photoUrl: '');

  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
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
    return MyUser(
      id: data['id'],
      email: data['email'],
      name: data['name'],
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  @override
  List<Object?> get props => [id, email, name, photoUrl];
}
