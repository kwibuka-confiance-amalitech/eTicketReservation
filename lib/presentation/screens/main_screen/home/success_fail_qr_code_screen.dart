import 'package:car_ticket/controller/home/qr_code_controller.dart';
import 'package:car_ticket/controller/navigation.dart';
import 'package:car_ticket/domain/models/ticket/ticket.dart';
import 'package:car_ticket/domain/usecases/helpers/seats_length.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class QrCodeResultScreen extends StatelessWidget {
  final bool isSuccessful;
  final ExcelTicket ticket;
  final String title;
  final String content;
  const QrCodeResultScreen(
      {required this.isSuccessful,
      required this.ticket,
      super.key,
      required this.title,
      required this.content});

  @override
  Widget build(BuildContext context) {
    QRcodeController qrController = Get.find();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('QR Code Result'),
      ),
      body: GetBuilder(builder: (NavigationController navController) {
        List<String> tickets = seatsLength(ticket.seatNumbers);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccessful ? Icons.check_circle : Icons.cancel,
                color: isSuccessful ? Colors.green : Colors.orange,
                size: 100,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: tickets
                    .map((e) => Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: isSuccessful
                                      ? Colors.green
                                      : Colors.orange,
                                  borderRadius: BorderRadius.circular(5)),
                              child: SvgPicture.asset(
                                "assets/images/seat 2.svg",
                              ),
                            ),
                            Container(
                              child: Text(
                                "Seat $e",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSuccessful
                                        ? Colors.green
                                        : Colors.orange,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
              const SizedBox(
                height: 60,
              ),
              TextButton(
                onPressed: () {
                  navController.changeIndex(0);
                  Get.back();
                  Get.back();
                  // qrController.qrcontroller!.stopCamera();
                },
                child: const Text('Back to home'),
              )
            ],
          ),
        );
      }),
    );
  }
}
