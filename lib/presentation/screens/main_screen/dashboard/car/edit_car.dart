import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/presentation/widgets/custom_textfields_decoration.dart';
import 'package:car_ticket/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class EditCarWidget extends StatefulWidget {
  final ExcelCar car;
  const EditCarWidget({required this.car, super.key});

  @override
  State<EditCarWidget> createState() => _EditCarWidgetState();
}

class _EditCarWidgetState extends State<EditCarWidget> {
  final List<String> carTypes = [
    'Sedan',
    'SUV',
    'Bus',
    'Van',
    'Coaster',
    'Mini-Bus'
  ];
  late String selectedType;
  late int selectedSeats;
  late TextEditingController mileageController;
  late DateTime nextMaintenance;

  @override
  void initState() {
    super.initState();
    selectedType = widget.car.type;
    selectedSeats = widget.car.seatNumbers;
    mileageController =
        TextEditingController(text: widget.car.mileage.toString());
    nextMaintenance = widget.car.nextMaintenance;
  }

  @override
  void dispose() {
    mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CarController(),
        builder: (CarController carController) {
          // Initialize controller values with car data
          carController.nameController.text = widget.car.name;
          carController.plateNumberController.text = widget.car.plateNumber;
          carController.colorController.text = widget.car.color;
          carController.modelController.text = widget.car.model;
          carController.yearController.text = widget.car.year;

          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                child: Form(
                  key: carController.carformKey,
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
                      Text(
                        "Edit Vehicle Details",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(20.h),
                      TextFormField(
                        initialValue: widget.car.name,
                        decoration: customTextFieldDecoration(
                          labelText: "Name",
                          hintText: "e.g., Toyota Coaster #12",
                          context: context,
                        ),
                        onChanged: (value) {
                          carController.nameController.text = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      Gap(15.h),
                      TextFormField(
                        initialValue: widget.car.plateNumber,
                        decoration: customTextFieldDecoration(
                          labelText: "Plate Number",
                          hintText: "e.g., RAB 123A",
                          context: context,
                        ),
                        onChanged: (value) {
                          carController.plateNumberController.text = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a plate number';
                          }
                          return null;
                        },
                      ),
                      Gap(15.h),

                      // Car type dropdown
                      Text(
                        "Vehicle Type",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      Gap(8.h),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            border: InputBorder.none,
                          ),
                          value: selectedType,
                          items: carTypes
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedType = value!;
                            });
                          },
                        ),
                      ),
                      Gap(15.h),

                      // Seat numbers slider
                      Text(
                        "Seat Capacity: $selectedSeats",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      Gap(5.h),
                      Slider(
                        value: selectedSeats.toDouble(),
                        min: 2,
                        max: 50,
                        divisions: 48,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value) {
                          setState(() {
                            selectedSeats = value.round();
                          });
                        },
                      ),
                      Gap(15.h),

                      // Color input
                      TextFormField(
                        initialValue: widget.car.color,
                        decoration: customTextFieldDecoration(
                          labelText: "Color",
                          hintText: "e.g., White",
                          context: context,
                        ),
                        onChanged: (value) {
                          carController.colorController.text = value;
                        },
                      ),
                      Gap(15.h),

                      // Two fields side by side (model & year)
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: widget.car.model,
                              decoration: customTextFieldDecoration(
                                labelText: "Model",
                                hintText: "e.g., Coaster",
                                context: context,
                              ),
                              onChanged: (value) {
                                carController.modelController.text = value;
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: TextFormField(
                              initialValue: widget.car.year,
                              decoration: customTextFieldDecoration(
                                labelText: "Year",
                                hintText: "e.g., 2023",
                                context: context,
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                carController.yearController.text = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      Gap(15.h),

                      // Mileage input
                      TextFormField(
                        controller: mileageController,
                        decoration: customTextFieldDecoration(
                          labelText: "Current Mileage (km)",
                          hintText: "e.g., 5000",
                          context: context,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      Gap(15.h),

                      // Next maintenance date
                      Text(
                        "Next Maintenance Date",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      Gap(8.h),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            DateFormat('dd MMM, yyyy').format(nextMaintenance),
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: nextMaintenance,
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null && picked != nextMaintenance) {
                              setState(() {
                                nextMaintenance = picked;
                              });
                            }
                          },
                        ),
                      ),
                      Gap(25.h),

                      MainButton(
                        isColored: true,
                        title: "Update Vehicle",
                        isDisabled: carController.isUpdatingCar,
                        isLoading: carController.isUpdatingCar,
                        onPressed: () async {
                          if (carController.carformKey.currentState!
                              .validate()) {
                            // Create updated car with all fields
                            final updatedCar = ExcelCar(
                              id: widget.car.id,
                              name: carController.nameController.text,
                              plateNumber:
                                  carController.plateNumberController.text,
                              color: carController.colorController.text,
                              model: carController.modelController.text,
                              type: selectedType,
                              year: carController.yearController.text,
                              driverId: widget.car.driverId,
                              driverName: widget.car.driverName,
                              isAssigned: widget.car.isAssigned,
                              seatNumbers: selectedSeats,
                              mileage:
                                  double.tryParse(mileageController.text) ??
                                      widget.car.mileage,
                              lastMaintenance: widget.car.lastMaintenance,
                              nextMaintenance: nextMaintenance,
                            );

                            await carController.updateCar(updatedCar);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
