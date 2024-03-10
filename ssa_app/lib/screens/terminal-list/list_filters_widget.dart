import 'package:flutter/material.dart';
import 'package:ssa_app/models/filter.dart'; // Ensure your Filter model is correctly defined

class TerminalFilterWidget extends StatefulWidget {
  final List<Filter> filters;
  final Function(List<String>) onFiltersSelected;
  const TerminalFilterWidget({
    super.key,
    required this.filters,
    required this.onFiltersSelected,
  });

  @override
  State<TerminalFilterWidget> createState() => _TerminalFilterWidgetState();
}

class _TerminalFilterWidgetState extends State<TerminalFilterWidget> {
  List<String> selectedFilterIds = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Adjust based on your UI design
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.filters.length,
        itemBuilder: (context, index) {
          final filter = widget.filters[index];
          bool isSelected =
              selectedFilterIds.contains(filter.id); // Check if selected
          return GestureDetector(
            onTap: () {
              setState(() {
                // Toggle selection state on tap
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
              margin:
                  EdgeInsets.only(left: index == 0 ? 16.0 : 8.0, right: 8.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
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
