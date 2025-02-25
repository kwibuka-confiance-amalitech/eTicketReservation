import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class CarQrCodeCreation extends StatelessWidget {
  final ExcelCar car;
  const CarQrCodeCreation({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    final carController = Get.find<CarController>();
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Car Qr Code',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Scan this code to get the car details',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Center(
                child: Screenshot(
                  controller: carController.screenshotController,
                  child: Container(
                    height: 200,
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: QrImageView(data: car.id),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MainButton(
                  isColored: false,
                  isLoading: carController.isDownloadingQrCode,
                  onPressed: () {
                    carController.downloadScreenShot(car);
                  },
                  title: "Download QR Code")
            ],
          ),
        ],
      ),
    );
  }
}
