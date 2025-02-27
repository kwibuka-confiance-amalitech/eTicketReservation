import 'dart:math' as math;

import 'package:car_ticket/controller/dashboard/dashboard_stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainCard extends StatefulWidget {
  const MainCard({super.key});

  @override
  State<MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<MainCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardStatsController>(
      init: DashboardStatsController(),
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.all(16),
          height: 180,
          child: Stack(
            children: [
              // Main Card with Gradient
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark,
                      const Color(0xFF3949AB),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),

              // Decorative Circles
              Positioned(
                top: -20,
                right: -20,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animationController.value * 2 * math.pi,
                      child: child,
                    );
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: -30,
                left: 20,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "DASHBOARD",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "ADMIN",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Main Content
                    const Text(
                      "All your car ticket information in one place",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Stats
                    Row(
                      children: [
                        _buildStatItem(
                          Icons.confirmation_number_outlined,
                          controller.isLoading
                              ? "..."
                              : _formatNumber(controller.ticketCount),
                          "Tickets Sold",
                          controller.isLoading,
                        ),
                        const SizedBox(width: 20),
                        _buildStatItem(
                          Icons.directions_car_outlined,
                          controller.isLoading
                              ? "..."
                              : _formatNumber(controller.availableCars),
                          "Available Cars",
                          controller.isLoading,
                        ),
                        const SizedBox(width: 20),
                        _buildStatItem(
                          Icons.people_outline,
                          controller.isLoading
                              ? "..."
                              : _formatNumber(controller.userCount),
                          "Active Users",
                          controller.isLoading,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  Widget _buildStatItem(
      IconData icon, String value, String label, bool isLoading) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                isLoading
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
              ],
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
