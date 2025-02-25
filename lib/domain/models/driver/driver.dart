import 'package:car_ticket/domain/models/driver/driver_entity.dart';
import 'package:equatable/equatable.dart';

class CarDriver extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String driverLicenseCategory;
  final String sexStatus;
  final bool isAssigned;

  const CarDriver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.driverLicenseCategory,
    required this.sexStatus,
    required this.isAssigned,
  });

  static CarDriver empty = const CarDriver(
    id: '',
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    address: '',
    city: '',
    driverLicenseCategory: '',
    sexStatus: '',
    isAssigned: false,
  );

  CarDriver copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? driverLicenseCategory,
    String? sexStatus,
    bool? isAssigned,
  }) {
    return CarDriver(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      driverLicenseCategory:
          driverLicenseCategory ?? this.driverLicenseCategory,
      sexStatus: sexStatus ?? this.sexStatus,
      isAssigned: isAssigned ?? this.isAssigned,
    );
  }

  CarDriverEntity toEntity() {
    return CarDriverEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      city: city,
      driverLicenseCategory: driverLicenseCategory,
      sexStatus: sexStatus,
      isAssigned: isAssigned,
    );
  }

  static CarDriver fromEntity(CarDriverEntity entity) {
    return CarDriver(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
      city: entity.city,
      driverLicenseCategory: entity.driverLicenseCategory,
      sexStatus: entity.sexStatus,
      isAssigned: entity.isAssigned,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'driverLicenseCategory': driverLicenseCategory,
      "sexStatus": sexStatus,
      "isAssigned": isAssigned,
    };
  }

  static CarDriver fromDocument(Map<String, dynamic> doc) {
    return CarDriver(
      id: doc['id'],
      firstName: doc['firstName'],
      lastName: doc['lastName'],
      email: doc['email'],
      phone: doc['phone'],
      address: doc['address'],
      city: doc['city'],
      driverLicenseCategory: doc['driverLicenseCategory'],
      sexStatus: doc['sexStatus'],
      isAssigned: doc['isAssigned'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        address,
        city,
        sexStatus,
        driverLicenseCategory
      ];
}
