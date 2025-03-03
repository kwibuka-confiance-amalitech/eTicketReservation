import 'package:car_ticket/controller/dashboard/journey_destination_controller.dart';
import 'package:car_ticket/domain/models/destination/journey_destination.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/destination/add_destination.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/destination/edit_destination.dart';
import 'package:car_ticket/presentation/widgets/dashboard/assignings/assign_car_to_destination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class DestinationsScreen extends StatefulWidget {
  static const String routeName = '/destinations';
  const DestinationsScreen({super.key});

  @override
  State<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  String _selectedFilter = 'All';
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
          await Get.find<JourneyDestinationController>().getDestinations();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            _buildSearchBar(),
            _buildFilterChips(),
            _buildDestinationStats(),
            SliverPadding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 16.h,
                bottom: 80.h, // Space for FAB
              ),
              sliver: _buildDestinationsList(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddDestinationModal(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('New Route'),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220.h,
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
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                top: -20,
                right: -30,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  height: 80,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(100),
                    ),
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
                      Row(
                        children: [
                          // const BackButton(color: Colors.white),
                          const Expanded(child: SizedBox()),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications_outlined,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Travel Routes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Manage your journey destinations',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.map_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
            hintText: 'Search routes...',
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
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          children: [
            _buildFilterChip('All'),
            _buildFilterChip('Popular'),
            _buildFilterChip('New'),
            _buildFilterChip('With Cars'),
            _buildFilterChip('Without Cars'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final bool isSelected = _selectedFilter == filter;

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        label: Text(filter),
        selected: isSelected,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[800],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.grey[100],
        selectedColor: Theme.of(context).primaryColor,
        onSelected: (bool selected) {
          setState(() {
            _selectedFilter = filter;
          });
        },
      ),
    );
  }

  Widget _buildDestinationStats() {
    return SliverToBoxAdapter(
      child: GetBuilder<JourneyDestinationController>(
        init: JourneyDestinationController(),
        builder: (controller) {
          // Total routes count
          final int totalRoutes = controller.destinations.length;

          // Assigned routes count (with cars)
          final int assignedRoutes =
              controller.destinations.where((route) => route.isAssigned).length;

          // Routes available for today
          final int todayRoutes = controller.destinations
              .where((route) =>
                  route.startDate != null &&
                  DateFormat('yyyy-MM-dd').parse(route.startDate!).day ==
                      DateTime.now().day)
              .length;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                _buildStatCard(
                  context: context,
                  title: 'Total Routes',
                  value: totalRoutes.toString(),
                  iconData: Icons.route,
                  color: Colors.blue,
                ),
                SizedBox(width: 12.w),
                _buildStatCard(
                  context: context,
                  title: 'With Cars',
                  value: assignedRoutes.toString(),
                  iconData: Icons.directions_car,
                  color: Colors.green,
                ),
                SizedBox(width: 12.w),
                _buildStatCard(
                  context: context,
                  title: 'Today',
                  value: todayRoutes.toString(),
                  iconData: Icons.today,
                  color: Colors.orange,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData iconData,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                iconData,
                color: color,
                size: 20,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
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
    );
  }

  Widget _buildLoadingList() {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationsList(BuildContext context) {
    return GetBuilder<JourneyDestinationController>(
      init: JourneyDestinationController(),
      builder: (controller) {
        if (controller.isGettingDestinations) {
          return SliverToBoxAdapter(child: _buildLoadingList());
        }

        if (controller.destinations.isEmpty) {
          return SliverToBoxAdapter(child: _buildEmptyState());
        }

        // Apply filters if needed based on _selectedFilter and search
        var filteredDestinations = controller.destinations;

        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          filteredDestinations = filteredDestinations
              .where((destination) =>
                  destination.from.toLowerCase().contains(_searchQuery) ||
                  destination.to.toLowerCase().contains(_searchQuery) ||
                  destination.description
                      .toLowerCase()
                      .contains(_searchQuery) ||
                  destination.price.toLowerCase().contains(_searchQuery))
              .toList();
        }

        // Apply category filter
        switch (_selectedFilter) {
          case 'Popular':
            filteredDestinations.sort((a, b) => b.price.compareTo(a.price));
            break;
          case 'New':
            filteredDestinations.sort((a, b) => DateTime.parse(b.createdAt)
                .compareTo(DateTime.parse(a.createdAt)));
            break;
          case 'With Cars':
            filteredDestinations = filteredDestinations
                .where((destination) => destination.isAssigned)
                .toList();
            break;
          case 'Without Cars':
            filteredDestinations = filteredDestinations
                .where((destination) => !destination.isAssigned)
                .toList();
            break;
          default:
            // Keep all destinations
            break;
        }

        if (filteredDestinations.isEmpty) {
          return SliverToBoxAdapter(child: _buildNoResultsState());
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: DestinationCard(
                      destination: filteredDestinations[index],
                      onTap: () => _showDestinationDetails(
                          context, filteredDestinations[index]),
                    ),
                  ),
                ),
              );
            },
            childCount: filteredDestinations.length,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.route,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Routes Added Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add your first travel route by tapping the + button',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddDestinationModal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Add Route'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No routes found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term or filter',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDestinationModal(BuildContext context) {
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
        child: const AddDestination(),
      ),
    );
  }

  void _showDestinationDetails(
      BuildContext context, JourneyDestination destination) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: DestinationDetailsView(destination: destination),
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final JourneyDestination destination;
  final VoidCallback onTap;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a gradient color based on the destination's from and to locations
    final int nameHash = (destination.from + destination.to).hashCode;
    final List<List<Color>> gradients = [
      [Colors.blue.shade400, Colors.blue.shade700],
      [Colors.purple.shade400, Colors.purple.shade700],
      [Colors.teal.shade400, Colors.teal.shade600],
      [Colors.orange.shade400, Colors.deepOrange.shade600],
      [Colors.indigo.shade400, Colors.indigo.shade700],
    ];
    final List<Color> gradient = gradients[nameHash.abs() % gradients.length];

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 140.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Left color band with icon
              Container(
                width: 80.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradient,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.directions_bus_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      destination.duration,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    const Text(
                      'hours',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Route information
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.red),
                              SizedBox(width: 4.w),
                              Text(
                                "From: ${destination.from}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              const Icon(Icons.flag,
                                  size: 16, color: Colors.green),
                              SizedBox(width: 4.w),
                              Text(
                                "To: ${destination.to}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            destination.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13.sp,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.attach_money,
                                      color: Theme.of(context).primaryColor,
                                      size: 16),
                                  SizedBox(width: 4.w),
                                  Text(
                                    NumberFormat.currency(
                                      symbol: 'RWF ',
                                      decimalDigits: 0,
                                    ).format(double.parse(destination.price)),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: destination.isAssigned
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      destination.isAssigned
                                          ? Icons.check_circle
                                          : Icons.cancel_outlined,
                                      color: destination.isAssigned
                                          ? Colors.green
                                          : Colors.orange,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      destination.isAssigned
                                          ? 'Car Assigned'
                                          : 'No Car',
                                      style: TextStyle(
                                        color: destination.isAssigned
                                            ? Colors.green
                                            : Colors.orange,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Add the popup menu in the top-right corner
                    Positioned(
                      top: 0,
                      right: 0,
                      child: _buildPopupMenu(context),
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

  Widget _buildPopupMenu(BuildContext context) {
    return GetBuilder<JourneyDestinationController>(builder: (controller) {
      return PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey[700],
        ),
        onSelected: (value) {
          if (value == 'edit') {
            _showEditDestinationModal(context);
          } else if (value == 'delete') {
            _showDeleteConfirmation(context, controller);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 18),
                SizedBox(width: 8),
                Text('Edit Route'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red, size: 18),
                SizedBox(width: 8),
                Text('Delete Route', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      );
    });
  }

  void _showEditDestinationModal(BuildContext context) {
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
        child: EditDestinationWidget(destination: destination),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, JourneyDestinationController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Route'),
        content: Text(
            'Are you sure you want to delete "${destination.description}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteDestination(destination);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationDetailsView extends StatelessWidget {
  final JourneyDestination destination;

  const DestinationDetailsView({
    super.key,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Drag handle and actions row
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Drag handle
              Container(
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Action buttons
              Row(
                children: [
                  // Edit button
                  IconButton(
                    icon:
                        Icon(Icons.edit, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditDestinationModal(context);
                    },
                  ),

                  // Delete button
                  GetBuilder<JourneyDestinationController>(
                      builder: (controller) {
                    return IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteConfirmation(context, controller);
                      },
                    );
                  }),
                ],
              ),
            ],
          ),
        ),

        // Rest of the DestinationDetailsView remains the same...
        // Make the content scrollable
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Header with route visualization
                Container(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      // Route visualization
                      Row(
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.circle,
                                  color: Colors.red, size: 16),
                              Container(
                                width: 2,
                                height: 50.h,
                                color: Colors.grey[300],
                              ),
                              const Icon(Icons.location_on,
                                  color: Colors.green, size: 20),
                            ],
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination.from,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 16.h),
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.timer, size: 16),
                                          SizedBox(width: 4.w),
                                          Text(
                                            '${destination.duration} hrs',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Text('•'),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.route, size: 16),
                                          SizedBox(width: 4.w),
                                          const Text(
                                            'Direct',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  destination.to,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Price information
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ticket Price',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                symbol: 'RWF ',
                                decimalDigits: 0,
                              ).format(double.parse(destination.price)),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Description section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Route Description',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            destination.description,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Vehicle information (if assigned)
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: destination.isAssigned
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vehicle Information',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.directions_bus,
                                      color: Theme.of(context).primaryColor,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Car Plate ${destination.carId.substring(0, 10)}...',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Assigned on: ${(destination.startDate != null) ? DateFormat.yMMMd().format(DateTime.parse(destination.startDate!)) : 'N/A'}',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            'No vehicle assigned to this route',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),

        // Bottom button - outside of scrollable area
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -4),
                blurRadius: 8,
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAssignCarSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: destination.isAssigned
                    ? Colors.orange
                    : Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(
                destination.isAssigned
                    ? Icons.swap_horiz
                    : Icons.directions_car,
                color: Colors.white,
              ),
              label: Text(
                destination.isAssigned ? 'Change Vehicle' : 'Assign Vehicle',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditDestinationModal(BuildContext context) {
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
        child: EditDestinationWidget(destination: destination),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, JourneyDestinationController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Route'),
        content: Text(
            'Are you sure you want to delete "${destination.description}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteDestination(destination);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignCarSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => AssignCarSheet(
          destination: destination,
        ),
      ),
    );
  }
}
