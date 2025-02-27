import 'package:car_ticket/controller/dashboard/driver_controller.dart';
import 'package:car_ticket/domain/models/driver/driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:uuid/uuid.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({super.key});

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 2;
  String selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _totalPages, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
        _tabController.animateTo(_currentPage);
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
        _tabController.animateTo(_currentPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DriverController(),
      builder: (DriverController driverController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with drag handle
              _buildHeader(context),

              // Step indicator
              _buildStepIndicator(),

              // Form content
              Flexible(
                child: PageView(
                  controller: _pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable swiping
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                      _tabController.animateTo(page);
                    });
                  },
                  children: [
                    _buildPersonalInfoPage(driverController, context),
                    _buildProfessionalInfoPage(driverController, context),
                  ],
                ),
              ),

              // Navigation buttons
              _buildNavigationButtons(driverController, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.drive_eta_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "Add New Driver",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 3,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
        tabs: const [
          Tab(text: "Personal Info"),
          Tab(text: "Professional Details"),
        ],
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoPage(
      DriverController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Personal Information"),
            Gap(16.h),

            // First & Last name in one row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: controller.firstNameController,
                    label: "First Name",
                    hint: "John",
                    icon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildInputField(
                    controller: controller.lastNameController,
                    label: "Last Name",
                    hint: "Doe",
                    icon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            Gap(16.h),

            // Gender selection
            _buildSectionSubtitle("Gender"),
            SizedBox(height: 8.h),
            Row(
              children: [
                _buildGenderOption(
                  title: "Male",
                  icon: Icons.male,
                  isSelected: selectedGender == "Male",
                  onTap: () {
                    setState(() {
                      selectedGender = "Male";
                    });
                  },
                ),
                SizedBox(width: 16.w),
                _buildGenderOption(
                  title: "Female",
                  icon: Icons.female,
                  isSelected: selectedGender == "Female",
                  onTap: () {
                    setState(() {
                      selectedGender = "Female";
                    });
                  },
                ),
              ],
            ),
            Gap(16.h),

            // Contact information
            _buildSectionSubtitle("Contact Information"),
            Gap(8.h),
            _buildInputField(
              controller: controller.emailController,
              label: "Email Address",
              hint: "john.doe@example.com",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            Gap(16.h),
            _buildInputField(
              controller: controller.phoneController,
              label: "Phone Number",
              hint: "+1 234 567 890",
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            Gap(32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalInfoPage(
      DriverController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Professional Details"),
            Gap(16.h),

            // License information
            _buildInputField(
              controller: controller.driverLicenseCategoryController,
              label: "Driver License Category",
              hint: "A, B, C, D...",
              icon: Icons.card_membership_outlined,
              textInputAction: TextInputAction.next,
            ),
            Gap(16.h),

            // Location information
            _buildSectionSubtitle("Location Information"),
            Gap(8.h),
            _buildInputField(
              controller: controller.addressController,
              label: "Street Address",
              hint: "123 Main St",
              icon: Icons.location_on_outlined,
              textInputAction: TextInputAction.next,
            ),
            Gap(16.h),
            _buildInputField(
              controller: controller.cityController,
              label: "City",
              hint: "New York",
              icon: Icons.location_city_outlined,
              textInputAction: TextInputAction.done,
            ),
            Gap(32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(
      DriverController controller, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (hidden on first page)
          _currentPage > 0
              ? ElevatedButton.icon(
                  onPressed: _previousPage,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                )
              : const SizedBox(width: 100), // Placeholder for layout balance

          // Next/Submit button
          _currentPage < _totalPages - 1
              ? ElevatedButton.icon(
                  onPressed: _nextPage,
                  label: const Text("Next"),
                  icon: const Icon(Icons.arrow_forward),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: controller.isDriverCreating
                      ? null
                      : () {
                          const uuid = Uuid();
                          CarDriver driver = CarDriver(
                            id: uuid.v1(),
                            firstName: controller.firstNameController.text,
                            lastName: controller.lastNameController.text,
                            email: controller.emailController.text,
                            phone: controller.phoneController.text,
                            address: controller.addressController.text,
                            city: controller.cityController.text,
                            driverLicenseCategory:
                                controller.driverLicenseCategoryController.text,
                            isAssigned: false,
                            sexStatus: selectedGender,
                          );

                          if (controller.formKey.currentState?.validate() ??
                              true) {
                            controller.addDriver(driver);
                          }
                        },
                  label: Text(
                      controller.isDriverCreating ? "Adding..." : "Add Driver"),
                  icon: controller.isDriverCreating
                      ? Container(
                          width: 24.w,
                          height: 24.h,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.check_circle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextFormField(
            controller: controller,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade400,
                size: 32.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSectionSubtitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade700,
      ),
    );
  }
}
