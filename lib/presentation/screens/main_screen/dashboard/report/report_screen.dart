import 'package:flutter/material.dart';

class DashboardReportScreen extends StatelessWidget {
  static const String routeName = '/dashboard-report';
  const DashboardReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: Container(
        child: const Center(
          child: Text('Dashboard Report Screen'),
        ),
      ),
    );
  }
}
