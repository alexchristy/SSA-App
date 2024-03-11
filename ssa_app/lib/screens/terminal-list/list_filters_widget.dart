import 'package:flutter/material.dart';
import 'package:ssa_app/models/filter.dart'; // Ensure your Filter model is correctly defined

class TerminalFilterWidget extends StatefulWidget {
  final List<Filter> filters;
  final Function(List<String>) onFiltersSelected;
  final double edgePadding; // Adjust to match the TerminalsList items

  const TerminalFilterWidget({
    super.key,
    required this.filters,
    required this.onFiltersSelected,
    required this.edgePadding,
  });

  @override
  State<TerminalFilterWidget> createState() => _TerminalFilterWidgetState();
}

class _TerminalFilterWidgetState extends State<TerminalFilterWidget> {
  List<String> selectedFilterIds = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45, // Adjust based on your UI design
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(), // Add this line
        itemCount: widget.filters.length,
        padding: EdgeInsets.only(
            // Adjust the padding of the ListView
            left: widget.edgePadding - 4,
            right: widget.edgePadding - 4),
        itemBuilder: (context, index) {
          final filter = widget.filters[index];
          bool isSelected =
              selectedFilterIds.contains(filter.id); // Check if selected
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedFilterIds.remove(filter.id);
                } else {
                  selectedFilterIds.add(filter.id);
                }
              });
              widget.onFiltersSelected(
                  selectedFilterIds); // Pass back all selected IDs
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              margin: const EdgeInsets.symmetric(
                  horizontal: 8.0), // Consistent margin for visual balance
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child:
                      Text(filter.name, style: const TextStyle(fontSize: 16))),
            ),
          );
        },
      ),
    );
  }
}
