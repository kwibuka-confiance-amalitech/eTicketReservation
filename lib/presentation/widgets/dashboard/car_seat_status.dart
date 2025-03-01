import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/domain/repositories/car_repository/car_repository_imp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CarSeatStatusWidget extends StatefulWidget {
  final ExcelCar car;

  const CarSeatStatusWidget({
    required this.car,
    super.key,
  });

  @override
  State<CarSeatStatusWidget> createState() => _CarSeatStatusWidgetState();
}

class _CarSeatStatusWidgetState extends State<CarSeatStatusWidget> {
  final CarRepositoryImp _carRepository = Get.put(CarRepositoryImp());
  bool isLoading = true;
  var carSeats;
  int bookedSeatsCount = 0;
  int availableSeatsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCarSeats();
  }

  Future<void> _loadCarSeats() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get car seats from repository
      carSeats = await _carRepository.getCarSeats(widget.car.id);

      // Calculate actual booked and available seats
      if (carSeats != null && carSeats.seatsList != null) {
        int bookedCount = 0;
        for (var seat in carSeats.seatsList) {
          if (seat.isBooked) {
            bookedCount++;
          }
        }

        // Update the car with actual counts
        bookedSeatsCount = bookedCount;
        availableSeatsCount = carSeats.seatsList.length - bookedCount;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading car seats: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total seats
    final int totalSeats =
        isLoading || carSeats == null || carSeats.seatsList == null
            ? widget.car.seatNumbers // Fall back to model data when loading
            : carSeats.seatsList.length; // Use actual data when available

    // Calculate seat status percentages using the actual loaded data
    final double bookedPercentage = totalSeats > 0
        ? (bookedSeatsCount / totalSeats) * 100 // Use the calculated count
        : 0;

    final double availablePercentage =
        totalSeats > 0 ? (availableSeatsCount / totalSeats) * 100 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Seat Capacity',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Text(
              isLoading ? 'Loading...' : '$totalSeats seats',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Seat availability bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: Stack(
            children: [
              // Background (total seats)
              Container(
                height: 8.h,
                width: double.infinity,
                color: Colors.grey[200],
              ),

              // Booked seats
              Row(
                children: [
                  Container(
                    height: 8.h,
                    width: isLoading
                        ? 0
                        : (bookedPercentage / 100) *
                            MediaQuery.of(context).size.width *
                            0.7,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // Legend and counts - Updated to use the calculated values
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Booked: ${isLoading ? "..." : bookedSeatsCount}', // Use the calculated count
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Available: ${isLoading ? "..." : availableSeatsCount}', // Use the calculated count
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Text(
              isLoading
                  ? '...'
                  : '${bookedPercentage.toStringAsFixed(0)}% booked',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: bookedPercentage > 80 ? Colors.red : Colors.grey[700],
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),

        // Visual seat representation
        Text(
          'Seat Map',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),

        SizedBox(height: 12.h),

        // Seat legends
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildSeatLegendItem('Available', Colors.white, Colors.grey),
            SizedBox(width: 16.w),
            _buildSeatLegendItem('Booked', Colors.red.shade100, Colors.red),
          ],
        ),

        SizedBox(height: 12.h),

        // Seat grid
        isLoading
            ? Center(
                child: SizedBox(
                  height: 100.h,
                  child: const CircularProgressIndicator(),
                ),
              )
            : carSeats == null
                ? Center(
                    child: Text(
                      'No seat information available',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                      childAspectRatio: 1,
                    ),
                    itemCount: carSeats.seatsList.length > 24
                        ? 24
                        : carSeats.seatsList.length,
                    itemBuilder: (context, index) {
                      final seat = carSeats.seatsList[index];
                      return _buildSeatItem(seat.seatNumber, seat.isBooked);
                    },
                  ),

        if (carSeats != null && carSeats.seatsList.length > 24)
          Center(
            child: TextButton(
              onPressed: () {
                // Show full seat map
                _showFullSeatMap(context);
              },
              child: Text(
                'View all ${carSeats.seatsList.length} seats',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSeatLegendItem(
      String label, Color fillColor, Color borderColor) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildSeatItem(String number, bool isBooked) {
    return Container(
      decoration: BoxDecoration(
        color: isBooked ? Colors.red.shade100 : Colors.white,
        border: Border.all(
          color: isBooked ? Colors.red : Colors.grey,
        ),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: isBooked ? FontWeight.bold : FontWeight.normal,
            color: isBooked ? Colors.red.shade900 : Colors.black87,
          ),
        ),
      ),
    );
  }

  void _showFullSeatMap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Full Seat Map',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                constraints: BoxConstraints(maxHeight: 400.h),
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                      childAspectRatio: 1,
                    ),
                    itemCount: carSeats.seatsList.length,
                    itemBuilder: (context, index) {
                      final seat = carSeats.seatsList[index];
                      return _buildSeatItem(seat.seatNumber, seat.isBooked);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
