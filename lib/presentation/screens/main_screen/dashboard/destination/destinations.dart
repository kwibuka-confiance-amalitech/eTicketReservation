import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/destination/add_destination.dart';
import 'package:car_ticket/presentation/widgets/dashboard/journey_destination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DestinationsScreen extends StatelessWidget {
  static const String routeName = '/destinations';
  const DestinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0.h,
            floating: false,
            pinned: true,
            flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8)
                    ],
                  ),
                ),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                        child: TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: const AddDestination(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Add Destination',
                              style: TextStyle(color: Colors.white)),
                        )))),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 20.w),
                child: Row(
                  children: [
                    Text('All Destinations',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              GetBuilder(
                  init: JourneyDestinationController(),
                  builder:
                      (JourneyDestinationController destinationController) {
                    return destinationController.isGettingDestinations
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : destinationController.destinations.isEmpty
                            ? SizedBox(
                                height: 200.h,
                                width: MediaQuery.of(context).size.width,
                                child: const Center(
                                  child: Text('No Destinations Found'),
                                ),
                              )
                            : Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.0.w),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      destinationController.destinations.length,
                                  itemBuilder: (context, index) {
                                    JourneyDestination destination =
                                        destinationController
                                            .destinations[index];
                                    return DestinationCard(
                                      destination: destination,
                                    );
                                  },
                                ),
                              );
                  }),
            ]),
          ),
        ],
      ),
    );
  }
}
