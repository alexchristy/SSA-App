import 'package:flutter/material.dart';

class TerminalSearchScreen extends StatefulWidget {
  const TerminalSearchScreen({super.key});

  @override
  _TerminalSearchScreenState createState() => _TerminalSearchScreenState();
}

class _TerminalSearchScreenState extends State<TerminalSearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _showCancelButton = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_showCancelButton) {
        _animationController.forward();
        setState(() {
          _showCancelButton = true;
        });
      } else if (!_focusNode.hasFocus && _showCancelButton) {
        _animationController.reverse();
        setState(() {
          _showCancelButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Wrap the Row in a Column and use CrossAxisAlignment.start to align the row to the start.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .start, // Align items to the start of the row.
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      hintText: 'Enter search term',
                    ),
                  ),
                ),
                SizeTransition(
                  sizeFactor:
                      _opacityAnimation, // Ensure this uses _opacityAnimation for consistency
                  axis: Axis.horizontal,
                  axisAlignment: -1.0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0), // Consistent padding for alignment
                    child: TextButton(
                      onPressed: () {
                        _searchController.clear();
                        _focusNode.unfocus();
                        if (_showCancelButton) {
                          _animationController.reverse();
                          setState(() {
                            _showCancelButton = false;
                          });
                        }
                      },
                      child:
                          const Text('Cancel', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
