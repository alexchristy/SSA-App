import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ssa_app/models/filter.dart';
import 'package:ssa_app/screens/terminal-list/list_filters_widget.dart';

class MockCallbackFunction extends Mock {
  void call(List<String> selectedFilters);
}

void main() {
  // Define a list of filters for testing
  final List<Filter> filters = [
    Filter(id: "1", name: "Filter 1"),
    Filter(id: "2", name: "Filter 2"),
    Filter(id: "3", name: "Filter 3"),
  ];

  testWidgets('TerminalFilterWidget displays filters correctly',
      (WidgetTester tester) async {
    // Render the TerminalFilterWidget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TerminalFilterWidget(
          filters: filters,
          onFiltersSelected: (_) {},
          edgePadding: 10.0,
        ),
      ),
    ));

    // Verify that all filters are displayed
    expect(find.text('Filter 1'), findsOneWidget);
    expect(find.text('Filter 2'), findsOneWidget);
    expect(find.text('Filter 3'), findsOneWidget);
  });

  testWidgets('Selecting a filter updates its appearance and calls callback',
      (WidgetTester tester) async {
    final callback = MockCallbackFunction();

    // Render the TerminalFilterWidget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TerminalFilterWidget(
          filters: filters,
          onFiltersSelected: callback.call,
          edgePadding: 10.0,
        ),
      ),
    ));

    // Tap the first filter
    await tester.tap(find.text('Filter 1'));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Verify the callback was called with the correct data
    verify(callback(["1"])).called(1);

    // Tap the first filter again to deselect
    await tester.tap(find.text('Filter 1'));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Verify the callback was called with empty list since the filter is deselected
    verify(callback([])).called(1);
  });

  testWidgets('Single selection calls callback with correct data',
      (WidgetTester tester) async {
    final callback = MockCallbackFunction();

    // Render the TerminalFilterWidget with the provided filters
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TerminalFilterWidget(
          filters: filters,
          onFiltersSelected: callback.call,
          edgePadding: 10.0,
        ),
      ),
    ));

    // Tap on the first filter to select it
    await tester.tap(find.text('Filter 1'));
    await tester
        .pumpAndSettle(); // Wait for animations and state updates to complete

    // Verify that the callback was called exactly once with the expected argument
    verify(callback(["1"])).called(1);

    // Optionally, verify no unexpected calls were made after this action
    verifyNoMoreInteractions(callback);
  });

  testWidgets('Multiple selections work as expected',
      (WidgetTester tester) async {
    final callback = MockCallbackFunction();

    // Render the TerminalFilterWidget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TerminalFilterWidget(
          filters: filters,
          onFiltersSelected: callback.call,
          edgePadding: 10.0,
        ),
      ),
    ));

    // Tap the first filter
    await tester.tap(find.text('Filter 1'));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Verify the callback was called with ["1"]
    verify(callback(["1"])).called(1);

    // Tap the second filter
    await tester.tap(find.text('Filter 2'));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Verify the callback was then called with ["1", "2"]
    verify(callback(["1", "2"])).called(1);

    // Verify no more interactions with the callback (no unexpected calls)
    verifyNoMoreInteractions(callback);
  });

  testWidgets('Deselecting a single selection updates callback correctly',
      (WidgetTester tester) async {
    final callback = MockCallbackFunction();

    // Render the TerminalFilterWidget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TerminalFilterWidget(
          filters: filters,
          onFiltersSelected: callback.call,
          edgePadding: 10.0,
        ),
      ),
    ));

    // Tap on the first filter to select it
    await tester.tap(find.text('Filter 1'));
    await tester.pumpAndSettle();

    // Verify the callback was called with the correct data
    verify(callback(["1"])).called(1);

    // Tap again to deselect
    await tester.tap(find.text('Filter 1'));
    await tester.pumpAndSettle();

    // Verify the callback was called with an empty list after deselection
    verify(callback([])).called(1);

    // Verify no unexpected interactions
    verifyNoMoreInteractions(callback);
  });

  testWidgets('Deselecting multiple selections updates callback correctly',
      (WidgetTester tester) async {
    final callback = MockCallbackFunction();

    // Render the TerminalFilterWidget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TerminalFilterWidget(
          filters: filters,
          onFiltersSelected: callback.call,
          edgePadding: 10.0,
        ),
      ),
    ));

    // Tap on the first two filters to select them
    await tester.tap(find.text('Filter 1'));
    await tester.pumpAndSettle();
    verify(callback(["1"])).called(1);

    await tester.tap(find.text('Filter 2'));
    await tester.pumpAndSettle();
    verify(callback(["1", "2"])).called(1);

    // Tap again on both filters to deselect them
    await tester.tap(find.text('Filter 1'));
    await tester.pumpAndSettle();
    verify(callback(["2"])).called(1);

    await tester.tap(find.text('Filter 2'));
    await tester.pumpAndSettle();
    verify(callback([])).called(1);

    // Verify no unexpected interactions
    verifyNoMoreInteractions(callback);
  });
}
