import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:ssa_app/screens/home/home_screen.dart';
import 'package:ssa_app/screens/terminal-detail-page/terminal_detail_screen.dart';
import 'package:ssa_app/screens/terminal-list/list_filters_widget.dart';
import 'package:ssa_app/screens/terminal-list/terminal_list_screen.dart';
import 'package:ssa_app/screens/terminal-search/terminal_search_screen.dart';
import 'package:ssa_app/services/custom_icons/airport.dart';
import 'package:ssa_app/utils/terminal_utils.dart';
import 'package:ssa_app/main.dart' as app;

@GenerateMocks([TerminalService, SearchResponse])
@GenerateNiceMocks([MockSpec<HitsSearcher>(as: #MockHitsSearcher)])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Terminal List screen integration tests.", () {
    testWidgets("Navigate Terminal List screen to Terminal Search screen.",
        (WidgetTester tester) async {
      // Initialize the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Terminal List screen
      final terminalListFinder = find.byIcon(Airport.airport_icon);
      await tester.tap(terminalListFinder);
      await tester.pumpAndSettle();

      // Check if the Terminal List screen is displayed
      expect(find.byType(TerminalsList), findsOneWidget);

      // Click one of the terminal list item cards
      final terminalCardFinder = find.byType(TerminalListItem).first;
      await tester.tap(terminalCardFinder);
      await tester.pumpAndSettle();

      // Check if the Terminal Detail screen is displayed
      expect(find.byType(TerminalDetailPage), findsOneWidget);
    });

    testWidgets("Navigate Terminal List and back to Home screen.",
        (WidgetTester tester) async {
      // Initialize the app
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to Terminal List screen
      final terminalListFinder = find.byType(RawMaterialButton).at(0);
      await tester.tap(terminalListFinder);
      await tester.pumpAndSettle();

      // Check if the Terminal List screen is displayed
      expect(find.byType(TerminalsList), findsOneWidget);

      // Click the back button
      final backButtonFinder = find.byIcon(Icons.arrow_back);
      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();

      // Check if the Home screen is displayed
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets("Use single Terminal list group filters.",
        (WidgetTester tester) async {
      // Initialize the app
      app.main();
      await tester.pumpAndSettle();

      // Ensure that the Home screen is displayed
      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to Terminal List screen
      final terminalListFinder = find.byType(RawMaterialButton).at(0);
      await tester.tap(terminalListFinder);
      await tester.pumpAndSettle();

      // Check if the Terminal List screen is displayed
      expect(find.byType(TerminalsList), findsOneWidget);

      // Check that we have results displayed
      final terminalList = tester.widgetList(find.byType(TerminalListItem));
      expect(terminalList.length, greaterThan(0));
      debugPrint("Terminal list length: ${terminalList.length}");

      // Check if the Terminal Filter widget is displayed
      final terminalFilterFinder = find.byType(TerminalFilterWidget);
      expect(terminalFilterFinder, findsOneWidget);

      // Select a filter
      final filterButtonFinder = find.descendant(
          of: terminalFilterFinder,
          matching: find.byType(GestureDetector).first);

      await tester.tap(filterButtonFinder);
      await tester.pumpAndSettle();

      // Verify that we still have results displayed
      final updatedTerminalList =
          tester.widgetList(find.byType(TerminalListItem));

      expect(updatedTerminalList.length, greaterThan(0));
    });

    testWidgets("Use multiple Terminal list group filters.",
        (WidgetTester tester) async {
      // Initialize the app
      app.main();
      await tester.pumpAndSettle();

      // Ensure that the Home screen is displayed
      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to Terminal List screen
      final terminalListFinder = find.byType(RawMaterialButton).at(0);
      await tester.tap(terminalListFinder);
      await tester.pumpAndSettle();

      // Check if the Terminal List screen is displayed
      expect(find.byType(TerminalsList), findsOneWidget);

      // Check that we have results displayed
      final terminalList = tester.widgetList(find.byType(TerminalListItem));
      expect(terminalList.length, greaterThan(0));
      debugPrint("Terminal list length: ${terminalList.length}");

      // Check if the Terminal Filter widget is displayed
      final terminalFilterFinder = find.byType(TerminalFilterWidget);
      expect(terminalFilterFinder, findsOneWidget);

      // Select a couple of filters
      final filterButtonFinder = find.descendant(
          of: terminalFilterFinder,
          matching: find.byType(GestureDetector).first);

      final filterButtonFinder2 = find.descendant(
          of: terminalFilterFinder,
          matching: find.byType(GestureDetector).at(1));

      // Select the first filter
      await tester.tap(filterButtonFinder);
      await tester.pumpAndSettle();

      // Verify that we still have results displayed
      final updatedTerminalList =
          tester.widgetList(find.byType(TerminalListItem));

      expect(updatedTerminalList.length, greaterThan(0));

      // Select the second filter
      await tester.tap(filterButtonFinder2);
      await tester.pumpAndSettle();

      // Verify that we still have results displayed
      final updatedTerminalList2 =
          tester.widgetList(find.byType(TerminalListItem));

      expect(updatedTerminalList2.length, greaterThan(0));
    });
  });

  group("Terminal Search screen integration tests.", () {
    testWidgets("Navigate Search screen result to Terminal detail screen.",
        (WidgetTester tester) async {
      // Initialize the app
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to Terminal List screen
      final terminalListFinder = find.byType(RawMaterialButton).at(0);
      await tester.tap(terminalListFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TerminalsList), findsOneWidget);

      // Navigate to Terminal Search screen
      final searchButtonFinder = find.byIcon(Icons.search);
      await tester.tap(searchButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TerminalSearchScreen), findsOneWidget);

      // Enter search query
      final searchFieldFinder = find.byType(TextField);
      await tester.enterText(searchFieldFinder, "rota");
      await tester.pumpAndSettle();

      // Click on the search result
      final searchResultFinder =
          find.byKey(const Key("terminalSearchResult")).first;
      await tester.tap(searchResultFinder);
      await tester.pumpAndSettle();

      // Check if the Terminal Detail screen is displayed
      expect(find.byType(TerminalDetailPage), findsOneWidget);
    });

    testWidgets("Navigate to Search screen and back to Home screen.",
        (WidgetTester tester) async {
      // Initialize the app
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to Terminal List screen
      final terminalListFinder = find.byType(RawMaterialButton).at(0);
      await tester.tap(terminalListFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TerminalsList), findsOneWidget);

      // Navigate to Terminal Search screen
      final searchButtonFinder = find.byIcon(Icons.search);
      await tester.tap(searchButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(TerminalSearchScreen), findsOneWidget);

      // Click X button to go back to the list screen
      final closeButtonFinder = find.byIcon(Icons.close);
      await tester.tap(closeButtonFinder);
      await tester.pumpAndSettle();

      // Check if the Terminal List screen is displayed
      expect(find.byType(TerminalsList), findsOneWidget);

      // Click the back button to go back to the Home screen
      final backButtonFinder = find.byIcon(Icons.arrow_back);
      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();

      // Check if the Home screen is displayed
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
