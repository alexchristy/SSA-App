import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ssa_app/screens/terminal-search/terminal_search_screen.dart';
import 'package:ssa_app/utils/terminal_utils.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'terminal_search_test.mocks.dart';
import 'package:ssa_app/providers/global_provider.dart';
import 'package:provider/provider.dart';

@GenerateMocks([TerminalService, SearchResponse])
@GenerateNiceMocks([MockSpec<HitsSearcher>(as: #MockHitsSearcher)])
void main() {
  late MockTerminalService terminalService;
  late MockHitsSearcher hitsSearcher;
  late MockSearchResponse searchResponse;
  late GlobalProvider globalProvider;

  setUp(() {
    // Initialize all mock services
    terminalService = MockTerminalService();
    hitsSearcher = MockHitsSearcher();
    searchResponse = MockSearchResponse();

    // Setup mock empty response for the searchResponse
    when(searchResponse.hits).thenReturn([]);
    when(searchResponse.page).thenReturn(0);
    when(searchResponse.nbPages).thenReturn(1);

    // Correctly stub the responses to return a Stream of SearchResponse
    when(hitsSearcher.responses)
        .thenAnswer((_) => Stream.value(searchResponse));

    // Initialize GlobalProvider
    globalProvider = GlobalProvider();
  });

  tearDown(() {
    // Reset all mock services
    reset(terminalService);
    reset(hitsSearcher);
    reset(searchResponse);

    // Reset the GlobalProvider
    globalProvider = GlobalProvider();
  });

  group("Loading Terminal search screen tests.", () {
    testWidgets("Ensure there is a X symbol to exit screen (top left)",
        (WidgetTester tester) async {
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets("Ensure the App Bar has 'Search' as the title",
        (WidgetTester tester) async {
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

      await tester.pumpAndSettle();

      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets("Ensure the search bar is present",
        (WidgetTester tester) async {
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets("Ensure the search bar has the correct placeholder text",
        (WidgetTester tester) async {
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

      await tester.pumpAndSettle();

      expect(find.text('Terminal Search'), findsOneWidget);
    });

    testWidgets("Ensure that the 'SUGGESTED TERMINALS' text is present",
        (WidgetTester tester) async {
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

      await tester.pumpAndSettle();

      expect(find.text('SUGGESTED TERMINALS'), findsOneWidget);
    });
  });

  group("Animation Terminal search screen tests.", () {
    testWidgets('Search bar is full length on initial loading',
        (WidgetTester tester) async {
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

      await tester.pumpAndSettle();

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
      double paddingSize = 2 * globalProvider.cardPadding;
      final double expectedWidth = screenSize.width - paddingSize;

      // Verify the TextField's width is as expected
      expect(textFieldWidth, expectedWidth);
    });

    testWidgets('Cancel button appears when search bar is tapped',
        (WidgetTester tester) async {
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

      await tester.pumpAndSettle();

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
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

      await tester.pumpAndSettle();

      // Find the TextField widget
      final Finder textFieldFinder = find.byType(TextField);

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
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

      await tester.pumpAndSettle();

      // Find the TextField widget
      final Finder textFieldFinder = find.byType(TextField);

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
      double paddingSize = 2 * globalProvider.cardPadding;
      final double expectedWidth = screenSize.width - paddingSize;

      // Verify the TextField's width is as expected
      expect(textFieldWidth, expectedWidth);
    });

    testWidgets('Text in Search bar is cleared when Cancel button is tapped.',
        (WidgetTester tester) async {
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

      await tester.pumpAndSettle();

      // Find the TextField widget
      final Finder textFieldFinder = find.byType(TextField);

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
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

      await tester.pumpAndSettle();
      // Find the TextField widget
      final Finder textFieldFinder = find.byType(TextField);

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
      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      await tester.pumpWidget(MaterialApp(
          home: Provider(
              create: (_) => globalProvider,
              child: TerminalSearchScreen(
                terminalService: terminalService,
                customHitsSearcher: hitsSearcher,
              ))));

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

  group("Results list", () {
    testWidgets("Ensure all terminals are displayed when search bar is empty",
        (WidgetTester tester) async {
      final terminalService = MockTerminalService();
      final hitsSearcher = MockHitsSearcher();
      final searchResponse = MockSearchResponse();

      // Get screen measurements
      final double screenWidth = tester.view.physicalSize.width;
      final double shortestSide = tester.view.physicalSize.shortestSide;

      // Initialize GlobalProvider
      GlobalProvider globalProvider = GlobalProvider();
      globalProvider.setDynamicSizes(screenWidth, shortestSide);

      // Setup mock data response for the searchResponse
      // Note: Assuming the Hit constructor and setup match your model requirements
      when(searchResponse.hits).thenReturn([
        Hit({
          'name': 'Terminal 1',
          'location': 'Location 1',
          'group': 'Command 1',
          'timezone': 'Timezone 1'
        }),
        Hit({
          'name': 'Terminal 2',
          'location': 'Location 2',
          'group': 'Command 2',
          'timezone': 'Timezone 2'
        }),
        Hit({
          'name': 'Terminal 3',
          'location': 'Location 3',
          'group': 'Command 3',
          'timezone': 'Timezone 3'
        })
      ]);
      when(searchResponse.page).thenReturn(0);
      when(searchResponse.nbPages).thenReturn(1);

      // Correctly stub the responses to return a Stream of SearchResponse
      when(hitsSearcher.responses)
          .thenAnswer((_) => Stream.value(searchResponse));

      // Define the MaterialApp to set a context with MediaQuery
      await tester.pumpWidget(MaterialApp(
        home: Provider<GlobalProvider>(
          create: (context) => globalProvider,
          child: TerminalSearchScreen(
            terminalService: terminalService,
            customHitsSearcher: hitsSearcher,
          ),
        ),
      ));
      // Execute the pump to build the widget
      await tester.pumpAndSettle();

      final customScrollView = find.byType(CustomScrollView);

      // Find the terminals by their Key
      final Finder terminal1Finder = find.text('Terminal 1');
      final Finder terminal1LocationFinder = find.text('Location 1');

      final Finder terminal2Finder = find.text('Terminal 2');
      final Finder terminal2LocationFinder = find.text('Location 2');

      final Finder terminal3Finder = find.text('Terminal 3');
      final Finder terminal3LocationFinder = find.text('Location 3');

      // Ensure terminal 1 is found
      // Location should be right below the terminal name
      expect(terminal1Finder, findsOneWidget);
      expect(terminal1LocationFinder, findsOneWidget);

      // Scroll to the next terminal
      await tester.dragUntilVisible(
          terminal2Finder, customScrollView, const Offset(0, -500));

      await tester.pumpAndSettle();

      // Ensure terminal 2 is found
      // Location should be right below the terminal name
      expect(terminal2Finder, findsOneWidget);
      expect(terminal2LocationFinder, findsOneWidget);

      // Scroll to the next terminal
      await tester.dragUntilVisible(
          terminal3Finder, customScrollView, const Offset(0, -500));

      // Ensure terminal 3 is found
      // Location should be right below the terminal name
      expect(terminal3Finder, findsOneWidget);
      expect(terminal3LocationFinder, findsOneWidget);
    });
  });
}
