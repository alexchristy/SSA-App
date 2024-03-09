import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ssa_app/models/terminal.dart';
import 'package:ssa_app/screens/terminal-list/terminal_list_screen.dart';
import 'package:ssa_app/utils/terminal_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'terminal_list_test.mocks.dart';

@GenerateMocks([TerminalService])
void main() {
  group("TerminalsList widget loading tests", () {
    testWidgets('Should show loading indicator when loading data',
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      when(terminalService.getTerminals()).thenAnswer((_) async => []);

      await tester.pumpWidget(MaterialApp(
        home: TerminalsList(terminalService: terminalService),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        "Check number of rendered cards is equal to number of terminal documents.",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      when(terminalService.getTerminals()).thenAnswer((_) async => [
            Terminal(
              archiveDir: "",
              group: "Group 1",
              last30DayUpdateTimestamp: Timestamp.now(),
              last72HourUpdateTimestamp: Timestamp.now(),
              lastCheckTimestamp: Timestamp.now(),
              lastRollcallUpdateTimestamp: Timestamp.now(),
              link: "https://example.com/terminal1",
              location: "Location 1",
              name: "Terminal 1",
              pagePosition: 1,
              pdf30DayHash: "pdf30DayHash",
              pdf72HourHash: "pdf72HourHash",
              pdfRollcallHash: "pdfRollcallHash",
              terminalImageUrl: "https://example.com/terminal1/image.jpg",
              timezone: "America/New_York",
            ),
            Terminal(
              archiveDir: "",
              group: "Group 2",
              last30DayUpdateTimestamp: Timestamp.now(),
              last72HourUpdateTimestamp: Timestamp.now(),
              lastCheckTimestamp: Timestamp.now(),
              lastRollcallUpdateTimestamp: Timestamp.now(),
              link: "https://example.com/terminal2",
              location: "Location 2",
              name: "Terminal 2",
              pagePosition: 2,
              pdf30DayHash: "pdf30DayHash",
              pdf72HourHash: "pdf72HourHash",
              pdfRollcallHash: "pdfRollcallHash",
              terminalImageUrl: "https://example.com/terminal2/image.jpg",
              timezone: "America/New_York",
            ),
          ]);

      await tester.pumpWidget(MaterialApp(
        home: TerminalsList(terminalService: terminalService),
      ));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Check that the number of Card widgets rendered is equal to the number of Terminal documents
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.byType(TerminalListItem), findsNWidgets(2));

      // Check that the text on the cards is the name of the terminal
      expect(find.text("Terminal 1"), findsOneWidget);
      expect(find.text("Terminal 2"), findsOneWidget);
    });
  });

  group("TerminalsList widget error handling tests.", () {
    testWidgets('Should display an error message when data loading fails',
        (WidgetTester tester) async {
      // Mock the TerminalService to simulate a failure
      final terminalService = MockTerminalService();
      when(terminalService.getTerminals()).thenAnswer(
        (_) async => Future<List<Terminal>>.error('Failed to load data'),
      );

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: TerminalsList(terminalService: terminalService),
      ));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Check for the error message by finding a Text Widget with the specific Key
      expect(find.byKey(const Key("terminalLoadingError")), findsOneWidget);
    });
  });
}
