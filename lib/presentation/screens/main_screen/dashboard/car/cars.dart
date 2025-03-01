import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/car/add_car.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/car/assign_driver.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/car/edit_car.dart';
import 'package:car_ticket/presentation/widgets/dashboard/car_seat_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class CarsScreen extends StatefulWidget {
  static const String routeName = '/cars';
  const CarsScreen({super.key});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<CarController>().getCars();
        },
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildSearchBar(),
            // _buildCategoryFilter(),
            // _buildStatCards(),
            _buildCarsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCarSheet(context),
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add New Car', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220.h,
      pinned: true,
      floating: false,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Decorative circular elements
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 150.w,
                  height: 150.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),

              // Content
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cars Management',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Manage your transportation vehicles efficiently',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GetBuilder<CarController>(
                        init: CarController(),
                        builder: (controller) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildAppBarStat(
                                'Total Cars',
                                '${controller.cars.length}',
                                Icons.directions_car,
                              ),
                              _buildAppBarStat(
                                'Available',
                                '${controller.cars.where((c) => !c.isAssigned).length}',
                                Icons.check_circle,
                              ),
                              _buildAppBarStat(
                                'In Use',
                                '${controller.cars.where((c) => c.isAssigned).length}',
                                Icons.people,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _buildAppBarStat(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18.sp),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
          decoration: InputDecoration(
            hintText: 'Search vehicles...',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15.h),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    List<String> categories = ['All', 'Sedan', 'SUV', 'Bus', 'Van', 'Coaster'];

    return SliverToBoxAdapter(
      child: Container(
        height: 50.h,
        margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            String category = categories[index];
            bool isSelected = _selectedCategory == category;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: isSelected
                      ? null
                      : Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCards() {
    return SliverToBoxAdapter(
      child: GetBuilder<CarController>(
        init: CarController(),
        builder: (controller) {
          // Calculate stats
          int totalCars = controller.cars.length;
          double avgCapacity = totalCars > 0
              ? controller.cars
                      .map((c) => c.seatNumbers)
                      .reduce((a, b) => a + b) /
                  totalCars
              : 0;

          // Calculate maintenance due cars
          int maintenanceDueSoon = controller.cars.where((c) {
            return c.nextMaintenance.difference(DateTime.now()).inDays <= 14;
          }).length;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                _buildStatCard(
                  context,
                  title: 'Average Capacity',
                  value: '${avgCapacity.toStringAsFixed(0)} seats',
                  icon: Icons.airline_seat_recline_normal,
                  iconColor: Colors.orange,
                  backgroundColor: Colors.orange.withOpacity(0.1),
                ),
                SizedBox(width: 16.w),
                _buildStatCard(
                  context,
                  title: 'Maintenance Due',
                  value: '$maintenanceDueSoon cars',
                  icon: Icons.build,
                  iconColor: Colors.red,
                  backgroundColor: Colors.red.withOpacity(0.1),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarsList() {
    return SliverToBoxAdapter(
      child: GetBuilder<CarController>(
        init: CarController(),
        builder: (controller) {
          if (controller.isGettingCars) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(30.h),
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          }

          if (controller.cars.isEmpty) {
            return _buildEmptyState();
          }

          // Apply filters
          var filteredCars = controller.cars;

          // Category filter
          if (_selectedCategory != 'All') {
            filteredCars = filteredCars
                .where((car) =>
                    car.type.toLowerCase() == _selectedCategory.toLowerCase())
                .toList();
          }

          // Search filter
          if (_searchQuery.isNotEmpty) {
            filteredCars = filteredCars
                .where((ExcelCar car) =>
                    car.name.toLowerCase().contains(_searchQuery) ||
                    car.model.toLowerCase().contains(_searchQuery) ||
                    car.plateNumber.toLowerCase().contains(_searchQuery))
                .toList();
          }

          if (filteredCars.isEmpty) {
            return _buildNoResultsState();
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(
                16.w, 16.h, 16.w, 80.h), // Bottom padding for FAB
            child: AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCars.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: EnhancedCarCard(
                          car: filteredCars[index],
                          onTap: () => _showCarDetailsBottomSheet(
                              context, filteredCars[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car_outlined,
                size: 60.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'No Vehicles Added Yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Add your first vehicle by tapping the + button',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => _showAddCarSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Vehicle'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No matching vehicles',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try different search terms or filters',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCarSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddCar(),
      ),
    );
  }

  void _showCarDetailsBottomSheet(BuildContext context, dynamic car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: CarDetailsView(car: car),
      ),
    );
  }
}

class EnhancedCarCard extends StatelessWidget {
  final ExcelCar car;
  final VoidCallback onTap;

  const EnhancedCarCard({
    super.key,
    required this.car,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAssigned = car.isAssigned;
    final Color cardColor = isAssigned ? Colors.orange : Colors.green;
    final IconData vehicleIcon = _getVehicleIconForType(car.type);

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Vehicle icon container (keep as is)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  vehicleIcon,
                  color: cardColor,
                  size: 30.sp,
                ),
              ),
              SizedBox(width: 16.w),

              // Vehicle details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vehicle name and status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          car.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: isAssigned
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isAssigned ? 'In Use' : 'Available',
                            style: TextStyle(
                              color: isAssigned ? Colors.orange : Colors.green,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Plate number and seats
                    Row(
                      children: [
                        _buildInfoChip(Icons.credit_card, car.plateNumber),
                        SizedBox(width: 8.w),
                        _buildInfoChip(Icons.airline_seat_recline_normal,
                            '${car.seatNumbers} seats'),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Model and year
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 14.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          car.model,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Icon(
                          Icons.calendar_today,
                          size: 14.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          car.year,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),

                    // Add driver information row if assigned
                    if (car.isAssigned && car.driverName.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Divider(height: 8.h, color: Colors.grey[200]),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 14.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Driver: ${car.driverName}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: Colors.grey[700],
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class CarDetailsView extends StatelessWidget {
  final ExcelCar car;

  const CarDetailsView({
    required this.car,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top drag handle
        Container(
          width: 40.w,
          height: 5.h,
          margin: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),

        // Main scrollable content
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle header info
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car name and basic info
                      Text(
                        car.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // License plate
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          car.plateNumber,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Vehicle details section
                      Text(
                        'Vehicle Information',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),

                // Vehicle details in a grid
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    children: [
                      _buildDetailItem(Icons.category, 'Type', car.type),
                      _buildDetailItem(Icons.palette, 'Color', car.color),
                      _buildDetailItem(Icons.car_repair, 'Model', car.model),
                      _buildDetailItem(Icons.calendar_today, 'Year', car.year),
                      _buildDetailItem(Icons.airline_seat_recline_normal,
                          'Seats', car.seatNumbers.toString()),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Driver info if assigned
                if (car.isAssigned && car.driverName.isNotEmpty)
                  _buildAssignedDriverSection(context),

                SizedBox(height: 24.h),

                // Seat status widget
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Card(
                    elevation: 0,
                    color: Colors.grey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: CarSeatStatusWidget(car: car),
                    ),
                  ),
                ),

                // Extra space at bottom to ensure everything is visible
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),

        // Action buttons in fixed position at bottom
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit and Delete buttons row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: EditCarWidget(car: car),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 18.sp,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Edit Vehicle',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.sp,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GetBuilder<CarController>(
                      builder: (carController) {
                        return OutlinedButton.icon(
                          onPressed: carController.isCarDeleting
                              ? null
                              : () {
                                  // Show confirmation dialog first
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Vehicle'),
                                      content: Text(
                                        'Are you sure you want to delete ${car.name}? This action cannot be undone.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(
                                                context); // Close dialog
                                            Navigator.pop(
                                                context); // Close details view
                                            await carController.deleteCar(car);
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                          icon: Icon(
                            Icons.delete,
                            size: 18.sp,
                            color: Colors.red,
                          ),
                          label: Text(
                            carController.isCarDeleting &&
                                    carController.deleteCarId == car.id
                                ? 'Deleting...'
                                : 'Delete Vehicle',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Driver assignment button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.75,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      builder: (context, scrollController) =>
                          AssignDriverSheet(car: car),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.person_add),
                label: Text(car.isAssigned ? 'Change Driver' : 'Assign Driver'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: Colors.grey[700]),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedDriverSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Driver',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Driver avatar
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  child: car.driverName.isNotEmpty
                      ? Text(
                          car.driverName[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 30.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                ),
                SizedBox(width: 16.w),
                // Driver details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.driverName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'Assigned Driver',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Change driver button
                IconButton(
                  icon: Icon(
                    Icons.swap_horiz,
                    color: Theme.of(context).primaryColor,
                  ),
                  tooltip: 'Change Driver',
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.75,
                        minChildSize: 0.5,
                        maxChildSize: 0.95,
                        builder: (context, scrollController) =>
                            AssignDriverSheet(car: car),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Unassign button
          SizedBox(height: 8.h),
          GetBuilder<CarController>(
            builder: (controller) {
              return OutlinedButton.icon(
                onPressed: controller.isAssigningDriver
                    ? null
                    : () {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Remove Driver'),
                            content: Text(
                              'Are you sure you want to unassign ${car.driverName} from this vehicle?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context); // Close dialog
                                  Navigator.pop(context); // Close details
                                  await controller.unAssignDriverToCar(
                                    carId: car.id,
                                  );
                                },
                                child: const Text(
                                  'Remove',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                icon: Icon(Icons.person_remove, color: Colors.red, size: 18.sp),
                label: Text(
                  'Unassign Driver',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoDriverSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Driver Assigned',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_off,
                    color: Colors.grey[500],
                    size: 30.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Driver',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Assign a driver to this vehicle',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Assign button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.75,
                        minChildSize: 0.5,
                        maxChildSize: 0.95,
                        builder: (context, scrollController) =>
                            AssignDriverSheet(car: car),
                      ),
                    );
                  },
                  icon: Icon(Icons.person_add, size: 16.sp),
                  label: Text('Assign'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Add this function at the end of the file, outside of any class
// or alternatively as a static method inside your EnhancedCarCard class
IconData _getVehicleIconForType(String type) {
  switch (type.toLowerCase()) {
    case 'bus':
      return Icons.directions_bus;
    case 'sedan':
      return Icons.directions_car;
    case 'suv':
      return Icons.time_to_leave;
    case 'van':
      return Icons.airport_shuttle;
    case 'coaster':
      return Icons.directions_bus_filled;
    case 'truck':
      return Icons.local_shipping;
    case 'minibus':
      return Icons.directions_transit;
    default:
      return Icons.directions_car;
  }
}
