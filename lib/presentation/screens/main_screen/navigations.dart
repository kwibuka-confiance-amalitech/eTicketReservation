import 'package:car_ticket/controller/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class Navigations extends StatelessWidget {
  static const String routeName = '/navigations';
  const Navigations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder(
            init: NavigationController(),
            builder: (navController) {
              return navController.pages[navController.currentIndex];
            }),
        bottomNavigationBar: GetBuilder(
            init: NavigationController(),
            builder: (bottomController) {
              return BottomNavigationBar(
                currentIndex: bottomController.currentIndex,
                onTap: (index) {
                  bottomController.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: 'Home',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.qr_code_scanner_rounded),
                  //   label: 'Scan QR Code',
                  // ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              );
            }));
  }
}
