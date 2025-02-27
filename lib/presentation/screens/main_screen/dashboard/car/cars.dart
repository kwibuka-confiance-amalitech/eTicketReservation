import 'package:car_ticket/controller/dashboard/car_controller.dart';
import 'package:car_ticket/domain/models/car/car.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/car/add_car.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/car/assign_driver.dart';
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
            _buildCategoryFilter(),
            _buildStatCards(),
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
                        'Vehicle Fleet',
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
    // Choose appropriate icon based on car type
    IconData vehicleIcon;
    switch (car.type.toLowerCase()) {
      case 'sedan':
        vehicleIcon = Icons.directions_car;
        break;
      case 'suv':
        vehicleIcon = Icons.directions_car;
        break;
      case 'bus':
        vehicleIcon = Icons.directions_bus;
        break;
      case 'van':
        vehicleIcon = Icons.airport_shuttle;
        break;
      case 'coaster':
        vehicleIcon = Icons.directions_bus;
        break;
      default:
        vehicleIcon = Icons.directions_car;
    }

    // Generate color based on car type for visual distinction
    final int typeHash = car.type.hashCode;
    final List<Color> cardColors = [
      Colors.blue.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
      Colors.orange.shade400,
      Colors.indigo.shade400,
    ];
    final Color cardColor = cardColors[typeHash.abs() % cardColors.length];
    final bool isAssigned = car.isAssigned;

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Row(
                      children: [
                        _buildInfoChip(Icons.credit_card, car.plateNumber),
                        SizedBox(width: 8.w),
                        _buildInfoChip(Icons.airline_seat_recline_normal,
                            '${car.seatNumbers} seats'),
                      ],
                    ),
                    SizedBox(height: 8.h),
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
                  ],
                ),
              ),
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
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    // Get next maintenance date in relative format
    String nextMaintenanceText = "Not scheduled";
    final daysUntil = car.nextMaintenance.difference(DateTime.now()).inDays;
    if (daysUntil < 0) {
      nextMaintenanceText = "Overdue by ${daysUntil.abs()} days";
    } else if (daysUntil == 0) {
      nextMaintenanceText = "Due today";
    } else if (daysUntil < 7) {
      nextMaintenanceText = "Due in $daysUntil days";
    } else if (daysUntil < 30) {
      nextMaintenanceText = "Due in ${(daysUntil / 7).floor()} weeks";
    } else {
      nextMaintenanceText = "Due in ${(daysUntil / 30).floor()} months";
    }

    return Column(
      children: [
        // Drag handle
        Container(
          width: 50.w,
          height: 5.h,
          margin: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // Car illustration
        Container(
          height: 120.h,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Center(
            child: Icon(
              _getCarIcon(car.type),
              size: 80.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),

        // Car details
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      car.name,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: car.isAssigned
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        car.isAssigned ? 'In Use' : 'Available',
                        style: TextStyle(
                          color: car.isAssigned ? Colors.orange : Colors.green,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${car.model} | ${car.year}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),
                Text(
                  'Vehicle Details',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),

                _buildDetailItem(
                  context,
                  icon: Icons.credit_card,
                  label: 'License Plate',
                  value: car.plateNumber,
                ),

                _buildDetailItem(
                  context,
                  icon: Icons.airline_seat_recline_normal,
                  label: 'Seating Capacity',
                  value: '${car.seatNumbers} passengers',
                ),

                _buildDetailItem(
                  context,
                  icon: Icons.speed,
                  label: 'Mileage',
                  value: '${car.mileage.toStringAsFixed(0)} km',
                ),

                _buildDetailItem(
                  context,
                  icon: Icons.build,
                  label: 'Next Maintenance',
                  value: nextMaintenanceText,
                ),

                if (car.isAssigned && car.driverName.isNotEmpty)
                  _buildDetailItem(
                    context,
                    icon: Icons.person,
                    label: 'Assigned Driver',
                    value: car.driverName,
                  ),

                SizedBox(height: 24.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
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
                        label: Text(
                            car.isAssigned ? 'Change Driver' : 'Assign Driver'),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Implement edit functionality
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Details'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCarIcon(String type) {
    switch (type.toLowerCase()) {
      case 'sedan':
        return Icons.directions_car;
      case 'suv':
        return Icons.directions_car;
      case 'bus':
        return Icons.directions_bus;
      case 'van':
        return Icons.airport_shuttle;
      case 'coaster':
        return Icons.directions_bus;
      default:
        return Icons.directions_car;
    }
  }
}
