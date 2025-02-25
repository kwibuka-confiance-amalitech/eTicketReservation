import 'package:car_ticket/controller/home/selected_destination.dart';
import 'package:car_ticket/presentation/screens/car_all_details/seat_widget.dart';
import 'package:car_ticket/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

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
                                child: Text('Select your destination',
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
                          if (selectedDestinationController.selectedDestination.value.startDate?.isNotEmpty ?? false) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                    _formatDate(selectedDestinationController.selectedDestination.value.startDate!),
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
                                ShowPickupLocation().show(context);
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
  show(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => GetBuilder(builder:
                (SelectedDestinationController selectedDestinationController) {
              return AlertDialog(
                title: const Text("Select your location"),
                content: Wrap(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Please select your pickup location"),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1.5,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<String>(
                            value: selectedDestinationController
                                .selectedDestinationOption,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 16,
                            elevation: 16,
                            hint: const Text("Your location"),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 71, 71, 71)),
                            underline: Container(
                              height: 0,
                              color: const Color.fromARGB(255, 68, 68, 68),
                            ),
                            onChanged: selectedDestinationController
                                .selectedPickupLocationHandler,
                            items: exactLocations.map<DropdownMenuItem<String>>(
                                (ExactLocation value) {
                              return DropdownMenuItem<String>(
                                value: value.name.toString(),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      foregroundColor: Colors.white,
                                      child: Text(
                                        value.name.substring(0, 1),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      value.name,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20.0),
                                child: Wrap(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Select your payment method",
                                            style: TextStyle(fontSize: 18.0)),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        MainButton(
                                            isColored: false,
                                            onPressed: () => selectedDestinationController
                                                .payPriceHandler(
                                                    carId:
                                                        selectedDestinationController
                                                            .selectedDestination
                                                            .value
                                                            .carId,
                                                    seats:
                                                        selectedDestinationController
                                                            .selectedSeats),
                                            title: "Pay with Card"),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        MainButton(
                                            isColored: false,
                                            onPressed: () {
                                              Get.dialog(AlertDialog(
                                                title: const Text(
                                                    "Payment with Momo"),
                                                content: const Text(
                                                    "Please dial *182*8# to pay with Momo"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child:
                                                          const Text("Close"))
                                                ],
                                              ));
                                            },
                                            title: "Pay with Momo"),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: const Text("Continue"))
                ],
              );
            }));
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
