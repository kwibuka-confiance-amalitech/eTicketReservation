import 'package:car_ticket/controller/dashboard/customers.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/report/report_screen.dart';
import 'package:car_ticket/presentation/screens/setting_screens/edit_profile.dart';
import 'package:car_ticket/presentation/widgets/custom_appbar.dart';
import 'package:car_ticket/presentation/widgets/dashboard/customer_card.dart';
import 'package:car_ticket/presentation/widgets/dashboard/main_card.dart';
import 'package:car_ticket/presentation/widgets/dashboard/main_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarTicketDashboard extends StatelessWidget {
  static const String routeName = '/dashboard';
  const CarTicketDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Excel Tour',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('View Profile'),
                onTap: () {
                  Get.toNamed(UserProfileScreen.routeName);
                },
              ),
              ListTile(
                title: const Text('View Reports'),
                onTap: () {
                  Get.toNamed(DashboardReportScreen.routeName);
                },
              ),
            ],
          ),
        ),
        appBar: CustomAppBar(
          title: "Home",
          isActionButtonsThere: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const MainCard(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: DashboardItemsList.dashboardItemsList
                      .map((item) => AdminMainItem(
                          icon: item.icon,
                          title: item.title,
                          color: item.color,
                          routeName: item.routeName))
                      .toList(),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Customers",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("View All",
                          style: TextStyle(
                            color: Colors.purple,
                          ))
                    ],
                  ),
                ),
                GetBuilder(
                    init: CustomersController(),
                    builder: (CustomersController customersController) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: customersController.isGettingCustomers
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => CustomerItem(
                                  customer:
                                      customersController.customers[index],
                                ),
                                itemCount: customersController.customers.length,
                              ),
                      );
                    }),
              ],
            ),
          ),
        ));
  }
}
