import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditDestinationWidget extends StatefulWidget {
  final JourneyDestination destination;

  const EditDestinationWidget({
    required this.destination,
    super.key,
  });

  @override
  State<EditDestinationWidget> createState() => _EditDestinationWidgetState();
}

class _EditDestinationWidgetState extends State<EditDestinationWidget> {
  final List<String> popularDestinations = [
    'Kigali to Musanze',
    'Kigali to Huye',
    'Kigali to Rubavu',
    'Kigali to Rusizi',
    'Kigali to Nyagatare',
    'Musanze to Kigali',
    'Huye to Kigali',
    'Rubavu to Kigali',
  ];

  late String? selectedDestination;
  late TimeOfDay initialTime;
  late TimeOfDay finalTime;
  late DateTime? selectedDate;
  late TextEditingController imageUrlController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    selectedDestination = widget.destination.description;

    // Parse time strings
    final initialTimeParts = widget.destination.from.split(':');
    initialTime = TimeOfDay(
      hour: int.parse(initialTimeParts[0]),
      minute: int.parse(initialTimeParts[1]),
    );

    final finalTimeParts = widget.destination.to.split(':');
    finalTime = TimeOfDay(
      hour: int.parse(finalTimeParts[0]),
      minute: int.parse(finalTimeParts[1]),
    );

    // Parse start date
    selectedDate = widget.destination.startDate != null
        ? DateTime.parse(widget.destination.startDate!)
        : null;

    // Image URL
    imageUrlController =
        TextEditingController(text: widget.destination.imageUrl);
  }

  @override
  void dispose() {
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JourneyDestinationController>(
      init: JourneyDestinationController(),
      builder: (JourneyDestinationController destinationController) {
        // Initialize controller with destination data
        destinationController.priceController.text = widget.destination.price;
        destinationController.durationController.text =
            widget.destination.duration;
        destinationController.initialTime = widget.destination.from;
        destinationController.finalTime = widget.destination.to;
        destinationController.selectedDestination =
            widget.destination.description;

        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            children: [
              // Header with drag handle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                    Gap(20.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.edit_road,
                            color: Theme.of(context).primaryColor,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          "Edit Route",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Gap(24.h),
                  ],
                ),
              ),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Form(
                    key: destinationController.destinationformKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Route information section
                        _buildSectionTitle('Route Information'),
                        Gap(16.h),

                        // Route dropdown
                        _buildDropdownField(
                          label: 'Select Route',
                          value: selectedDestination,
                          items: popularDestinations.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDestination = value;
                              destinationController
                                  .selectedDestinationChange(value);
                            });
                          },
                        ),

                        Gap(16.h),

                        // Price field
                        TextFormField(
                          controller: destinationController.priceController,
                          keyboardType: TextInputType.number,
                          decoration: _buildInputDecoration(
                            label: 'Price (RWF)',
                            prefixIcon: Icons.monetization_on_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the price';
                            }
                            return null;
                          },
                        ),

                        Gap(16.h),

                        // Duration field
                        TextFormField(
                          controller: destinationController.durationController,
                          decoration: _buildInputDecoration(
                            label: 'Duration',
                            prefixIcon: Icons.timer_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the duration';
                            }
                            return null;
                          },
                        ),

                        Gap(24.h),

                        // Schedule section
                        _buildSectionTitle('Schedule Information'),
                        Gap(16.h),

                        // Time pickers row
                        Row(
                          children: [
                            Expanded(
                              child: _buildTimePicker(
                                label: 'Departure',
                                time: initialTime,
                                onTap: () async {
                                  final TimeOfDay? picked =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: initialTime,
                                  );
                                  if (picked != null && picked != initialTime) {
                                    setState(() {
                                      initialTime = picked;

                                      // Update destinationController
                                      final hour = picked.hour
                                          .toString()
                                          .padLeft(2, '0');
                                      final minute = picked.minute
                                          .toString()
                                          .padLeft(2, '0');
                                      destinationController.initialTime =
                                          '$hour:$minute';
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _buildTimePicker(
                                label: 'Arrival',
                                time: finalTime,
                                onTap: () async {
                                  final TimeOfDay? picked =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: finalTime,
                                  );
                                  if (picked != null && picked != finalTime) {
                                    setState(() {
                                      finalTime = picked;

                                      // Update destinationController
                                      final hour = picked.hour
                                          .toString()
                                          .padLeft(2, '0');
                                      final minute = picked.minute
                                          .toString()
                                          .padLeft(2, '0');
                                      destinationController.finalTime =
                                          '$hour:$minute';
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        Gap(16.h),

                        // Date picker
                        _buildDatePicker(
                          label: 'Start Date',
                          value: selectedDate != null
                              ? DateFormat('dd MMM, yyyy').format(selectedDate!)
                              : 'Select date',
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                                destinationController.startDate = picked;
                              });
                            }
                          },
                        ),

                        Gap(24.h),

                        // Additional information section
                        _buildSectionTitle('Additional Information'),
                        Gap(16.h),

                        // Image URL field
                        TextFormField(
                          controller: imageUrlController,
                          decoration: _buildInputDecoration(
                            label: 'Image URL',
                            prefixIcon: Icons.image_outlined,
                          ),
                        ),

                        Gap(16.h),

                        // Available seats field
                        TextFormField(
                          controller:
                              destinationController.availableSeatsController,
                          keyboardType: TextInputType.number,
                          decoration: _buildInputDecoration(
                            label: 'Available Seats',
                            prefixIcon: Icons.event_seat_outlined,
                          ),
                        ),

                        // Assignment status
                        Gap(24.h),

                        if (widget.destination.isAssigned)
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.orange.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.directions_bus,
                                    color: Colors.orange,
                                    size: 24.sp,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Route In Use',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Vehicle ID: ${widget.destination.carId}',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        Gap(24.h),

                        // Save button
                        MainButton(
                          isColored: true,
                          isLoading:
                              destinationController.isDestinationCreating,
                          isDisabled:
                              destinationController.isDestinationCreating,
                          onPressed: () {
                            if (destinationController
                                .destinationformKey.currentState!
                                .validate()) {
                              final newDestination = JourneyDestination(
                                id: widget.destination.id,
                                description: selectedDestination!,
                                from: destinationController.initialTime,
                                to: destinationController.finalTime,
                                price:
                                    destinationController.priceController.text,
                                duration: destinationController
                                    .durationController.text,
                                imageUrl: imageUrlController.text,
                                createdAt: widget.destination.createdAt,
                                updatedAt: DateTime.now().toString(),
                                carId: widget.destination.carId,
                                isAssigned: widget.destination.isAssigned,
                                startDate: selectedDate?.toIso8601String(),
                              );

                              destinationController
                                  .createDestination(newDestination);
                            }
                          },
                          title: "Edit Destination",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _buildInputDecoration(
      {required String label, required IconData prefixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time.format(context),
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                Icon(Icons.access_time),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
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
