import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/presentation/widgets/custom_textfields_decoration.dart';
import 'package:car_ticket/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:uuid/uuid.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  final List<String> carTypes = [
    'Sedan',
    'SUV',
    'Bus',
    'Van',
    'Coaster',
    'Mini-Bus'
  ];
  String selectedType = 'Coaster';
  int selectedSeats = 28;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CarController(),
        builder: (CarController carController) {
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
                        "Add New Vehicle",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(20.h),
                      TextFormField(
                        controller: carController.nameController,
                        decoration: customTextFieldDecoration(
                          labelText: "Name",
                          hintText: "e.g., Toyota Coaster #12",
                          context: context,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      Gap(15.h),
                      TextFormField(
                        controller: carController.plateNumberController,
                        decoration: customTextFieldDecoration(
                          labelText: "Plate Number",
                          hintText: "e.g., RAB 123A",
                          context: context,
                        ),
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
                              // Update default seat count based on vehicle type
                              switch (value) {
                                case 'Sedan':
                                  selectedSeats = 5;
                                  break;
                                case 'SUV':
                                  selectedSeats = 7;
                                  break;
                                case 'Van':
                                  selectedSeats = 12;
                                  break;
                                case 'Mini-Bus':
                                  selectedSeats = 18;
                                  break;
                                case 'Bus':
                                case 'Coaster':
                                  selectedSeats = 28;
                                  break;
                                default:
                                  selectedSeats = 28;
                              }
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
                        controller: carController.colorController,
                        decoration: customTextFieldDecoration(
                          labelText: "Color",
                          hintText: "e.g., White",
                          context: context,
                        ),
                      ),
                      Gap(15.h),

                      // Two fields side by side (model & year)
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: carController.modelController,
                              decoration: customTextFieldDecoration(
                                labelText: "Model",
                                hintText: "e.g., Coaster",
                                context: context,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: TextFormField(
                              controller: carController.yearController,
                              decoration: customTextFieldDecoration(
                                labelText: "Year",
                                hintText: "e.g., 2023",
                                context: context,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Gap(25.h),

                      MainButton(
                        isColored: true,
                        title: "Add Vehicle",
                        isDisabled: carController.isCarCreating,
                        isLoading: carController.isCarCreating,
                        onPressed: () async {
                          if (carController.carformKey.currentState!
                              .validate()) {
                            await carController.addCar(ExcelCar(
                              id: const Uuid().v4(),
                              name: carController.nameController.text,
                              plateNumber:
                                  carController.plateNumberController.text,
                              color: carController.colorController.text.isEmpty
                                  ? 'White'
                                  : carController.colorController.text,
                              model: carController.modelController.text.isEmpty
                                  ? selectedType
                                  : carController.modelController.text,
                              type: selectedType,
                              year: carController.yearController.text,
                              driverId: "",
                              driverName: "",
                              isAssigned: false,
                              seatNumbers: selectedSeats,
                              mileage: 0.0,
                            ));
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
