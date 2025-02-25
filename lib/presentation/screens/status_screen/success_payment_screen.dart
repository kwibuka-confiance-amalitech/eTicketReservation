import 'package:car_ticket/controller/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccessScreen extends StatelessWidget {
  static const routeName = '/payment-success';
  final bool isSuccessful;
  const PaymentSuccessScreen({this.isSuccessful = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: GetBuilder(builder: (NavigationController navController) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccessful ? Icons.check_circle : Icons.cancel,
                color: isSuccessful ? Colors.green : Colors.red,
                size: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                isSuccessful ? 'Success' : 'Failed',
                style: const TextStyle(fontSize: 20),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Text(
                  isSuccessful
                      ? 'Your payment was successful, you can now board the car and enjoy your journey'
                      : 'Your payment was not successful',
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
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
