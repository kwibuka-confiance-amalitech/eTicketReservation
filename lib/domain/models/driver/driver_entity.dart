import 'package:equatable/equatable.dart';

class CarDriverEntity extends Equatable {
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

  const CarDriverEntity({
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

  static CarDriverEntity empty = const CarDriverEntity(
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

  CarDriverEntity copyWith({
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
    return CarDriverEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      sexStatus: sexStatus ?? this.sexStatus,
      city: city ?? this.city,
      driverLicenseCategory:
          driverLicenseCategory ?? this.driverLicenseCategory,
      isAssigned: isAssigned ?? this.isAssigned,
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
        driverLicenseCategory,
        sexStatus,
        isAssigned,
      ];
}
