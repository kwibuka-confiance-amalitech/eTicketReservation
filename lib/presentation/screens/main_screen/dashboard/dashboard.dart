import 'package:animations/animations.dart';
import 'package:car_ticket/controller/dashboard/activity_log_controller.dart';
import 'package:car_ticket/controller/dashboard/customers.dart';
import 'package:car_ticket/domain/models/activity/activity_log.dart';
import 'package:car_ticket/presentation/screens/auth/auth_screen.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/report/report_screen.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/users.dart';
import 'package:car_ticket/presentation/screens/setting_screens/edit_profile.dart';
import 'package:car_ticket/presentation/widgets/dashboard/main_card.dart';
import 'package:car_ticket/presentation/widgets/dashboard/main_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CarTicketDashboard extends StatelessWidget {
  static const String routeName = '/dashboard';
  const CarTicketDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: _buildEnhancedDrawer(context),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/excel_coaster.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8.w),
            Text(
              "Excel Tours",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Show notifications
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Text(
                "A",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final controller = Get.find<CustomersController>();
          controller.getCustomers();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MainCard(),
              _buildSectionTitle("Quick Actions"),
              _buildDashboardItems(context),
              // _buildSectionTitle("Recent Activity"),
              _buildActivityTimeline(context),
              _buildSectionTitle("Recent Customers"),
              _buildCustomersList(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      floatingActionButton: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (context, _) => DashboardReportScreen(),
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(56 / 2)),
        ),
        closedColor: Theme.of(context).primaryColor,
        closedBuilder: (context, openContainer) => FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: openContainer,
          child: const Icon(Icons.analytics, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEnhancedDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorDark,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? 'Excel Tours',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                user?.email ?? 'admin@exceltours.com',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "ADMIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    isSelected: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(UserProfileScreen.routeName);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.bar_chart,
                    title: 'Reports',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(DashboardReportScreen.routeName);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.calendar_today,
                    title: 'Bookings',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to bookings
                    },
                  ),
                  // const Divider(),
                  // _buildDrawerItem(
                  //   context,
                  //   icon: Icons.settings,
                  //   title: 'Settings',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     // Navigate to settings
                  //   },
                  // ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: _buildDrawerItem(
                context,
                icon: Icons.exit_to_app,
                title: 'Logout',
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Function() onTap,
    Color iconColor = Colors.grey,
    Color textColor = Colors.black87,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Theme.of(context).primaryColor : iconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDashboardItems(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.9,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: DashboardItemsList.dashboardItemsList.length,
        itemBuilder: (context, index) {
          final item = DashboardItemsList.dashboardItemsList[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Get.toNamed(item.routeName),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      color: item.color,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityTimeline(BuildContext context) {
    return GetBuilder<ActivityLogController>(
      init: ActivityLogController(),
      builder: (controller) {
        if (controller.isLoading) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: const CircularProgressIndicator(),
            ),
          );
        }

        // if (controller.activityLogs.isEmpty) {
        //   return _buildEmptyActivityState();
        // }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: controller.activityLogs
                .take(5) // Show only the latest 5 activities
                .map((activity) => _buildActivityItem(activity))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyActivityState() {
    return Container(
      padding: EdgeInsets.all(24.w),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.timeline_outlined,
            size: 48.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            "No recent activity",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Activity from users and system will appear here",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityLog activity) {
    // Determine icon and color based on activity type
    IconData activityIcon = Icons.info;
    Color activityColor = Colors.blue;

    switch (activity.type.toLowerCase()) {
      case 'car':
      case 'vehicle':
        activityIcon = Icons.directions_car;
        activityColor = Colors.blue;
        break;
      case 'user':
      case 'customer':
        activityIcon = Icons.person;
        activityColor = Colors.green;
        break;
      case 'booking':
      case 'ticket':
        activityIcon = Icons.confirmation_number;
        activityColor = Colors.orange;
        break;
      case 'payment':
        activityIcon = Icons.payment;
        activityColor = Colors.purple;
        break;
      case 'driver':
        activityIcon = Icons.person_pin;
        activityColor = Colors.brown;
        break;
      case 'destination':
      case 'route':
        activityIcon = Icons.map;
        activityColor = Colors.teal;
        break;
      default:
        activityIcon = Icons.info;
        activityColor = Colors.blue;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activityColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activityIcon,
              color: activityColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatTimeAgo(activity.timestamp),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  activity.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()} month(s) ago";
    } else if (difference.inDays > 0) {
      return difference.inDays == 1
          ? "Yesterday"
          : "${difference.inDays} days ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hour(s) ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minute(s) ago";
    } else {
      return "Just now";
    }
  }

  Widget _buildCustomersList() {
    return GetBuilder(
      init: CustomersController(),
      builder: (CustomersController customersController) {
        if (customersController.isGettingCustomers) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (customersController.customers.isEmpty) {
          return _buildEmptyCustomersList();
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              ...customersController.customers
                  .take(3)
                  .map((customer) => EnhancedCustomerItem(customer: customer)),
              SizedBox(height: 10.h),
              if (customersController.customers.length > 3)
                OutlinedButton(
                  onPressed: () {
                    // Navigate to all customers view
                    Get.toNamed(UsersScreen.routeName);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 45.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("View All Customers"),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyCustomersList() {
    return Container(
      padding: EdgeInsets.all(30.w),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 60.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            "No customers yet",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Your customer list will appear here once users register for your service",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                  Get.offAllNamed(AuthScreen.routeName);
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error logging out: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class EnhancedCustomerItem extends StatelessWidget {
  final dynamic customer;

  const EnhancedCustomerItem({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a random color based on the name
    final int nameHash = customer.name.hashCode;
    final List<Color> avatarColors = [
      Colors.blue.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
      Colors.orange.shade400,
      Colors.pink.shade400,
      Colors.indigo.shade400,
    ];
    final Color avatarColor =
        avatarColors[nameHash.abs() % avatarColors.length];

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: avatarColor,
              child: Text(
                customer.name.isNotEmpty
                    ? customer.name.substring(0, 1).toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    customer.email,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Active',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
