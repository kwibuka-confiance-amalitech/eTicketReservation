import 'package:car_ticket/controller/dashboard/driver_controller.dart';
import 'package:car_ticket/domain/models/driver/driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditDriverScreen extends StatefulWidget {
  final CarDriver driver;
  const EditDriverScreen({super.key, required this.driver});

  @override
  State<EditDriverScreen> createState() => _EditDriverScreenState();
}

class _EditDriverScreenState extends State<EditDriverScreen> {
  late String selectedGender;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedGender = widget.driver.sexStatus;
    // Initialize controller values
    final controller = Get.find<DriverController>();
    controller.firstNameController.text = widget.driver.firstName;
    controller.lastNameController.text = widget.driver.lastName;
    controller.emailController.text = widget.driver.email;
    controller.phoneController.text = widget.driver.phone;
    controller.addressController.text = widget.driver.address;
    controller.cityController.text = widget.driver.city;
    controller.driverLicenseCategoryController.text =
        widget.driver.driverLicenseCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.w, left: 20.w, right: 20.w, bottom: 20.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GetBuilder<DriverController>(
        builder: (controller) => Form(
          key: _formKey,
          child: Column(
            children: [
              // Drag handle and Close button row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  // Drag handle
                  Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  // Close button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      size: 20.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Gap(12.h),

              // Make the form scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rest of your existing form content...
                      // Header
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              "${widget.driver.firstName[0]}${widget.driver.lastName[0]}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Gap(16.w),
                          Text(
                            "Edit Driver Details",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Gap(30.h),

                      // Personal Information Section
                      Text(
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Gap(16.h),

                      // Name Fields
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.firstNameController,
                              decoration: InputDecoration(
                                labelText: "First Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          Gap(16.w),
                          Expanded(
                            child: TextFormField(
                              controller: controller.lastNameController,
                              decoration: InputDecoration(
                                labelText: "Last Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Last name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Gap(16.h),

                      // Gender Selection
                      Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      Gap(8.h),
                      Row(
                        children: [
                          _buildGenderOption(
                            title: "Male",
                            icon: Icons.male,
                            isSelected: selectedGender == "Male",
                            onTap: () {
                              setState(() {
                                selectedGender = "Male";
                              });
                            },
                          ),
                          Gap(16.w),
                          _buildGenderOption(
                            title: "Female",
                            icon: Icons.female,
                            isSelected: selectedGender == "Female",
                            onTap: () {
                              setState(() {
                                selectedGender = "Female";
                              });
                            },
                          ),
                        ],
                      ),
                      Gap(16.h),

                      // Contact Information Section
                      Text(
                        "Contact Information",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Gap(16.h),

                      TextFormField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      Gap(16.h),

                      TextFormField(
                        controller: controller.phoneController,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                      ),
                      Gap(16.h),

                      // Professional Information Section
                      Text(
                        "Professional Information",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Gap(16.h),

                      TextFormField(
                        controller: controller.driverLicenseCategoryController,
                        decoration: InputDecoration(
                          labelText: "License Category",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.card_membership),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'License category is required';
                          }
                          return null;
                        },
                      ),
                      Gap(16.h),

                      // Address Fields
                      TextFormField(
                        controller: controller.addressController,
                        decoration: InputDecoration(
                          labelText: "Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.location_on),
                        ),
                      ),
                      Gap(16.h),

                      TextFormField(
                        controller: controller.cityController,
                        decoration: InputDecoration(
                          labelText: "City",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.location_city),
                        ),
                      ),
                      Gap(30.h),
                    ],
                  ),
                ),
              ),

              // Update Button at the bottom
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isDriverUpdating
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final updatedDriver = widget.driver.copyWith(
                                firstName: controller.firstNameController.text,
                                lastName: controller.lastNameController.text,
                                email: controller.emailController.text,
                                phone: controller.phoneController.text,
                                address: controller.addressController.text,
                                city: controller.cityController.text,
                                driverLicenseCategory: controller
                                    .driverLicenseCategoryController.text,
                                sexStatus: selectedGender,
                              );

                              await controller.updateDriver(updatedDriver);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isDriverUpdating
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Update Driver",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[400],
                size: 24.sp,
              ),
              Gap(8.h),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
