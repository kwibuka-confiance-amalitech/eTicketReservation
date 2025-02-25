import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/car/add_car.dart';
import 'package:car_ticket/presentation/widgets/dashboard/car_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CarsScreen extends StatelessWidget {
  static const String routeName = '/cars';
  const CarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
            title: const Text('Cars'),
            floating: true,
            snap: true,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 200,
            foregroundColor: Colors.white,
            flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextButton.icon(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: const AddCar(),
                            ),
                          ),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Add Car',
                              style: TextStyle(color: Colors.white)),
                        ))))),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: const Row(
                  children: [
                    Text('All Cars',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              GetBuilder(
                  init: CarController(),
                  builder: (CarController carController) {
                    return carController.isGettingCars
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: carController.cars.length,
                                itemBuilder: (context, index) {
                                  final car = carController.cars[index];
                                  return CarListItem(
                                    car: car,
                                  );
                                }),
                          );
                  }),
            ],
          ),
        ),
      ],
    ));
  }
}
