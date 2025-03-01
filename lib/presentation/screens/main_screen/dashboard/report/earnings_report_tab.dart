import 'package:car_ticket/controller/dashboard/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EarningsReportTab extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const EarningsReportTab({
    required this.startDate,
    required this.endDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      init: Get.find<
          ReportController>(), // Use find instead of creating new controller
      builder: (controller) {
        // Check if data needs to be loaded
        if (!controller.isLoadingEarnings && controller.earningsData.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.getEarningsReportData(startDate, endDate);
          });
        }

        return Column(
          children: [
            // Date range info
            Container(
              padding: EdgeInsets.all(16.w),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Icon(Icons.date_range, color: Colors.grey[700]),
                  SizedBox(width: 10.w),
                  Text(
                    '${DateFormat('MMM dd, yyyy').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Summary cards
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  _buildSummaryCard(
                    context,
                    title: 'Total Bookings',
                    value: controller.isLoadingEarnings
                        ? '...'
                        : controller.totalBookings.toString(),
                    icon: Icons.confirmation_number,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 16.w),
                  _buildSummaryCard(
                    context,
                    title: 'Total Revenue',
                    value: controller.isLoadingEarnings
                        ? '...'
                        : 'RWF ${NumberFormat("#,###").format(controller.totalRevenue)}',
                    icon: Icons.monetization_on,
                    color: Colors.green,
                  ),
                ],
              ),
            ),

            // Average booking value
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.analytics,
                          color: Colors.purple,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Average Booking Value',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              controller.isLoadingEarnings
                                  ? '...'
                                  : 'RWF ${NumberFormat("#,###").format(controller.averageBookingValue)}',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Data table
            Expanded(
              child: controller.isLoadingEarnings
                  ? Center(child: CircularProgressIndicator())
                  : controller.earningsData.isEmpty
                      ? _buildEmptyState()
                      : Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Card(
                            elevation: 2,
                            child: ListView(
                              children: [
                                // Table header
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Date',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Bookings',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Revenue',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Avg. Value',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Table rows
                                ...controller.earningsData.map(
                                  (data) => Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 16.h),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            data['date'] as String,
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            data['bookings'] as String,
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            data['revenue'] as String,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            data['averageValue'] as String,
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No earnings data available',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'There are no bookings within the selected date range',
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
}
