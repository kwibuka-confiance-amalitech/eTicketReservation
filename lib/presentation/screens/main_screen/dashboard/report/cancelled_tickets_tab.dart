import 'package:car_ticket/controller/dashboard/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
                  child: DataTable(
                    headingRowHeight: 50,
                    dataRowHeight: 56,
                    horizontalMargin: 20,
                    columnSpacing: 30,
                    headingRowColor: WidgetStateProperty.all(
                      Colors.grey[50],
                    ),
                    columns: [
                      DataColumn(
                        label: Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Destination', // Changed from 'Ticket ID'
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Car Plate',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Seats',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Customer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                    rows: controller.cancelledTicketsData.map((entry) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              entry['date'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          DataCell(
                            Container(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(
                                entry['destination'] ?? 'Unknown Route',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              entry['carPlate'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.purple[700],
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              constraints: BoxConstraints(maxWidth: 120),
                              child: Text(
                                entry['seatNumbers'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              constraints: BoxConstraints(maxWidth: 150),
                              child: Text(
                                entry['customerName'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              entry['amount'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
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
}
