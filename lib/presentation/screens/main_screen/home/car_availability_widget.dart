import 'package:car_ticket/controller/home/destinations.dart';
import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/presentation/screens/car_all_details/car_available_more_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarAvailability extends StatelessWidget {
  final JourneyDestination destination;
  const CarAvailability({required this.destination, super.key});

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Not scheduled';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeJourneyDestinationController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: () {
          homeController.setSelectedDestination(destination);
          Navigator.pushNamed(context, CarAvailableDetails.routeName);
        },
        child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 100,
                      child: Image.network(destination.imageUrl,
                          fit: BoxFit.cover, height: 100),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(destination.description,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('${destination.price} RWF',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                            if (destination.startDate != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _formatDate(destination.startDate),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            Text(destination.from,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.arrow_circle_right_outlined,
                                  size: 16),
                            ),
                            Text(destination.to,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
