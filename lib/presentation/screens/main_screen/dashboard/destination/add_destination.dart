import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddDestination extends StatefulWidget {
  const AddDestination({super.key});

  @override
  State<AddDestination> createState() => _AddDestinationState();
}

class _AddDestinationState extends State<AddDestination> {
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

  String? selectedDestination;
  TimeOfDay initialTime = TimeOfDay.now();
  TimeOfDay finalTime =
      TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 2);
  DateTime? selectedDate;

  final TextEditingController _imageUrlController = TextEditingController(
      text:
          'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=2069&auto=format&fit=crop');

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JourneyDestinationController>(
      init: JourneyDestinationController(),
      builder: (JourneyDestinationController destinationController) {
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
                            Icons.route,
                            color: Theme.of(context).primaryColor,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          "Add New Route",
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
                        // Route selection
                        _buildSectionTitle('Route Information'),
                        Gap(16.h),

                        // Route dropdown
                        _buildDropdownField(
                          label: 'Select Route',
                          hintText: 'Choose a route',
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
                            hintText: 'e.g., 5000',
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
                            hintText: 'e.g., 2h 30min',
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
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
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

                        _buildSectionTitle('Additional Information'),
                        Gap(16.h),

                        // Image URL
                        TextFormField(
                          controller: _imageUrlController,
                          decoration: _buildInputDecoration(
                            label: 'Image URL',
                            hintText: 'Enter image URL',
                            prefixIcon: Icons.image_outlined,
                          ),
                        ),

                        Gap(16.h),

                        // Available Seats
                        TextFormField(
                          controller:
                              destinationController.availableSeatsController,
                          keyboardType: TextInputType.number,
                          decoration: _buildInputDecoration(
                            label: 'Available Seats',
                            hintText: 'e.g., 40',
                            prefixIcon: Icons.event_seat_outlined,
                          ),
                        ),

                        Gap(32.h),

                        // Submit button
                        MainButton(
                          isColored: true,
                          title: "Add Route",
                          isDisabled:
                              destinationController.isDestinationCreating,
                          isLoading:
                              destinationController.isDestinationCreating,
                          onPressed: () {
                            if (selectedDestination == null) {
                              Get.snackbar(
                                'Error',
                                'Please select a route',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            if (destinationController
                                .destinationformKey.currentState!
                                .validate()) {
                              // Create new journey destination
                              destinationController
                                  .createDestination(JourneyDestination(
                                id: const Uuid().v4(),
                                description: selectedDestination!,
                                price:
                                    destinationController.priceController.text,
                                duration: destinationController.durationTime,
                                from: destinationController.initialTime,
                                to: destinationController.finalTime,
                                imageUrl: _imageUrlController.text,
                                createdAt: DateTime.now().toString(),
                                updatedAt: DateTime.now().toString(),
                                carId: "",
                                isAssigned: false,
                                startDate: selectedDate?.toString(),
                              ));
                            }
                          },
                        ),

                        Gap(20.h),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[700],
          ),
        ),
        Gap(8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(hintText),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.route, color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
            items: items,
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a route';
              }
              return null;
            },
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
            fontSize: 14.sp,
            color: Colors.grey[700],
          ),
        ),
        Gap(8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[600]),
                SizedBox(width: 12.w),
                Text(
                  time.format(context),
                  style: TextStyle(fontSize: 16.sp),
                ),
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
            fontSize: 14.sp,
            color: Colors.grey[700],
          ),
        ),
        Gap(8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600]),
                SizedBox(width: 12.w),
                Text(
                  value,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
