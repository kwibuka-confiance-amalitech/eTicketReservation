import 'package:car_ticket/controller/payments/dashboard_payment.dart';
import 'package:car_ticket/domain/models/payment/customer_payment.dart';
import 'package:car_ticket/presentation/screens/setting_screens/my_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentsScreen extends StatelessWidget {
  static const String routeName = 'dashboard/payments';
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<DashboardPaymentController>(
        init: DashboardPaymentController(),
        builder: (controller) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, controller),
              _buildPaymentStats(context, controller),
              _buildPaymentsList(controller),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(
      BuildContext context, DashboardPaymentController controller) {
    final formatter = NumberFormat("#,###");
    final formattedAmount = formatter.format(controller.totalAmount);

    return SliverAppBar(
      expandedHeight: 280.h,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                right: -30.w,
                top: 50.h,
                child: CircleAvatar(
                  radius: 100.r,
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),
              Positioned(
                left: -50.w,
                bottom: -20.h,
                child: CircleAvatar(
                  radius: 80.r,
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
              ),

              // Content
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Total Revenue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RWF',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            formattedAmount,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.green[300],
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '12.8% from last month',
                              style: TextStyle(
                                color: Colors.green[300],
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
    );
  }

  // Simplified version using controller methods
  Widget _buildPaymentStats(
      BuildContext context, DashboardPaymentController controller) {
    // Format the amounts
    final formatter = NumberFormat("#,###");
    final formattedTodayRevenue = formatter.format(controller.todayRevenue);
    final formattedWeekRevenue = formatter.format(controller.weekRevenue);

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(16.w),
        child: Row(
          children: [
            _buildStatCard(
              context,
              title: 'Today',
              value: 'RWF $formattedTodayRevenue',
              icon: Icons.today,
              color: Colors.blue,
            ),
            SizedBox(width: 16.w),
            _buildStatCard(
              context,
              title: 'This Week',
              value: 'RWF $formattedWeekRevenue',
              icon: Icons.calendar_today,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
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
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentsList(DashboardPaymentController controller) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Payments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Add view all functionality
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (controller.isGettingUserPayments)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (controller.userPayments.isEmpty)
              _buildEmptyState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.userPayments.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return PaymentHistoryItem(
                    userPayment: controller.userPayments[index],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payment_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Payments Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your payment history will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTodayRevenue(List<UserPayment> payments) {
    if (payments.isEmpty) return 0;

    // Get today's date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Filter payments made today and sum their amounts
    final todayPayments = payments.where((payment) {
      DateTime paymentDate;
      try {
        // Try to parse the payment date
        paymentDate = DateTime.parse(payment.paymentDate);
      } catch (e) {
        return false;
      }

      // Check if the payment date is today
      final paymentDay =
          DateTime(paymentDate.year, paymentDate.month, paymentDate.day);
      return paymentDay.isAtSameMomentAs(today);
    });

    // Calculate total revenue
    int totalRevenue = 0;
    for (var payment in todayPayments) {
      try {
        totalRevenue += int.parse(payment.paymentAmount);
      } catch (e) {
        // Handle parsing error
        continue;
      }
    }

    return totalRevenue;
  }

  int _calculateWeekRevenue(List<UserPayment> payments) {
    if (payments.isEmpty) return 0;

    // Get dates for this week (starting from Monday)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Calculate the start of the week (Monday)
    final daysToSubtract = now.weekday - 1; // 1 is Monday in DateTime.weekday
    final startOfWeek = today.subtract(Duration(days: daysToSubtract));

    // Filter payments made this week and sum their amounts
    final weekPayments = payments.where((payment) {
      DateTime paymentDate;
      try {
        // Try to parse the payment date
        paymentDate = DateTime.parse(payment.paymentDate);
      } catch (e) {
        return false;
      }

      // Check if the payment date is from this week
      final paymentDay =
          DateTime(paymentDate.year, paymentDate.month, paymentDate.day);
      return paymentDay.isAtSameMomentAs(today) ||
          (paymentDay.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              paymentDay.isBefore(today.add(const Duration(days: 1))));
    });

    // Calculate total revenue
    int totalRevenue = 0;
    for (var payment in weekPayments) {
      try {
        totalRevenue += int.parse(payment.paymentAmount);
      } catch (e) {
        // Handle parsing error
        continue;
      }
    }

    return totalRevenue;
  }
}
