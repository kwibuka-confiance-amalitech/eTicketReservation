import 'package:car_ticket/controller/home/destinations.dart';
import 'package:car_ticket/presentation/screens/main_screen/home/car_availability_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeJourneyDestinationController(),
        builder: (HomeJourneyDestinationController homeController) {
          return SizedBox(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: Column(
                      children: [
                        SafeArea(
                          child: Container(
                            padding: EdgeInsets.only(top: 50.h),
                            child: const Text('Excel tours',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 140.h,
                    right: 20.w,
                    child: TextButton.icon(
                        onPressed: () {
                          SearchAlert.show(context);
                        },
                        icon: Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                        label: Text("Filter",
                            style: TextStyle(
                                color: Colors.white, fontSize: 18.sp)))),
                Positioned(
                    top: 140.h,
                    left: 20.w,
                    child: !homeController.isAllDestinationsShown
                        ? TextButton.icon(
                            onPressed: () async {
                              homeController.showAllDestinations();
                            },
                            icon: Icon(
                              Icons.clear_all_rounded,
                              color: Colors.white,
                              size: 30.r,
                            ),
                            label: Text("Show all",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.sp)))
                        : const SizedBox()),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.63.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 40.h, bottom: 20.h),
                            child: const Text('Select your destination',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                          // switch
                          homeController.isGettingDestinations
                              ? SizedBox(
                                  height: 400.h,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : homeController.destinations.isEmpty
                                  ? SizedBox(
                                      height: 400.h,
                                      child: const Center(
                                        child:
                                            Text("No destinations available"),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 430.h,
                                      child: ListView.builder(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 10.h),
                                          itemCount: homeController
                                              .destinations.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) =>
                                              CarAvailability(
                                                destination: homeController
                                                    .destinations
                                                    .elementAt(index),
                                              )),
                                    )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class SearchAlert {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<HomeJourneyDestinationController>(
          builder: (homeDestController) {
            return AlertDialog(
              title: const Text("Filter Routes"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Destination Dropdown
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: homeDestController.selectedDestinationOption,
                      isExpanded: true,
                      hint: const Text("Select Route"),
                      underline: const SizedBox(),
                      items: homeDestController.destinations.map((destination) {
                        return DropdownMenuItem(
                          value: destination.description,
                          child: Text(destination.description),
                        );
                      }).toList(),
                      onChanged: homeDestController.selectedDestinationChange,
                    ),
                  ),

                  Gap(16.h),

                  // Time Picker
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          homeDestController.selectedTimeChange(
                            homeDestController.formatTimeString(picked),
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.grey[600]),
                            SizedBox(width: 8.w),
                            Text(
                              homeDestController.selectedTimeOption ??
                                  'Select Time',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (homeDestController.selectedDestinationOption == null ||
                        homeDestController.selectedTimeOption == null) {
                      Get.snackbar(
                        'Error',
                        'Please select both route and time',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    Navigator.pop(context);
                    homeDestController.searchDestinations(
                      homeDestController.selectedTimeOption!,
                      homeDestController.selectedDestinationOption!,
                    );
                  },
                  child: const Text('Search'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TimeOfAvailableHour {
  final String hour;
  final String hourValue;

  TimeOfAvailableHour(this.hour, this.hourValue);
}

List<TimeOfAvailableHour> timeOfAvailableHours = [
  TimeOfAvailableHour("0", "12:00 AM"),
  TimeOfAvailableHour("1", "12:30 AM"),
  TimeOfAvailableHour("2", "1:00 AM"),
  TimeOfAvailableHour("3", "1:30 AM"),
  TimeOfAvailableHour("4", "2:00 AM"),
  TimeOfAvailableHour("5", "2:30 AM"),
  TimeOfAvailableHour("6", "3:00 AM"),
  TimeOfAvailableHour("7", "3:30 AM"),
  TimeOfAvailableHour("8", "4:00 AM"),
  TimeOfAvailableHour("9", "4:30 AM"),
  TimeOfAvailableHour("10", "5:00 AM"),
  TimeOfAvailableHour("11", "5:30 AM"),
  TimeOfAvailableHour("12", "6:00 AM"),
  TimeOfAvailableHour("13", "6:30 AM"),
  TimeOfAvailableHour("14", "7:00 AM"),
  TimeOfAvailableHour("15", "7:30 AM"),
  TimeOfAvailableHour("16", "8:00 AM"),
  TimeOfAvailableHour("17", "8:30 AM"),
  TimeOfAvailableHour("18", "9:00 AM"),
  TimeOfAvailableHour("19", "9:30 AM"),
  TimeOfAvailableHour("20", "10:00 AM"),
  TimeOfAvailableHour("21", "10:30 AM"),
  TimeOfAvailableHour("22", "11:00 AM"),
  TimeOfAvailableHour("23", "11:30 AM"),
  TimeOfAvailableHour("24", "12:00 PM"),
  TimeOfAvailableHour("25", "12:30 PM"),
  TimeOfAvailableHour("26", "1:00 PM"),
  TimeOfAvailableHour("27", "1:30 PM"),
  TimeOfAvailableHour("28", "2:00 PM"),
  TimeOfAvailableHour("29", "2:30 PM"),
  TimeOfAvailableHour("30", "3:00 PM"),
  TimeOfAvailableHour("31", "3:30 PM"),
  TimeOfAvailableHour("32", "4:00 PM"),
  TimeOfAvailableHour("33", "4:30 PM"),
  TimeOfAvailableHour("34", "5:00 PM"),
  TimeOfAvailableHour("35", "5:30 PM"),
  TimeOfAvailableHour("36", "6:00 PM"),
  TimeOfAvailableHour("37", "6:30 PM"),
  TimeOfAvailableHour("38", "7:00 PM"),
  TimeOfAvailableHour("39", "7:30 PM"),
  TimeOfAvailableHour("40", "8:00 PM"),
  TimeOfAvailableHour("41", "8:30 PM"),
  TimeOfAvailableHour("42", "9:00 PM"),
  TimeOfAvailableHour("43", "9:30 PM"),
  TimeOfAvailableHour("44", "10:00 PM"),
  TimeOfAvailableHour("45", "10:30 PM"),
  TimeOfAvailableHour("46", "11:00 PM"),
  TimeOfAvailableHour("47", "11:30 PM"),
];
