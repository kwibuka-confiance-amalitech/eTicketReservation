import 'package:car_ticket/presentation/screens/main_screen/dashboard/car/cars.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/destination/destinations.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/driver/drivers.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/payments.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/users.dart';
import 'package:flutter/material.dart';

class AdminMainItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final String routeName;
  const AdminMainItem(
      {required this.icon,
      required this.title,
      required this.color,
      required this.routeName,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(routeName);
      },
      child: SizedBox(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Icon(icon, color: Colors.white))),
            Container(child: Text(title)),
          ],
        ),
      ),
    );
  }
}

class DashboardItemsList {
  String title;
  IconData icon;
  Color color;
  String routeName;

  DashboardItemsList(
      {required this.title,
      required this.icon,
      required this.color,
      required this.routeName});

  static List<DashboardItemsList> dashboardItemsList = [
    DashboardItemsList(
        title: 'Customers',
        icon: Icons.person,
        color: Colors.blue,
        routeName: UsersScreen.routeName),
    DashboardItemsList(
        title: 'Drivers',
        icon: Icons.person,
        color: Colors.blue,
        routeName: DriversScreen.routeName),
    DashboardItemsList(
        title: 'Cars',
        icon: Icons.car_rental,
        color: Colors.green,
        routeName: CarsScreen.routeName),
    DashboardItemsList(
        title: 'Destination',
        icon: Icons.playlist_add_check_rounded,
        color: Colors.red,
        routeName: DestinationsScreen.routeName),
    DashboardItemsList(
        title: 'Payments',
        icon: Icons.money,
        color: Colors.orange,
        routeName: PaymentsScreen.routeName),
  ];
}
