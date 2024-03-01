import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ssa_app/screens/terminal-list/terminal_list_screen.dart';
import 'package:ssa_app/utils/terminal_utils.dart';

import 'terminal_list_test.mocks.dart';

@GenerateMocks([TerminalService])
void main() {
  group("TerminalsList Widget Tests", () {
    testWidgets('Should show loading indicator when loading data',
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      when(terminalService.getTerminals()).thenAnswer((_) async => []);

      await tester.pumpWidget(MaterialApp(
        home: TerminalsList(terminalService: terminalService),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should display an error message when data loading fails',
        (WidgetTester tester) async {
      // Mock the TerminalService to simulate a failure
      final terminalService = MockTerminalService();
      when(terminalService.getTerminals()).thenAnswer(
        (_) async =>
            Future<List<QueryDocumentSnapshot>>.error('Failed to load data'),
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
