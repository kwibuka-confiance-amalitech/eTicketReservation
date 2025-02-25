import 'package:car_ticket/presentation/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Image.asset('assets/images/car_image.png')),
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                left: 40,
                right: 40,
              ),
              child: const Text('Welcome to Car Ticket',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                left: 40,
                right: 40,
                bottom: 20,
              ),
              child: const Text(
                  // paragraph of 20 words
                  'Book your ticket now and get a 10% discount for your first purchase. Enjoy your trip with us and have a great day!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
            ),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AuthScreen.routeName);
            },
            child: const Text("Get Started")),
      ]),
    ));
  }
}
