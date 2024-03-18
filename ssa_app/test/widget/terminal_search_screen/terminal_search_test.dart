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
}
