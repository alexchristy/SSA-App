import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:ssa_app/screens/terminal-search/terminal_search_screen.dart';
import 'package:ssa_app/utils/terminal_utils.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'terminal_search_test.mocks.dart';

@GenerateMocks([TerminalService])
void main() {
  group("Loading Terminal search screen tests.", () {
    testWidgets("Ensure there is a X symbol to exit screen (top left)",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets("Ensure the App Bar has 'Search' as the title",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));
      await tester.pumpAndSettle();
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets("Ensure the search bar is present",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets("Ensure the search bar has the correct placeholder text",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));
      await tester.pumpAndSettle();
      expect(find.text('Terminal Search'), findsOneWidget);
    });

    testWidgets("Ensure that the 'SUGGESTED TERMINALS' text is present",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));
      await tester.pumpAndSettle();
      expect(find.text('SUGGESTED TERMINALS'), findsOneWidget);
    });
  });

  group("Animation Terminal search screen tests.", () {
    testWidgets('Search bar is full length on initial loading',
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();

      // Define the MaterialApp to set a context with MediaQuery
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));

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
      final terminalService = MockTerminalService();

      // Pump the TerminalSearchScreen widget into the widget tree
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));

      // Find the TextField by looking for a widget with the 'Search' labelText
      final Finder searchField = find.byWidgetPredicate((Widget widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Terminal Search');

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

    testWidgets('Search bar is shorter than intial length when focused',
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();

      // Define the MaterialApp to set a context with MediaQuery
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));

      // Find the TextField widget
      final Finder textFieldFinder = find.byType(TextField);

      // Execute the pump to build the widget
      await tester.pumpAndSettle();

      // Tap the TextField to focus it
      final searchField = find.byType(TextField);
      await tester.tap(searchField);
      await tester.pumpAndSettle();

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
      expect(textFieldWidth, lessThan(expectedWidth));
    });

    testWidgets('Search bar is full length when Cancel button is tapped',
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();

      // Define the MaterialApp to set a context with MediaQuery
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));

      // Find the TextField widget
      final Finder textFieldFinder = find.byType(TextField);

      // Execute the pump to build the widget
      await tester.pumpAndSettle();

      // Tap the TextField to focus it
      final searchField = find.byType(TextField);
      await tester.tap(searchField);
      await tester.pumpAndSettle();

      // Tap text button "Cancel" to unfocus the TextField
      final cancelButton = find.text('Cancel');
      await tester.tapAt(tester.getCenter(cancelButton));
      await tester.pumpAndSettle();

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

    testWidgets('Text in Search bar is cleared when Cancel button is tapped.',
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();

      // Define the MaterialApp to set a context with MediaQuery
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));

      // Find the TextField widget
      final Finder textFieldFinder = find.byType(TextField);

      // Execute the pump to build the widget
      await tester.pumpAndSettle();

      // Tap the TextField to focus it
      final searchField = find.byType(TextField);
      await tester.tap(searchField);
      await tester.pumpAndSettle();

      // Enter text into the TextField
      await tester.enterText(searchField, 'Terminal 1');

      // Check if the TextField's text is as expected
      final textFieldInitial = tester.widget<TextField>(textFieldFinder);
      expect(textFieldInitial.controller!.text, 'Terminal 1');

      // Tap text button "Cancel" to unfocus the TextField
      final cancelButton = find.text('Cancel');
      await tester.tapAt(tester.getCenter(cancelButton));
      await tester.pumpAndSettle();

      // Retrieve the TextField's text
      final textFieldCleared = tester.widget<TextField>(textFieldFinder);

      // Verify the TextField's text is empty
      expect(textFieldCleared.controller!.text, '');
    });

    testWidgets("Ensure correct hint text when search bar initially clicked.",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();

      // Define the MaterialApp to set a context with MediaQuery
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));

      // Find the TextField widget
      final Finder textFieldFinder = find.byType(TextField);

      // Execute the pump to build the widget
      await tester.pumpAndSettle();

      // Tap the TextField to focus it
      final searchField = find.byType(TextField);
      await tester.tap(searchField);
      await tester.pumpAndSettle();

      // Retrieve the TextField's hintText
      final textField = tester.widget<TextField>(textFieldFinder);

      // Verify the TextField's hintText is as expected
      expect(textField.decoration!.hintText, 'Name, location, or command');
    });

    testWidgets(
        "Ensure the 'SUGGESTED TERMINALS' text disappears when text is entered into search bar.",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();

      // Define the MaterialApp to set a context with MediaQuery
      await tester.pumpWidget(MaterialApp(
          home: TerminalSearchScreen(
        terminalService: terminalService,
        terminalCardHeight: 50.0,
      )));

      // Execute the pump to build the widget
      await tester.pumpAndSettle();

      // Find the 'SUGGESTED TERMINALS' text
      final Finder suggestedTerminals = find.text('SUGGESTED TERMINALS');

      // Ensure the 'SUGGESTED TERMINALS' text is found
      expect(suggestedTerminals, findsOneWidget);

      // Tap the TextField to focus it
      final searchField = find.byType(TextField);
      await tester.tap(searchField);
      await tester.pumpAndSettle();

      // Enter text into the TextField
      await tester.enterText(searchField, 'Terminal 1');
      await tester.pumpAndSettle();

      // Ensure the 'SUGGESTED TERMINALS' text is not found
      expect(suggestedTerminals, findsNothing);
    });
  });
}
