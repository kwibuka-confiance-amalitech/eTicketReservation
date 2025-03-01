import 'package:car_ticket/controller/dashboard/report_controller.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/report/earnings_report_tab.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/report/members_report_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    // Make sure controller exists
    if (!Get.isRegistered<ReportController>()) {
      Get.put(ReportController());
    }

    // Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _refreshData(); // Load data when changing tabs
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshData() {
    final controller = Get.find<ReportController>();

    if (_tabController.index == 0) {
      controller.getEarningsReportData(_startDate, _endDate);
    } else {
      controller.getMembersReportData(_startDate, _endDate);
    }
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
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
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

      _refreshData();
    }
  }

  Future<void> _generatePDF(BuildContext context) async {
    final controller = Get.find<ReportController>();
    final pdf = pw.Document();

    final isEarningsReport = _tabController.index == 0;
    final reportTitle = isEarningsReport ? 'Earnings Report' : 'Members Report';

    // Create PDF content based on the active tab
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with logo and title
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      reportTitle,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'CarTicket',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Date range
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.grey200,
                child: pw.Row(
                  children: [
                    pw.Text('Date Range: '),
                    pw.Text(
                      '${DateFormat('MMM dd, yyyy').format(_startDate)} to ${DateFormat('MMM dd, yyyy').format(_endDate)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Summary section
              if (isEarningsReport) ...[
                pw.Text(
                  'Summary',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    _buildPdfSummaryItem(
                        'Total Bookings', controller.totalBookings.toString()),
                    pw.SizedBox(width: 20),
                    _buildPdfSummaryItem('Total Revenue',
                        'RWF ${NumberFormat("#,###").format(controller.totalRevenue)}'),
                    pw.SizedBox(width: 20),
                    _buildPdfSummaryItem('Average Booking',
                        'RWF ${NumberFormat("#,###").format(controller.averageBookingValue)}'),
                  ],
                ),
                pw.SizedBox(height: 20),
              ],

              pw.Text(
                'Detailed Report',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              // Table
              isEarningsReport
                  ? pw.Table.fromTextArray(
                      headers: [
                        'Date',
                        'Bookings',
                        'Revenue',
                        'Avg. Booking Value'
                      ],
                      data: controller.earningsData
                          .map((entry) => [
                                entry['date'],
                                entry['bookings'],
                                entry['revenue'],
                                entry['averageValue'],
                              ])
                          .toList(),
                      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      headerDecoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      cellAlignment: pw.Alignment.centerLeft,
                      cellAlignments: {0: pw.Alignment.centerLeft},
                    )
                  : pw.Table.fromTextArray(
                      headers: ['Name', 'Email', 'Join Date', 'Bookings'],
                      data: controller.membersData
                          .map((member) => [
                                member.name.isNotEmpty
                                    ? member.name
                                    : 'Unknown',
                                member.email,
                                _formatDate(member.createdAt),
                                (member.bookingsCount ?? 0).toString(),
                              ])
                          .toList(),
                      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      headerDecoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                    ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(),
        filename:
            '${reportTitle.toLowerCase().replaceAll(' ', '_')}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf');
  }

  pw.Widget _buildPdfSummaryItem(String label, String value) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                color: PdfColors.grey700,
                fontSize: 12,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';

    if (date is DateTime) {
      return DateFormat('MMM dd, yyyy').format(date);
    } else if (date is String) {
      try {
        final parsedDate = DateTime.parse(date);
        return DateFormat('MMM dd, yyyy').format(parsedDate);
      } catch (e) {
        return date;
      }
    }
    return 'N/A';
  }
}
