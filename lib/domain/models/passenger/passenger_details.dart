class PassengerDetails {
  final String id;
  final String name;
  final String ticketId;
  final String carId;
  final String destinationId;
  final String pickupLocation;
  final List<String> selectedSeats;
  final DateTime travelDate;
  final bool isCancelled;

  PassengerDetails({
    required this.id,
    required this.name,
    required this.ticketId,
    required this.carId,
    required this.destinationId,
    required this.pickupLocation,
    required this.selectedSeats,
    required this.travelDate,
    this.isCancelled = false,
  });

  factory PassengerDetails.fromDocument(Map<String, dynamic> doc) {
    return PassengerDetails(
      id: doc['id'] ?? '',
      name: doc['name'] ?? '',
      ticketId: doc['ticketId'] ?? '',
      carId: doc['carId'] ?? '',
      destinationId: doc['destinationId'] ?? '',
      pickupLocation: doc['pickupLocation'] ?? 'Not specified',
      selectedSeats: List<String>.from(doc['selectedSeats'] ?? []),
      travelDate: doc['travelDate']?.toDate() ?? DateTime.now(),
      isCancelled: doc['isCancelled'] ?? false,
    );
  }
}
