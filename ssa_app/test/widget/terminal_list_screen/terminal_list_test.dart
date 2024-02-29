import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  });
}
