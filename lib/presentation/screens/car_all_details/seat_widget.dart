import 'package:car_ticket/controller/home/selected_destination.dart';
import 'package:car_ticket/domain/models/seat.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SeatSelection extends StatelessWidget {
  final String? seatNumber;
  final bool isReserved;
  final bool isBooked;
  final String? title;
  final bool isTitle;
  final Seat? seat;

  const SeatSelection(
      {required this.isReserved,
      required this.isBooked,
      required this.seat,
      this.seatNumber,
      this.isTitle = false,
      this.title,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SelectedDestinationController(),
        builder: (SelectedDestinationController carController) {
          return GestureDetector(
            onTap: () {
              carController.toogleCarSeatAndChangeIsReserved(seat!);
            },
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isReserved
                        ? Theme.of(context).primaryColor
                        : isBooked
                            ? const Color.fromARGB(255, 184, 206, 182)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                isTitle ? Text(title!) : Container(),
              ],
            ),
          );
        });
  }
}
