import 'package:flutter/material.dart';

class FilterCard extends StatelessWidget {
  final String title;
  final String selectedFilter;
  final List<String> filters;
  final Function(String) onFilterChanged;

  const FilterCard({
    super.key,
    required this.title,
    required this.selectedFilter,
    required this.filters,
    required this.onFilterChanged,
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: filter == selectedFilter,
                    onSelected: (_) => onFilterChanged(filter),
                    backgroundColor: Colors.grey.shade100,
                    selectedColor:
                        Theme.of(context).primaryColor.withOpacity(0.2),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
