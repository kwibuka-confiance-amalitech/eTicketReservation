import 'package:car_ticket/presentation/screens/main_screen/dashboard/report/earnings_report_tab.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/report/members_report_tab.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DashboardReportScreen extends StatefulWidget {
  static const String routeName = '/dashboard-report';
  const DashboardReportScreen({super.key});

  @override
  State<DashboardReportScreen> createState() => _DashboardReportScreenState();
}

class _DashboardReportScreenState extends State<DashboardReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Earnings Report'),
            Tab(text: 'Members Report'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showDateRangePicker(context),
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _generatePDF(context),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          EarningsReportTab(startDate: _startDate, endDate: _endDate),
          MembersReportTab(startDate: _startDate, endDate: _endDate),
        ],
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _generatePDF(BuildContext context) async {
    final pdf = pw.Document();

    final currentTab = _tabController.index == 0 ? 'Earnings' : 'Members';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('$currentTab Report'),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                  'Date Range: ${DateFormat('MMM dd, yyyy').format(_startDate)} to ${DateFormat('MMM dd, yyyy').format(_endDate)}'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: _tabController.index == 0
                    ? ['Date', 'Bookings', 'Revenue', 'Avg. Booking Value']
                    : ['Name', 'Email', 'Join Date', 'Total Bookings'],
                data: _tabController.index == 0
                    ? [
                        ['Feb 20, 2025', '12', 'RWF 240,000', 'RWF 20,000'],
                        ['Feb 21, 2025', '8', 'RWF 160,000', 'RWF 20,000'],
                        ['Feb 22, 2025', '15', 'RWF 300,000', 'RWF 20,000'],
                      ]
                    : [
                        [
                          'James Smith',
                          'james@example.com',
                          'Jan 15, 2025',
                          '5'
                        ],
                        [
                          'Mary Johnson',
                          'mary@example.com',
                          'Jan 20, 2025',
                          '3'
                        ],
                        [
                          'Robert Brown',
                          'robert@example.com',
                          'Jan 25, 2025',
                          '7'
                        ],
                      ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(),
        filename:
            '${currentTab.toLowerCase()}_report_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf');
  }
}
