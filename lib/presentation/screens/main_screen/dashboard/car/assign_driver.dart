import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/controller/dashboard/driver_controller.dart';
import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/domain/models/driver/driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AssignDriverSheet extends StatefulWidget {
  final ExcelCar car;

  const AssignDriverSheet({
    super.key,
    required this.car,
  });

  @override
  State<AssignDriverSheet> createState() => _AssignDriverSheetState();
}

class _AssignDriverSheetState extends State<AssignDriverSheet> {
  String? selectedDriverId;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header with gradient background
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                Gap(16.h),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    Gap(16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Assign Driver to Vehicle",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            widget.car.name,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search drivers...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Available and assigned drivers list with sections
          Expanded(
            child: GetBuilder<DriverController>(
              init: DriverController(),
              builder: (controller) {
                if (controller.isGettingDrivers) {
                  return _buildLoadingShimmer();
                }

                // Get all drivers
                var allDrivers = controller.drivers;

                // Separate available and assigned drivers
                var availableDrivers =
                    allDrivers.where((driver) => !driver.isAssigned).toList();
                var assignedDrivers =
                    allDrivers.where((driver) => driver.isAssigned).toList();

                // Apply search filter to both lists
                if (_searchQuery.isNotEmpty) {
                  availableDrivers = availableDrivers
                      .where((driver) =>
                          '${driver.firstName} ${driver.lastName}'
                              .toLowerCase()
                              .contains(_searchQuery) ||
                          driver.phone.toLowerCase().contains(_searchQuery))
                      .toList();

                  assignedDrivers = assignedDrivers
                      .where((driver) =>
                          '${driver.firstName} ${driver.lastName}'
                              .toLowerCase()
                              .contains(_searchQuery) ||
                          driver.phone.toLowerCase().contains(_searchQuery))
                      .toList();
                }

                if (availableDrivers.isEmpty && assignedDrivers.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    // Available drivers section
                    if (availableDrivers.isNotEmpty) ...[
                      Text(
                        'Available Drivers',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Gap(12.h),
                      ...availableDrivers.map((driver) {
                        final isSelected = selectedDriverId == driver.id;
                        return _buildDriverCard(driver, isSelected, false);
                      }),
                      Gap(24.h),
                    ],

                    // Assigned drivers section
                    if (assignedDrivers.isNotEmpty) ...[
                      Text(
                        'Already Assigned Drivers',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Gap(12.h),
                      ...assignedDrivers.map((driver) {
                        return _buildDriverCard(driver, false, true);
                      }),
                    ],
                  ],
                );
              },
            ),
          ),

          // Action buttons
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: GetBuilder<CarController>(
                    builder: (carController) {
                      return ElevatedButton(
                        onPressed: selectedDriverId == null
                            ? null
                            : () async {
                                await carController.assignDriverToCar(
                                    carId: widget.car.id,
                                    driverId: selectedDriverId!);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Assign Driver',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
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

  Widget _buildDriverCard(
      CarDriver driver, bool isSelected, bool isAlreadyAssigned) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          margin: EdgeInsets.only(bottom: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isAlreadyAssigned
                      ? Colors.grey[300]!
                      : Colors.transparent,
              width: isSelected ? 2 : 1,
            ),
          ),
          color: isAlreadyAssigned ? Colors.grey[50] : Colors.white,
          child: InkWell(
            onTap: isAlreadyAssigned
                ? () {
                    // Show an informative message when tapping on an assigned driver
                    Get.snackbar(
                      "Driver Already Assigned",
                      "This driver is already assigned to another vehicle. Please unassign them first.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange.withOpacity(0.8),
                      colorText: Colors.white,
                    );
                  }
                : () {
                    setState(() {
                      selectedDriverId = isSelected ? null : driver.id;
                    });
                  },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: isSelected
                        ? Theme.of(context).primaryColor
                        : isAlreadyAssigned
                            ? Colors.grey.shade300
                            : Colors.grey.shade200,
                    child: Text(
                      "${driver.firstName[0]}${driver.lastName[0]}",
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : isAlreadyAssigned
                                ? Colors.grey[600]
                                : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${driver.firstName} ${driver.lastName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: isAlreadyAssigned
                                ? Colors.grey[700]
                                : Colors.black,
                          ),
                        ),
                        Gap(4.h),
                        Text(
                          driver.phone,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                        if (isAlreadyAssigned) ...[
                          Gap(4.h),
                          GetBuilder<CarController>(
                            builder: (carController) {
                              // Find which car this driver is assigned to
                              final assignedCar = carController.cars
                                  .firstWhereOrNull(
                                      (car) => car.driverId == driver.id);

                              return Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    size: 14.sp,
                                    color: Colors.orange[700],
                                  ),
                                  Gap(4.w),
                                  Expanded(
                                    child: Text(
                                      assignedCar != null
                                          ? 'Already assigned to ${assignedCar.name}'
                                          : 'Already assigned to another vehicle',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.orange[700],
                                        fontStyle: FontStyle.italic,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!isAlreadyAssigned)
                    Radio<String>(
                      value: driver.id,
                      groupValue: selectedDriverId,
                      onChanged: (value) {
                        setState(() {
                          selectedDriverId = value;
                        });
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  if (isAlreadyAssigned)
                    IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.grey[600],
                        size: 20.sp,
                      ),
                      onPressed: () {
                        // Show info about car assignment
                        Get.snackbar(
                          "Driver Unavailable",
                          "This driver is already assigned to another vehicle and can't be reassigned until unassigned.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blueGrey.withOpacity(0.8),
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),

        // "Assigned" banner for already assigned drivers
        if (isAlreadyAssigned)
          Positioned(
            top: -8,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.orange[700],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
              child: Text(
                'Assigned',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          Gap(16.h),
          Text(
            'No Drivers Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Gap(8.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'No drivers match your search criteria'
                : 'No drivers available in the system',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _assignDriver() {
    if (selectedDriverId == null) {
      Get.snackbar(
        "No Selection",
        "Please select a driver to assign",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    final controller = Get.find<CarController>();
    controller.assignDriverToCar(
      carId: widget.car.id,
      driverId: selectedDriverId!,
    );
  }
}
