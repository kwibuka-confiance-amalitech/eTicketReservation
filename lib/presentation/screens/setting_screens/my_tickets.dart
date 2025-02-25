import 'package:car_ticket/controller/home/my_tickets.dart';
import 'package:car_ticket/domain/usecases/helpers/seats_length.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class MyTicketScreen extends StatelessWidget {
  static const String routeName = '/my-tickets';
  const MyTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: MyTicketController(),
        builder: (myTicketController) {
          final tickets = myTicketController.ticketsList;
          return Scaffold(
            appBar: AppBar(
              title: const Text('My Tickets'),
            ),
            body: myTicketController.isGettingTickets
                ? Container(
                    alignment: Alignment.center,
                    height: 300,
                    child: const CircularProgressIndicator(),
                  )
                : tickets.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        child: const Center(
                          child: Text('No tickets found'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    // color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text("Kigali",
                                            style: TextStyle(fontSize: 20)),
                                        Image.asset(
                                          'assets/images/black_car.png',
                                          scale: 16,
                                        ),
                                        const Text("Nyamata",
                                            style: TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    child: Text(
                                        "${tickets[index].carDestinationFromTime} - ${tickets[index].carDestinationToTime}",
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                          "Seats: ${seatsLength(tickets[index].seatNumbers).length} ",
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          "Price: ${tickets[index].price}  RWF",
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Due Date: ${dateChanged(tickets[index].createdAt)} ",
                                          style: const TextStyle(
                                            fontSize: 10,
                                          )),
                                      Text(
                                          "Due Time: ${timeChanged(tickets[index].createdAt)} ",
                                          style: const TextStyle(fontSize: 10)),
                                    ],
                                  ),
                                ],
                              ));
                        },
                      ),
          );
        });
  }
}
