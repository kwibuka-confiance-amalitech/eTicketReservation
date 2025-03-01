import 'package:car_ticket/controller/dashboard/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MembersReportTab extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const MembersReportTab({
    required this.startDate,
    required this.endDate,
    super.key,
  });

  @override
  State<MembersReportTab> createState() => _MembersReportTabState();
}

class _MembersReportTabState extends State<MembersReportTab> {
  late ReportController controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ReportController>();

    // Use a post-frame callback to fetch data after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        controller.getMembersReportData(widget.startDate, widget.endDate);
        _isInitialized = true;
      }
    });
  }

  @override
  void didUpdateWidget(MembersReportTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fetch new data if date range changes
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      controller.getMembersReportData(widget.startDate, widget.endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      init: null, // We already initialized in initState
      builder: (controller) {
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
                    '${DateFormat('MMM dd, yyyy').format(widget.startDate)} - ${DateFormat('MMM dd, yyyy').format(widget.endDate)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Summary card
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.people,
                          color: Colors.blue,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Members',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              controller.isLoadingMembers
                                  ? '...'
                                  : controller.membersData.length.toString(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
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
              child: controller.isLoadingMembers
                  ? const Center(child: CircularProgressIndicator())
                  : controller.membersData.isEmpty
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
                                          'Name',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Email',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Join Date',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Bookings',
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
                                ...controller.membersData.map(
                                  (member) => Container(
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
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 14.r,
                                                backgroundColor: Colors.blue,
                                                child: Text(
                                                  member.name.isNotEmpty
                                                      ? member.name[0]
                                                      : '?',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  member.name.isNotEmpty
                                                      ? member.name
                                                      : 'Unknown',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 14.sp),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            member.email,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            _formatDate(member.createdAt),
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            (member.bookingsCount ?? 0)
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No members data available',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'There are no new members registered\nwithin the selected date range',
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
