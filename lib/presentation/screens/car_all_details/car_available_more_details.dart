import 'package:car_ticket/controller/home/selected_destination.dart';
import 'package:car_ticket/domain/models/seat.dart';
import 'package:car_ticket/presentation/screens/car_all_details/seat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CarAvailableDetails extends StatelessWidget {
  static const String routeName = '/car_details';
  const CarAvailableDetails({super.key});

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Date not set';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: const [
          // IconButton(
          //   onPressed: () {
          //     // Navigator.pop(context);
          //   },
          //   icon: const Icon(Icons.more_vert_outlined),
          // )
        ],
      ),
      body: GetBuilder(
          init: SelectedDestinationController(),
          builder:
              (SelectedDestinationController selectedDestinationController) {
            print(selectedDestinationController.selectedSeatsCount);
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                              selectedDestinationController
                                  .selectedDestination.value.description,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.72,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 40, bottom: 20),
                                child: Text('Select your favourite seat(s)',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SeatSelection(
                                    isTitle: true,
                                    title: "Available",
                                    isReserved: false,
                                    isBooked: false,
                                    seat: null,
                                  ),
                                  SeatSelection(
                                    isTitle: true,
                                    title: "Booked",
                                    isReserved: false,
                                    isBooked: true,
                                    seat: null,
                                  ),
                                  SeatSelection(
                                    isTitle: true,
                                    title: "Reserved",
                                    isReserved: true,
                                    isBooked: false,
                                    seat: null,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  selectedDestinationController
                                          .isGettingCarSeats
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          height: 200,
                                          child: const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          child: GridView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      crossAxisSpacing: 4,
                                                      mainAxisSpacing: 4,
                                                      childAspectRatio: 2.6),
                                              itemCount:
                                                  selectedDestinationController
                                                      .carSeats
                                                      .seatsList
                                                      .length,
                                              itemBuilder: (context, index) =>
                                                  SeatSelection(
                                                    isReserved:
                                                        selectedDestinationController
                                                            .carSeats
                                                            .seatsList[index]
                                                            .isReserved,
                                                    isBooked:
                                                        selectedDestinationController
                                                            .carSeats
                                                            .seatsList[index]
                                                            .isBooked,
                                                    seat:
                                                        selectedDestinationController
                                                            .carSeats
                                                            .seatsList[index],
                                                  )),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 70,
                    left: 40,
                    right: 40,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          Text("Excel Tours",
                              style: TextStyle(fontSize: 18.0.sp)),
                          const SizedBox(height: 10.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(selectedDestinationController
                                    .selectedDestination.value.from),
                                const Text("to"),
                                Text(selectedDestinationController
                                    .selectedDestination.value.to),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          if (selectedDestinationController.selectedDestination
                                  .value.startDate?.isNotEmpty ??
                              false) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16.sp,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    _formatDate(selectedDestinationController
                                        .selectedDestination.value.startDate!),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "Price: ${selectedDestinationController.selectedDestination.value.price.toString()} RWF"),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    )),
                selectedDestinationController.selectedSeatsCount == 0
                    ? Container()
                    : Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                ShowPickupLocation().show(
                                    context,
                                    selectedDestinationController
                                        .selectedSeats);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 20),
                              ),
                              child: const Text('Book Now'),
                            ))),
              ],
            );
          }),
    );
  }
}

class ShowPickupLocation {
  show(BuildContext context, List<Seat> selectedSeats) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GetBuilder<SelectedDestinationController>(
        builder: (selectedDestinationController) {
          return AlertDialog(
            title: Text(
              "Select your location",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please select your pickup location",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 15.h),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: DropdownButton<String>(
                    value: selectedDestinationController.selectedPickupLocation,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24.sp,
                    elevation: 16,
                    hint: Text(
                      "Your pickup location",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14.sp,
                    ),
                    underline: Container(height: 0),
                    onChanged: (String? value) {
                      selectedDestinationController
                          .selectedPickupLocationHandler(value);
                    },
                    items: exactLocations
                        .map<DropdownMenuItem<String>>(
                          (location) => DropdownMenuItem<String>(
                            value: location.name,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).primaryColor,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(location.name),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedDestinationController.selectedPickupLocation ==
                      null) {
                    Get.snackbar(
                      'Error',
                      'Please select your pickup location',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  Navigator.pop(context);

                  // Show payment sheet with selected location
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => PaymentBottomSheet(
                      seats: selectedSeats,
                      carId: selectedDestinationController
                          .selectedDestination.value.carId,
                      pickupLocation:
                          selectedDestinationController.selectedPickupLocation!,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Add this PaymentBottomSheet widget
class PaymentBottomSheet extends StatelessWidget {
  final List<Seat> seats;
  final String carId;
  final String pickupLocation;

  const PaymentBottomSheet({
    super.key,
    required this.seats,
    required this.carId,
    required this.pickupLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GetBuilder<SelectedDestinationController>(
        builder: (controller) {
          // Verify pickup location
          if (pickupLocation.isEmpty) {
            Get.back();
            Get.snackbar(
              'Error',
              'Please select a pickup location',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return const SizedBox.shrink();
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Complete Payment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    // Show selected pickup location
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.orange[700]),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pickup Location',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  pickupLocation,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => controller.payPriceHandler(
                        carId: carId,
                        seats: seats,
                        pickupLocation: pickupLocation,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Pay Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ExactLocation {
  String id;
  String name;

  ExactLocation({required this.id, required this.name});
}

List<ExactLocation> exactLocations = [
  ExactLocation(id: "1", name: "Alete"),
  ExactLocation(id: "2", name: "Kanzenze"),
  ExactLocation(id: "3", name: "Gashora"),
  ExactLocation(id: "4", name: "Liziyeri"),
  ExactLocation(id: "4", name: "Mayange"),
  ExactLocation(id: "4", name: "Ramiro"),
];
