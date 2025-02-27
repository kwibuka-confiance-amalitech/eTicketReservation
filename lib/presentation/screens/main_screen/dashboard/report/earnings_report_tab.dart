import 'package:car_ticket/presentation/widgets/report_widgets/data_table_card.dart';
import 'package:car_ticket/presentation/widgets/report_widgets/filter_card.dart';
import 'package:car_ticket/presentation/widgets/report_widgets/summary_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EarningsReportTab extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const EarningsReportTab(
      {super.key, required this.startDate, required this.endDate});

  @override
  State<EarningsReportTab> createState() => _EarningsReportTabState();
}

class _EarningsReportTabState extends State<EarningsReportTab> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Cash', 'Card', 'Mobile Money'];

  // Mock data - replace with actual data fetching
  final Map<String, double> _earningsData = {
    'Mon': 250000,
    'Tue': 320000,
    'Wed': 280000,
    'Thu': 350000,
    'Fri': 400000,
    'Sat': 450000,
    'Sun': 300000,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterCard(
            title: 'Payment Type',
            selectedFilter: _selectedFilter,
            filters: _filters,
            onFilterChanged: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Total Revenue',
                  value: 'RWF 2,350,000',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SummaryCard(
                  title: 'Total Bookings',
                  value: '124',
                  icon: Icons.confirmation_number,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildEarningsChart(),
          const SizedBox(height: 16),
          DataTableCard(
            title: 'Daily Earnings',
            columns: const ['Date', 'Bookings', 'Revenue'],
            rows: [
              ['Feb 20, 2025', '12', 'RWF 240,000'],
              ['Feb 21, 2025', '8', 'RWF 160,000'],
              ['Feb 22, 2025', '15', 'RWF 300,000'],
              ['Feb 23, 2025', '10', 'RWF 200,000'],
              ['Feb 24, 2025', '18', 'RWF 360,000'],
              ['Feb 25, 2025', '14', 'RWF 280,000'],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Revenue',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 500000,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey.shade800,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String day = _earningsData.keys.toList()[group.x.toInt()];
                      String amount = NumberFormat.currency(
                        symbol: 'RWF ',
                        decimalDigits: 0,
                      ).format(rod.toY);
                      return BarTooltipItem(
                        '$day\n$amount',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            _earningsData.keys.toList()[value.toInt()],
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            '${(value / 1000).toInt()}K',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _earningsData.entries
                    .map((entry) => BarChartGroupData(
                          x: _earningsData.keys.toList().indexOf(entry.key),
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              color: Colors.blue,
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
