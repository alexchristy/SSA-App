import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssa_app/screens/tearminal-search/terminal_search_screen.dart';

void main() {
  group("Loading Terminal search screen tests.", () {
    testWidgets("Ensure there is a X symbol to exit screen (top left)",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TerminalSearchScreen()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });

  group("Animation Terminal search screen tests.", () {
    testWidgets('Search bar is full length on initial loading',
        (WidgetTester tester) async {
      // Define the MaterialApp to set a context with MediaQuery
      await tester.pumpWidget(const MaterialApp(home: TerminalSearchScreen()));

      // Find the TextField widget
      final Finder textFieldFinder = find.byType(TextField);

      // Execute the pump to build the widget
      await tester.pump();

      // Retrieve the RenderBox of the TextField to measure its size
      final RenderBox renderBox =
          tester.renderObject(textFieldFinder) as RenderBox;
      final double textFieldWidth = renderBox.size.width;

      // Retrieve the screen size for comparison
      final Size screenSize =
          tester.view.physicalSize / tester.view.devicePixelRatio;

      // Calculate the expected width based on the layout's padding
      // Since there's EdgeInsets.all(16.0), subtract 32.0 from the screen width (16.0 on each side)
      final double expectedWidth =
          screenSize.width - 32.0; // Adjust if your padding/margins differ

      // Verify the TextField's width is as expected
      expect(textFieldWidth, expectedWidth);
    });

    testWidgets('Cancel button appears when search bar is tapped',
        (WidgetTester tester) async {
      // Pump the TerminalSearchScreen widget into the widget tree
      await tester.pumpWidget(const MaterialApp(home: TerminalSearchScreen()));

      // Find the TextField by looking for a widget with the 'Search' labelText
      final Finder searchField = find.byWidgetPredicate((Widget widget) =>
          widget is TextField && widget.decoration?.labelText == 'Search');

      // Ensure the TextField is found
      expect(searchField, findsOneWidget);

      // Simulate a tap on the TextField to focus it
      await tester.tap(searchField);
      await tester.pumpAndSettle(); // Wait for any animations to settle

      // Find the cancel button by its text
      final Finder cancelButton = find.text('Cancel');

      // Check if the cancel button is visible
      expect(cancelButton, findsOneWidget);
    });
  });
}
