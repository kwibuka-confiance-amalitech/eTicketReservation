import 'package:car_ticket/controller/payments/user_payment.dart';
import 'package:car_ticket/domain/models/payment/customer_payment.dart';
import 'package:car_ticket/presentation/widgets/common/refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class MyPayments extends StatelessWidget {
  static const String routeName = '/my-payments';
  const MyPayments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Payment History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          GetBuilder<UserPaymentController>(builder: (userPaymentController) {
            return RefreshButton(
              isLoading: userPaymentController.isGettingUserPayments,
              onRefresh: () => userPaymentController.getCustomerPayments(),
            );
          }),
          SizedBox(width: 8.w),
        ],
      ),
      body: GetBuilder(
        init: UserPaymentController(),
        builder: (UserPaymentController userPaymentController) {
          if (userPaymentController.isGettingUserPayments) {
            return _buildLoadingState();
          } else if (userPaymentController.userPayments.isEmpty) {
            return _buildEmptyState(context);
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await userPaymentController.getCustomerPayments();
              },
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildPaymentSummary(userPaymentController, context),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Export functionality
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Export'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ...userPaymentController.userPayments.map(
                    (payment) => PaymentHistoryItem(userPayment: payment),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 16.h),
          Text(
            'Loading payment history...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long,
              size: 64.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Payment History',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              'You haven\'t made any payments yet. Your payment history will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Go to Home',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(
      UserPaymentController controller, BuildContext context) {
    // Calculate total spent
    final totalSpent = controller.userPayments.fold<double>(
      0,
      (sum, payment) => sum + (int.parse(payment.paymentAmount) ?? 0),
    );

    final formatter = NumberFormat("#,###");

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Spent',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'RWF ${formatter.format(totalSpent)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              _buildMiniStat(
                'Transactions',
                '${controller.userPayments.length}',
                Icons.swap_horiz,
                context,
              ),
              SizedBox(width: 16.w),
              _buildMiniStat(
                'Last Payment',
                _formatLastPaymentDate(controller),
                Icons.calendar_today,
                context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(
      String label, String value, IconData icon, BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: Colors.white,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastPaymentDate(UserPaymentController controller) {
    if (controller.userPayments.isEmpty) return 'N/A';

    // Sort payments by date and get most recent
    final sortedPayments = List.from(controller.userPayments)
      ..sort((a, b) {
        final dateA = a.paymentDate is DateTime
            ? a.paymentDate
            : DateTime.parse(a.paymentDate.toString());
        final dateB = b.paymentDate is DateTime
            ? b.paymentDate
            : DateTime.parse(b.paymentDate.toString());
        return dateB.compareTo(dateA);
      });

    final latestPayment = sortedPayments.first;
    final date = latestPayment.paymentDate is DateTime
        ? latestPayment.paymentDate
        : DateTime.parse(latestPayment.paymentDate.toString());

    return DateFormat('MMM dd').format(date);
  }
}

class PaymentHistoryItem extends StatelessWidget {
  final UserPayment userPayment;
  const PaymentHistoryItem({required this.userPayment, super.key});

  @override
  Widget build(BuildContext context) {
    // Determine status color
    Color statusColor;
    IconData statusIcon;

    switch (userPayment.paymentStatus.toLowerCase()) {
      case 'completed':
      case 'success':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
      case 'processing':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'failed':
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = Icons.info;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: () {
            // Show payment details
            _showPaymentDetails(context);
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side with icon
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: Theme.of(context).primaryColor,
                    size: 24.sp,
                  ),
                ),

                SizedBox(width: 16.w),

                // Middle with description and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userPayment.paymentDescription,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      // New implementation with Wrap instead of Row to handle overflow
                      Wrap(
                        spacing: 8.w, // horizontal space between items
                        runSpacing: 4.h, // vertical space between lines
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Status with icon
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                size: 14.sp,
                                color: statusColor,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                userPayment.paymentStatus,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          // Small separator dot
                          Container(
                            width: 4.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Date with icon
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14.sp,
                                color: Colors.grey[500],
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                _formatDate(userPayment.paymentDate),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right side with amount
                Text(
                  "RWF ${_formatNumber(userPayment.paymentAmount)}",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return DateFormat('MMM dd, yyyy').format(date);
    } else if (date is String) {
      try {
        final parsedDate = DateTime.parse(date);
        return DateFormat('MMM dd, yyyy').format(parsedDate);
      } catch (e) {
        return date.toString();
      }
    }
    return date.toString();
  }

  String _formatNumber(dynamic amount) {
    if (amount is num) {
      final formatter = NumberFormat("#,###");
      return formatter.format(amount);
    }
    return amount.toString();
  }

  void _showPaymentDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Receipt icon
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt,
                color: Theme.of(context).primaryColor,
                size: 36.sp,
              ),
            ),
            SizedBox(height: 16.h),

            Text(
              "Payment Details",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),

            // Payment info
            _buildDetailRow("Amount",
                "RWF ${_formatNumber(userPayment.paymentAmount)}", context),
            _buildDetailRow("Status", userPayment.paymentStatus, context),
            _buildDetailRow(
                "Date", _formatDate(userPayment.paymentDate), context),
            _buildDetailRow(
                "Description", userPayment.paymentDescription, context),
            _buildDetailRow("Customer", userPayment.customerName, context),

            SizedBox(height: 24.h),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
