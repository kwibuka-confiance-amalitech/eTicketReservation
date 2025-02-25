import 'package:car_ticket/controller/home/my_tickets.dart';
import 'package:car_ticket/controller/home/qr_code_controller.dart';
import 'package:car_ticket/presentation/widgets/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

class DialogBox {
  static void show(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static showTickets(BuildContext context, String resultCode,
      dynamic qrCodecontroller) {
    showDialog(
      context: context,
      builder: (context) {
        final QRcodeController qrController = Get.find();
        return GetBuilder(
            init: MyTicketController(),
            builder: (myTicketController) {
              return AlertDialog(
                title: const Text('My Tickets'),
                content: myTicketController.isGettingTickets ||
                        qrController.completingCheckingTicket
                    ? Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    : Wrap(
                        children: myTicketController.ticketsList
                            .map((ticket) => TicketCard(ticket: ticket))
                            .toList(),
                      ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      print(resultCode.length);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            });
      },
    ).then((value) => qrCodecontroller.resumeCamera());
  }
}
