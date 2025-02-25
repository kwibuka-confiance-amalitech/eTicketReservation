import 'package:car_ticket/controller/home/qr_code_controller.dart';
import 'package:car_ticket/domain/models/ticket/ticket.dart';
import 'package:car_ticket/domain/usecases/helpers/seats_length.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TicketCard extends StatelessWidget {
  final ExcelTicket ticket;
  const TicketCard({required this.ticket, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (QRcodeController qrController) {
      return GestureDetector(
        onTap: () => qrController.setSelectedTicket(ticket),
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(
              minWidth: 150, maxWidth: 180, minHeight: 180),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  ticket.isUsed || ticket.isExpired ? Colors.red : Colors.grey,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              const Text("Kigali to Nyamata",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    ticket.isExpired || ticket.isUsed
                        ? Icons.warning
                        : Icons.check_circle,
                    color: ticket.isExpired || ticket.isUsed
                        ? Colors.red
                        : Colors.green,
                    size: 14,
                  )),
              Positioned(
                top: 20,
                child: Text(
                    "${ticket.carDestinationFromTime} - ${ticket.carDestinationToTime}",
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              Positioned(
                bottom: 0,
                child: Text((dateChanged(ticket.createdAt)),
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              Positioned(
                top: 40,
                child: SingleChildScrollView(
                  child: Row(
                    children: seatsLength(ticket.seatNumbers)
                        .map((e) => Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: ticket.isExpired || ticket.isUsed
                                            ? Colors.red
                                            : Colors.green,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: SvgPicture.asset(
                                      "assets/images/seat 2.svg",
                                      width: 20,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Seat $e",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black38,
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              Positioned(
                  bottom: 20,
                  child: Text(
                    "${ticket.price} RWF",
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      );
    });
  }
}
