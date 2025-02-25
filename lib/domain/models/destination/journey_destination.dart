class JourneyDestination {
  final String id;
  final String description;
  final String imageUrl;
  final String price;
  final String duration;
  final String from;
  final String to;
  final String createdAt;
  final String updatedAt;
  final String carId;
  final bool isAssigned;
  final String? startDate; // Add this field

  JourneyDestination({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.duration,
    required this.from,
    required this.to,
    required this.createdAt,
    required this.updatedAt,
    required this.carId,
    required this.isAssigned,
    this.startDate, // Add this parameter
  });

  static JourneyDestination empty = JourneyDestination(
    id: '',
    description: '',
    imageUrl: '',
    price: '',
    duration: '',
    from: '',
    to: '',
    createdAt: '',
    updatedAt: '',
    carId: '',
    isAssigned: false,
  );

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'duration': duration,
      'from': from,
      'to': to,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'carId': carId,
      'isAssigned': isAssigned,
      'startDate': startDate,
    };
  }

  factory JourneyDestination.fromDocument(Map<String, dynamic> document) {
    return JourneyDestination(
      id: document['id'],
      description: document['description'],
      imageUrl: document['imageUrl'],
      price: document['price'],
      duration: document['duration'],
      from: document['from'],
      to: document['to'],
      createdAt: document['createdAt'],
      updatedAt: document['updatedAt'],
      carId: document['carId'],
      isAssigned: document['isAssigned'],
      startDate: document['startDate'] as String?,
    );
  }

  // Update copyWith method
  JourneyDestination copyWith({
    String? id,
    String? description,
    String? imageUrl,
    String? price,
    String? duration,
    String? from,
    String? to,
    String? createdAt,
    String? updatedAt,
    String? carId,
    bool? isAssigned,
    String? startDate,
  }) {
    return JourneyDestination(
      id: id ?? this.id,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      from: from ?? this.from,
      to: to ?? this.to,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      carId: carId ?? this.carId,
      isAssigned: isAssigned ?? this.isAssigned,
      startDate: startDate ?? this.startDate,
    );
  }
}
