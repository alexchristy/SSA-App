import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ssa_app/models/terminal.dart';
import 'package:ssa_app/screens/terminal-list/terminal_list_screen.dart';
import 'package:ssa_app/utils/terminal_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssa_app/screens/terminal-list/list_filters_widget.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ssa_app/providers/global_provider.dart';
import 'package:ssa_app/providers/terminals_provider.dart';

import 'terminal_list_test.mocks.dart';

@GenerateMocks([TerminalService])
void main() {
  group("TerminalsList widget loading tests", () {
    testWidgets('Should show loading indicator when loading data with delay',
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      // Setup the mock service to delay its response
      when(terminalService.getTerminalsByGroups(
              groups: anyNamed('groups'), fromCache: anyNamed('fromCache')))
          .thenAnswer(
              (_) => Future.delayed(const Duration(seconds: 2), () => []));

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Initially, you may not find the CircularProgressIndicator because the delay hasn't triggered its display yet
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.pump(const Duration(milliseconds: 150)); // Start the Future

      // Now the CircularProgressIndicator should be displayed
      // because the delay has triggered its display
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(
          seconds: 2)); // Match this with the delay in your mock response

      // Now the CircularProgressIndicator should be gone and the data should be displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
        "Check number of rendered cards is equal to number of terminal documents.",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      when(terminalService.getTerminalsByGroups(
              groups: anyNamed('groups'), fromCache: anyNamed('fromCache')))
          .thenAnswer((_) async => [
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

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Check that the number of Card widgets rendered is equal to the number of Terminal documents
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.byType(TerminalListItem), findsNWidgets(2));

      // Check that the text on the cards is the name of the terminal
      expect(find.text("Terminal 1"), findsOneWidget);
      expect(find.text("Terminal 2"), findsOneWidget);

      // Make sure the filters are displayed
      expect(find.byType(TerminalFilterWidget), findsOneWidget);
    });

    testWidgets("Test that the search button is rendered",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      when(terminalService.getTerminalsByGroups(groups: anyNamed('groups')))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Check that the search button is displayed
      expect(find.byIcon(Icons.search), findsOne);
    });

    testWidgets("Test that the back arrow is rendered",
        ((WidgetTester tester) async {
      final terminalService = MockTerminalService();
      when(terminalService.getTerminalsByGroups(groups: anyNamed('groups')))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Check that the back arrow is displayed
      expect(find.byIcon(Icons.arrow_back), findsOne);
    }));

    testWidgets("Test that the AppBar has the text 'Terminals'",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      when(terminalService.getTerminalsByGroups(groups: anyNamed('groups')))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Check that the AppBar has the text 'Terminals'
      expect(find.text("Terminals"), findsOne);
    });

    testWidgets('AppBar defaults to minimum height when screen height is small',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 600); // Small screen

      final terminalService = MockTerminalService();
      // Mock the terminalService to return an empty list
      when(terminalService.getTerminalsByGroups(
              groups: anyNamed('groups'), fromCache: anyNamed('fromCache')))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Define the expected minimum height of the AppBar
      const double expectedMinHeight = 50.0;

      // Find the AppBar and verify its height
      final appBar = tester.widget<PreferredSize>(find.byType(PreferredSize));
      expect(appBar.preferredSize.height, expectedMinHeight);

      tester.view.resetPhysicalSize();
    });

    testWidgets(
        'downloadedTerminals is true after TerminalsList is rendered for the first time',
        (WidgetTester tester) async {
      MockTerminalService terminalService = MockTerminalService();

      // Initialize the provider
      GlobalProvider globalProvider = GlobalProvider();

      // Assert initial state is false
      expect(globalProvider.downloadedTerminals, isFalse);

      // Create a test widget wrapped with the provider
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<GlobalProvider>.value(value: globalProvider),
            ChangeNotifierProvider<TerminalsProvider>(
              create: (_) => TerminalsProvider(),
            ),
          ],
          child: MaterialApp(
            home: TerminalsList(
              terminalService: terminalService,
            ),
          ),
        ),
      );

      // Optionally, wait for any async operations if your widget initiates any during build
      await tester.pumpAndSettle();

      // Assert that downloadedTerminals is now true
      expect(globalProvider.downloadedTerminals, isTrue);
    });

    testWidgets(
        'Test that terminal documents are fetched from server when TerminalsList is rendered for the first time.',
        (WidgetTester tester) async {
      MockTerminalService terminalService = MockTerminalService();

      // Initialize the provider
      GlobalProvider globalProvider = GlobalProvider();

      // Assert initial state is false
      expect(globalProvider.downloadedTerminals, isFalse);

      // Create a test widget wrapped with the provider
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<GlobalProvider>.value(value: globalProvider),
            ChangeNotifierProvider<TerminalsProvider>(
              create: (_) => TerminalsProvider(),
            ),
          ],
          child: MaterialApp(
            home: TerminalsList(
              terminalService: terminalService,
            ),
          ),
        ),
      );

      // Optionally, wait for any async operations if your widget initiates any during build
      await tester.pumpAndSettle();

      // Assert that downloadedTerminals is now true
      expect(globalProvider.downloadedTerminals, isTrue);

      // Verify that getTerminalsByGroups was called with fromCache: false
      verify(terminalService.getTerminalsByGroups(
              groups: anyNamed('groups'), fromCache: false))
          .called(1);
    });

    testWidgets(
        'Test that terminal documents are fetched from cache when is the second time TerminalsList is rendered.',
        (WidgetTester tester) async {
      MockTerminalService terminalService = MockTerminalService();

      // Initialize the provider
      GlobalProvider globalProvider = GlobalProvider();

      // Assert initial state is false
      expect(globalProvider.downloadedTerminals, isFalse);

      // Create a test widget wrapped with the provider
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<GlobalProvider>.value(value: globalProvider),
            ChangeNotifierProvider<TerminalsProvider>(
              create: (_) => TerminalsProvider(),
            ),
          ],
          child: MaterialApp(
            home: TerminalsList(
              terminalService: terminalService,
            ),
          ),
        ),
      );

      // Optionally, wait for any async operations if your widget initiates any during build
      await tester.pumpAndSettle();

      // Build another widget to simulate exiting and re-entering the TerminalsList screen
      // Simulate navigating away
      await tester.pumpWidget(
        MaterialApp(
          home: Container(),
        ),
      );

      await tester.pumpAndSettle();

      // Rebuild the TerminalsList widget
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<GlobalProvider>.value(value: globalProvider),
            ChangeNotifierProvider<TerminalsProvider>(
              create: (_) => TerminalsProvider(),
            ),
          ],
          child: MaterialApp(
            home: TerminalsList(
              terminalService: terminalService,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert that downloadedTerminals true after the second build
      expect(globalProvider.downloadedTerminals, isTrue);

      // Verify that getTerminalsByGroups was called with fromCache: true
      verify(terminalService.getTerminalsByGroups(
              groups: anyNamed('groups'), fromCache: true))
          .called(1);

      // Verify that there were no more calls to getTerminalsByGroups with fromCache: false
      // after the first build. Max 1 call.
      verify(terminalService.getTerminalsByGroups(
              groups: anyNamed('groups'), fromCache: false))
          .called(1);
    });
  });

  group("TerminalsList Screen refresh tests", () {
    testWidgets("Verify pull-down to refresh uses fromCache: false",
        (WidgetTester tester) async {
      // Setup the mock TerminalService
      final mockTerminalService = MockTerminalService();

      // When getTerminalsByGroups is called with any groups and fromCache: false,
      // return an empty list to simulate a successful call.
      when(mockTerminalService.getTerminalsByGroups(
              groups: anyNamed('groups'), fromCache: false))
          .thenAnswer((_) async => <Terminal>[]);

      // Pump the TerminalsList widget with the mocked service
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: mockTerminalService))));

      // Complete the initial load
      await tester.pumpAndSettle();

      // Simulate the pull-to-refresh action
      final finder = find.byType(CustomScrollView);
      expect(finder, findsOneWidget);
      await tester.fling(finder, const Offset(0, 300), 1000);
      await tester.pump();

      // Wait for the RefreshIndicator to show up and complete its animation
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Verify that getTerminalsByGroups was called with fromCache: false
      verify(mockTerminalService.getTerminalsByGroups(
              groups: anyNamed('groups'), fromCache: false))
          .called(1);
    });
  });

  group("TerminalsList widget error handling tests.", () {
    testWidgets('Should display an error message when data loading fails',
        (WidgetTester tester) async {
      // Mock the TerminalService to simulate a failure
      final terminalService = MockTerminalService();

      when(terminalService.getTerminalsByGroups(groups: anyNamed('groups')))
          .thenAnswer(
        (_) async => Future<List<Terminal>>.error('Failed to load data'),
      );

      // Build our app and trigger a frame.
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Check for the error message by finding a Text Widget with the specific Key
      expect(find.byIcon(Icons.error), findsOne);
      expect(
          find.text(
              "Failed to load terminals. Check your connection and try again."),
          findsOneWidget);

      // Make sure that the filters are still displayed
      expect(find.byType(TerminalFilterWidget), findsOneWidget);

      // Make sure no cards or TerminalListItems are displayed
      expect(find.byType(Card), findsNothing);
      expect(find.byType(TerminalListItem), findsNothing);
    });

    testWidgets(
        'Should display "No terminals found." if getTerminalsByGroups() returns an empty list.',
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      when(terminalService.getTerminalsByGroups(
              groups: anyNamed('groups'), fromCache: anyNamed('fromCache')))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Check for the error message by finding a Text Widget with the specific Key
      expect(find.text("No terminals found."), findsOneWidget);

      // Make sure that the filters are still displayed
      expect(find.byType(TerminalFilterWidget), findsOneWidget);
    });

    testWidgets(
        'Fallback to flight_takeoff icon when terminalImageUrl is empty',
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      when(terminalService.getTerminalsByGroups(
              groups: anyNamed('groups'), fromCache: anyNamed('fromCache')))
          .thenAnswer((_) async => [
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
                  terminalImageUrl: "",
                  timezone: "America/New_York",
                ),
              ]);

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Check that the number of Card widgets rendered is equal to the number of Terminal documents
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(TerminalListItem), findsOneWidget);

      // Check that the text on the cards is the name of the terminal
      expect(find.text("Terminal 1"), findsOneWidget);

      // Check that the fallback icon is displayed
      expect(find.byIcon(Icons.flight_takeoff), findsOneWidget);

      // Make sure the filters are displayed
      expect(find.byType(TerminalFilterWidget), findsOneWidget);
    });

    testWidgets(
      'Fallback to flight_takeoff icon when terminalImageUrl is null (attribute missing)',
      (WidgetTester tester) async {
        final terminalService = MockTerminalService();
        when(terminalService.getTerminalsByGroups(
                groups: anyNamed('groups'), fromCache: anyNamed('fromCache')))
            .thenAnswer((_) async => [
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
                    terminalImageUrl: null,
                    timezone: "America/New_York",
                  ),
                ]);

        await tester.pumpWidget(MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => GlobalProvider()),
              ChangeNotifierProvider(create: (_) => TerminalsProvider())
            ],
            child: MaterialApp(
                home: TerminalsList(terminalService: terminalService))));

        // Pump to complete the Future
        await tester.pumpAndSettle();

        // Check that the number of Card widgets rendered is equal to the number of Terminal documents
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(TerminalListItem), findsOneWidget);

        // Check that the text on the cards is the name of the terminal
        expect(find.text("Terminal 1"), findsOneWidget);

        // Check that the fallback icon is displayed
        expect(find.byIcon(Icons.flight_takeoff), findsOneWidget);

        // Make sure the filters are displayed
        expect(find.byType(TerminalFilterWidget), findsOneWidget);
      },
    );
  });

  group("TerminalList Screen filter tests", () {
    testWidgets("Test that tapping filters reduces terminal cards.",
        (WidgetTester tester) async {
      final fakeFirestore = FakeFirebaseFirestore();

      // Add some test data to the Firestore instance
      fakeFirestore.collection("Terminals").add({
        "archiveDir": "bleh",
        "group": "EUCOM TERMINALS",
        "last30DayUpdateTimestamp": Timestamp.now(),
        "last72HourUpdateTimestamp": Timestamp.now(),
        "lastCheckTimestamp": Timestamp.now(),
        "lastRollcallUpdateTimestamp": Timestamp.now(),
        "link": "https://example.com/terminal1",
        "location": "Location 1",
        "name": "Terminal 1",
        "pagePosition": 1,
        "pdf30DayHash": "pdf30DayHash",
        "pdf72HourHash": "pdf72HourHash",
        "pdfRollcallHash": "pdfRollcallHash",
        "terminalImageUrl": "",
        "timezone": "America/New_York",
      });

      fakeFirestore.collection("Terminals").add({
        "archiveDir": "bleh",
        "group": "CENTCOM TERMINALS",
        "last30DayUpdateTimestamp": Timestamp.now(),
        "last72HourUpdateTimestamp": Timestamp.now(),
        "lastCheckTimestamp": Timestamp.now(),
        "lastRollcallUpdateTimestamp": Timestamp.now(),
        "link": "https://example.com/terminal2",
        "location": "Location 2",
        "name": "Terminal 2",
        "pagePosition": 2,
        "pdf30DayHash": "pdf30DayHash",
        "pdf72HourHash": "pdf72HourHash",
        "pdfRollcallHash": "pdfRollcallHash",
        "terminalImageUrl": "",
        "timezone": "America/New_York",
      });

      final terminalService = TerminalService(firestore: fakeFirestore);

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Check that the number of Card widgets rendered is equal to the number of Terminal documents
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.byType(TerminalListItem), findsNWidgets(2));

      // Make sure the filters are displayed
      expect(find.byType(TerminalFilterWidget), findsOneWidget);

      // Tap the filter button
      await tester.tap(find.text("Europe"));
      await tester.pumpAndSettle();

      // Check that only one card is displayed
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(TerminalListItem), findsOneWidget);

      // Check that the text on the card is the name of the terminal
      expect(find.text("Terminal 1"), findsOneWidget);
    });

    testWidgets("Test that choosing a filter with no matches shows a message.",
        (WidgetTester tester) async {
      final fakeFirestore = FakeFirebaseFirestore();

      // Add some test data to the Firestore instance
      fakeFirestore.collection("Terminals").add({
        "archiveDir": "bleh",
        "group": "EUCOM TERMINALS",
        "last30DayUpdateTimestamp": Timestamp.now(),
        "last72HourUpdateTimestamp": Timestamp.now(),
        "lastCheckTimestamp": Timestamp.now(),
        "lastRollcallUpdateTimestamp": Timestamp.now(),
        "link": "https://example.com/terminal1",
        "location": "Location 1",
        "name": "Terminal 1",
        "pagePosition": 1,
        "pdf30DayHash": "pdf30DayHash",
        "pdf72HourHash": "pdf72HourHash",
        "pdfRollcallHash": "pdfRollcallHash",
        "terminalImageUrl": "",
        "timezone": "America/New_York",
      });

      fakeFirestore.collection("Terminals").add({
        "archiveDir": "bleh",
        "group": "CENTCOM TERMINALS",
        "last30DayUpdateTimestamp": Timestamp.now(),
        "last72HourUpdateTimestamp": Timestamp.now(),
        "lastCheckTimestamp": Timestamp.now(),
        "lastRollcallUpdateTimestamp": Timestamp.now(),
        "link": "https://example.com/terminal2",
        "location": "Location 2",
        "name": "Terminal 2",
        "pagePosition": 2,
        "pdf30DayHash": "pdf30DayHash",
        "pdf72HourHash": "pdf72HourHash",
        "pdfRollcallHash": "pdfRollcallHash",
        "terminalImageUrl": "",
        "timezone": "America/New_York",
      });

      final terminalService = TerminalService(firestore: fakeFirestore);

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // Check that the number of Card widgets rendered is equal to the number of Terminal documents
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.byType(TerminalListItem), findsNWidgets(2));

      // Make sure the filters are displayed
      expect(find.byType(TerminalFilterWidget), findsOneWidget);

      // Tap the filter button
      await tester.tap(find.text("USA"));
      await tester.pumpAndSettle();

      // Check that no cards are displayed
      expect(find.byType(Card), findsNothing);
      expect(find.byType(TerminalListItem), findsNothing);

      // Check that the message is displayed
      expect(find.text("No terminals found."), findsOneWidget);
    });

    testWidgets("Test that tapping all filters shows all termianls.",
        (WidgetTester tester) async {
      final fakeFirestore = FakeFirebaseFirestore();

      // Add some test data to the Firestore instance
      fakeFirestore.collection("Terminals").add({
        "archiveDir": "bleh",
        "group": "AMC CONUS TERMINALS",
        "last30DayUpdateTimestamp": Timestamp.now(),
        "last72HourUpdateTimestamp": Timestamp.now(),
        "lastCheckTimestamp": Timestamp.now(),
        "lastRollcallUpdateTimestamp": Timestamp.now(),
        "link": "https://example.com/terminal1",
        "location": "Location 1",
        "name": "Terminal 1",
        "pagePosition": 1,
        "pdf30DayHash": "pdf30DayHash",
        "pdf72HourHash": "pdf72HourHash",
        "pdfRollcallHash": "pdfRollcallHash",
        "terminalImageUrl": "",
        "timezone": "America/New_York",
      });

      fakeFirestore.collection("Terminals").add({
        "archiveDir": "bleh",
        "group": "EUCOM TERMINALS",
        "last30DayUpdateTimestamp": Timestamp.now(),
        "last72HourUpdateTimestamp": Timestamp.now(),
        "lastCheckTimestamp": Timestamp.now(),
        "lastRollcallUpdateTimestamp": Timestamp.now(),
        "link": "https://example.com/terminal1",
        "location": "Location 1",
        "name": "Terminal 2",
        "pagePosition": 1,
        "pdf30DayHash": "pdf30DayHash",
        "pdf72HourHash": "pdf72HourHash",
        "pdfRollcallHash": "pdfRollcallHash",
        "terminalImageUrl": "",
        "timezone": "America/New_York",
      });

      final terminalService = TerminalService(firestore: fakeFirestore);

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GlobalProvider()),
            ChangeNotifierProvider(create: (_) => TerminalsProvider())
          ],
          child: MaterialApp(
              home: TerminalsList(terminalService: terminalService))));

      // Pump to complete the Future
      await tester.pumpAndSettle();

      // debugDumpApp();

      // Check that the number of Card widgets rendered is equal to the number of Terminal documents
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.byType(TerminalListItem), findsNWidgets(2));

      // Make sure the filters are displayed
      expect(find.byType(TerminalFilterWidget), findsOneWidget);

      // Tap the filter button
      await tester.tap(find.text("USA"));
      await tester.pumpAndSettle();

      // Check only Terminal 3 is displayed
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(TerminalListItem), findsOneWidget);
      expect(find.text("Terminal 1"), findsOneWidget);

      // Tap the filter button
      await tester.tap(find.text("Europe"));
      await tester.pumpAndSettle();

      // Check check Terminal 1 is also displayed
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.byType(TerminalListItem), findsNWidgets(2));
      expect(find.text("Terminal 1"), findsOneWidget);
      expect(find.text("Terminal 2"), findsOneWidget);
    });
  });
}
