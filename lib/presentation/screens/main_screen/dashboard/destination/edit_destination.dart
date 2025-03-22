import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditDestinationWidget extends StatefulWidget {
  final JourneyDestination destination;

  const EditDestinationWidget({
    super.key,
    required this.destination,
  });

  @override
  State<EditDestinationWidget> createState() => _EditDestinationWidgetState();
}

class _EditDestinationWidgetState extends State<EditDestinationWidget> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;

  // Time state variables
  late String _fromTime;
  late String _toTime;

  @override
  void initState() {
    super.initState();

    // Initialize with existing values
    _descriptionController =
        TextEditingController(text: widget.destination.description);
    _priceController = TextEditingController(text: widget.destination.price);
    _durationController =
        TextEditingController(text: widget.destination.duration);

    // Initialize times from destination
    _fromTime = widget.destination.from ?? 'Select Time';
    _toTime = widget.destination.to ?? 'Select Time';
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar and title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Edit Route',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),

          // Form
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // From time
                        TimePickerWidget(
                          chooseTime: _fromTime,
                          title: 'Departure Time',
                          onTimeChanged: (time) {
                            setState(() {
                              _fromTime = time;
                            });
                          },
                        ),
                        Gap(16.h),

                        // To time
                        TimePickerWidget(
                          chooseTime: _toTime,
                          title: 'Arrival Time',
                          onTimeChanged: (time) {
                            setState(() {
                              _toTime = time;
                            });
                          },
                        ),
                        Gap(16.h),
                      ],
                    ),

                    Gap(30),

                    // Description field
                    _buildLabel('Route Description'),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter route description',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    Gap(16.h),

                    // Price and duration in a row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Price (RWF)'),
                              TextFormField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter price',
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Invalid number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Duration (Hours)'),
                              TextFormField(
                                controller: _durationController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter hours',
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.timelapse,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Invalid number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Action buttons
          Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: GetBuilder<JourneyDestinationController>(
                    builder: (controller) {
                      return ElevatedButton(
                        onPressed: controller.isDestinationUpdating
                            ? null
                            : () => _updateDestination(controller),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: controller.isDestinationUpdating
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text('Save Changes',
                                style: TextStyle(fontSize: 16.sp)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _updateDestination(JourneyDestinationController controller) {
    if (_formKey.currentState!.validate()) {
      // Disable soft keyboard
      FocusScope.of(context).unfocus();

      // Create updated destination object
      final updatedDestination = widget.destination.copyWith(
        description: _descriptionController.text,
        price: _priceController.text,
        duration: _durationController.text,
        from: _fromTime, // Add this
        to: _toTime, // Add this
      );

      // Update in controller
      controller.updateDestination(updatedDestination).then((_) {
        Navigator.pop(context);
        Get.snackbar(
          'Success',
          'Route updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }).catchError((error) {
        // Error is already handled in the controller
        // but we can add additional UI feedback here if needed
      });
    }
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
              )),
        )
      ],
    );
  }
}
