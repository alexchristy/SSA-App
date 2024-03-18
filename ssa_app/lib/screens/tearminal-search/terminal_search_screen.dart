import 'package:flutter/material.dart';

class TerminalSearchScreen extends StatelessWidget {
  const TerminalSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(
              Icons.close), // Use the 'close' icon, which looks like an 'X'
          onPressed: () =>
              Navigator.of(context).pop(), // Close the current screen
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: const InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
            hintText: 'Enter search term',
          ),
          onSubmitted: (value) {
            // Implement your search logic here
            print("Searching for $value");
          },
        ),
      ),
    );
  }
}
