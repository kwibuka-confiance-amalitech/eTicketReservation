import 'package:car_ticket/presentation/widgets/report_widgets/data_table_card.dart';
import 'package:car_ticket/presentation/widgets/report_widgets/filter_card.dart';
import 'package:car_ticket/presentation/widgets/report_widgets/summary_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MembersReportTab extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const MembersReportTab(
      {super.key, required this.startDate, required this.endDate});

  @override
  State<MembersReportTab> createState() => _MembersReportTabState();
}

class _MembersReportTabState extends State<MembersReportTab> {
  String _selectedFilter = 'All Members';
  final List<String> _filters = [
    'All Members',
    'New Members',
    'Active Members',
    'Inactive Members'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterCard(
            title: 'Member Type',
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
                  title: 'Total Members',
                  value: '412',
                  icon: Icons.people,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SummaryCard(
                  title: 'New Members',
                  value: '24',
                  icon: Icons.person_add,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMembershipChart(),
          const SizedBox(height: 16),
          DataTableCard(
            title: 'Member List',
            columns: const ['Name', 'Email', 'Join Date', 'Bookings'],
            rows: [
              ['James Smith', 'james@example.com', 'Jan 15, 2025', '5'],
              ['Mary Johnson', 'mary@example.com', 'Jan 20, 2025', '3'],
              ['Robert Brown', 'robert@example.com', 'Jan 25, 2025', '7'],
              ['Patricia Davis', 'patricia@example.com', 'Feb 1, 2025', '2'],
              ['Michael Miller', 'michael@example.com', 'Feb 5, 2025', '4'],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipChart() {
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
            'Member Registrations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.grey.shade800,
                  ),
                  handleBuiltInTouches: true,
                ),
                gridData: const FlGridData(
                  show: true,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const titles = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun'
                        ];
                        if (value >= 0 && value < titles.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(titles[value.toInt()]),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(value.toInt().toString()),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 15),
                      FlSpot(1, 25),
                      FlSpot(2, 18),
                      FlSpot(3, 30),
                      FlSpot(4, 27),
                      FlSpot(5, 24),
                    ],
                    isCurved: true,
                    color: Colors.purple,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.purple.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
