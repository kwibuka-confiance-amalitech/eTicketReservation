import 'package:flutter/material.dart';

class DataTableCard extends StatelessWidget {
  final String title;
  final List<String> columns;
  final List<List<String>> rows;

  const DataTableCard({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
              columns: columns
                  .map((col) => DataColumn(
                        label: Text(
                          col,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ))
                  .toList(),
              rows: rows
                  .map(
                    (row) => DataRow(
                      cells: row.map((cell) => DataCell(Text(cell))).toList(),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
