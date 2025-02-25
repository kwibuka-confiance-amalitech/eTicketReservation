import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/presentation/widgets/custom_textfields_decoration.dart';
import 'package:car_ticket/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditDestinationWidget extends StatelessWidget {
  final JourneyDestination destination;
  const EditDestinationWidget({required this.destination, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: JourneyDestinationController(),
        builder: (JourneyDestinationController destinationController) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0.h, top: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Text(
                          "Edit Destination",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            Get.back();
                            destinationController.clearInitializedItems();
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1.5.w,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: DropdownButton<String>(
                        value: destinationController.selectedDestination,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 16.sp,
                        elevation: 16,
                        hint: const Text("Select Destination"),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 71, 71, 71)),
                        underline: Container(
                          height: 0,
                          color: const Color.fromARGB(255, 68, 68, 68),
                        ),
                        onChanged:
                            destinationController.selectedDestinationChange,
                        items: destinationNames.map<DropdownMenuItem<String>>(
                            (DestinationName value) {
                          return DropdownMenuItem<String>(
                            value: value.name.toString(),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14.r,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  foregroundColor: Colors.white,
                                  child: Text(
                                    value.name.substring(0, 1),
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
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
                    Gap(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TimePickerWidget(
                          chooseTime: destinationController.initialTime,
                          title: "From",
                          onTimeChanged: (value) {
                            destinationController.initialTime = value;
                            destinationController.update();
                          },
                        ),
                        TimePickerWidget(
                          chooseTime: destinationController.finalTime,
                          title: "To",
                          onTimeChanged: (value) {
                            destinationController.finalTime = value;
                            destinationController.update();
                          },
                        ),
                      ],
                    ),
                    TextFormField(
                        initialValue: destination.price,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: customTextFieldDecoration(
                            labelText: "Price",
                            hintText: "Price",
                            context: context),
                        onChanged: (value) {
                          destinationController.priceController.text = value;
                        }),
                    const Gap(15),
                    TextFormField(
                        initialValue: destination.duration,
                        textInputAction: TextInputAction.done,
                        decoration: customTextFieldDecoration(
                            labelText: "Duration",
                            hintText: "Duration",
                            context: context),
                        onChanged: (value) {
                          destinationController.durationController.text = value;
                        }),
                    const Gap(15),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, bottom: 20.h, top: 10.h),
                      child: MainButton(
                          isColored: true,
                          isLoading:
                              destinationController.isDestinationCreating,
                          isDisabled:
                              destinationController.isDestinationCreating,
                          onPressed: () {
                            final newDestination = JourneyDestination(
                              id: destination.id,
                              description:
                                  destinationController.selectedDestination!,
                              from: destinationController.initialTime,
                              to: destinationController.finalTime,
                              price: destinationController
                                      .priceController.text.isEmpty
                                  ? destination.price
                                  : destinationController.priceController.text,
                              duration: destinationController
                                      .durationController.text.isEmpty
                                  ? destination.duration
                                  : destinationController
                                      .durationController.text,
                              imageUrl: destination.imageUrl,
                              createdAt: destination.createdAt,
                              updatedAt: DateTime.now().toString(),
                              carId: destination.carId,
                              isAssigned: destination.isAssigned,
                            );

                            destinationController
                                .createDestination(newDestination);
                          },
                          title: "Edit Destination"),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class DestinationName {
  final int id;
  final String name;

  DestinationName({required this.id, required this.name});
}

List<DestinationName> destinationNames = [
  DestinationName(id: 1, name: "Kigali - Nyamata"),
  DestinationName(id: 1, name: "Nyamata - Kigali")
];

class TimePickerWidget extends StatefulWidget {
  final String chooseTime;
  final String title;
  final Function(String) onTimeChanged;
  const TimePickerWidget({
    required this.chooseTime,
    required this.title,
    required this.onTimeChanged,
    super.key,
  });

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget.chooseTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const Gap(5),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1.5,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  if (value != null) {
                    widget.onTimeChanged(value.format(context));
                  }
                });
              },
              child: Container(
                width: 120,
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(widget.chooseTime)
                  ],
                ),
              ),
            )),
        const Gap(15)
      ],
    );
  }
}
