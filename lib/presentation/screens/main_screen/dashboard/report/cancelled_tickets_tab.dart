import 'package:car_ticket/controller/dashboard/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CancelledTicketsTab extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const CancelledTicketsTab({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      builder: (controller) {
        if (controller.isLoadingEarnings) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              Row(
                children: [
                  _buildSummaryCard(
                    'Total Cancelled',
                    controller.totalCancelledTickets.toString(),
                    Icons.cancel_outlined,
                    Colors.red,
                  ),
                  SizedBox(width: 16),
                  _buildSummaryCard(
                    'Total Amount',
                    'RWF ${NumberFormat("#,###").format(controller.totalCancelledAmount)}',
                    Icons.money_off,
                    Colors.orange,
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Cancellations Table
              Card(
                elevation: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width -
                          32, // Account for padding
                      maxWidth: 1200, // Maximum table width
                    ),
                    child: DataTable(
                      headingRowHeight: 50,
                      dataRowHeight:
                          70, // Increased to accommodate multiple lines
                      horizontalMargin: 20,
                      columnSpacing: 24,
                      headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: 100, // Fixed width for date
                            child: Text(
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 250, // Increased width for route
                            child: Text(
                              'Route',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 150, // Increased width for car plate
                            child: Text(
                              'Car Plate',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 200, // Fixed width for customer
                            child: Text(
                              'Customer',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 120, // Fixed width for amount
                            child: Text(
                              'Amount',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                      // Update the DataCell containers in the rows
                      rows: controller.cancelledTicketsData.map((entry) {
                        return DataRow(
                          cells: [
                            // Date Cell
                            DataCell(
                              SizedBox(
                                width: 100,
                                child: Text(
                                  entry['date'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            // Route Cell
                            DataCell(
                              SizedBox(
                                width: 250,
                                child: _buildListCell(
                                  entry['destination']?.toString().split(',') ??
                                      ['Unknown Route'],
                                  Colors.blue[700]!,
                                ),
                              ),
                            ),
                            // Car Plate Cell
                            DataCell(
                              SizedBox(
                                width: 150,
                                child: _buildListCell(
                                  entry['carPlate']?.toString().split(',') ??
                                      ['Unknown'],
                                  Colors.purple[700]!,
                                ),
                              ),
                            ),
                            // Customer Cell
                            DataCell(
                              SizedBox(
                                width: 200,
                                child: _buildListCell(
                                  entry['customerName']
                                          ?.toString()
                                          .split(',') ??
                                      ['Unknown'],
                                  Colors.black87,
                                ),
                              ),
                            ),
                            // Amount Cell
                            DataCell(
                              SizedBox(
                                width: 120,
                                child: Text(
                                  entry['amount'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add this helper method to the CancelledTicketsTab class
  Widget _buildListCell(List<String> items, Color textColor) {
    return Tooltip(
      message: items.join('\n'),
      child: items.length > 1
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: items.take(3).map((item) {
                    return Text(
                      '• ${item.trim()}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: textColor,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  }).toList() +
                  (items.length > 3
                      ? [
                          Text(
                            '  +${items.length - 3} more...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ]
                      : []),
            )
          : Text(
              items.first.trim(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
    );
  }

  // Update the PDF generation part in CancelledTicketsTab class
  Future<void> generatePDF(
      BuildContext context, ReportController controller) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          // Title
          pw.Header(
            level: 0,
            child: pw.Text('Cancelled Tickets Report',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),

          // Summary section
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildPDFSummaryBox(
                'Total Cancelled Tickets',
                controller.totalCancelledTickets.toString(),
              ),
              _buildPDFSummaryBox(
                'Total Amount',
                'RWF ${NumberFormat("#,###").format(controller.totalCancelledAmount)}',
              ),
            ],
          ),
          pw.SizedBox(height: 20),

          // Table - Updated to match screen layout
          pw.Table.fromTextArray(
            context: context,
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft, // Date
              1: pw.Alignment.centerLeft, // Route
              2: pw.Alignment.centerLeft, // Car Plate
              3: pw.Alignment.centerLeft, // Customer
              4: pw.Alignment.centerRight, // Amount
            },
            headers: ['Date', 'Route', 'Car Plate', 'Customer', 'Amount'],
            data: controller.cancelledTicketsData.map((entry) {
              return [
                entry['date'],
                entry['destination']?.toString() ?? 'Unknown Route',
                entry['carPlate']?.toString() ?? 'Unknown',
                entry['customerName']?.toString() ?? 'Unknown',
                entry['amount'],
              ];
            }).toList(),
          ),
        ],
      ),
    );

    // Save PDF
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'cancelled_tickets_report.pdf',
    );
  }

  // Helper method for PDF summary boxes
  pw.Widget _buildPDFSummaryBox(String title, String value) {
    return pw.Container(
      padding: pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title,
              style: pw.TextStyle(
                color: PdfColors.grey700,
                fontSize: 12,
              )),
          pw.SizedBox(height: 5),
          pw.Text(value,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
