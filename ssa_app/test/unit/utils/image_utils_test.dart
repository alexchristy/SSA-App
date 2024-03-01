import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssa_app/utils/image_utils.dart';

void main() {
  group('ImageUtil.getTerminalImageVariant', () {
    testWidgets('returns correct image variant based on pixel ratio',
        (WidgetTester tester) async {
      // Define a test widget that uses MediaQuery
      Widget testWidget({required double pixelRatio}) {
        return MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              const baseUrl = 'https://example.com/';
              final imageUrl =
                  ImageUtil.getTerminalImageVariant(baseUrl, 200, 200, context);
              return Text(imageUrl);
            },
          ),
        );
      }

      // Simulate different device pixel ratios
      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(devicePixelRatio: 1.0),
        child: testWidget(pixelRatio: 1.0),
      ));
      expect(find.text('https://example.com/terminal200'), findsOneWidget);

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(devicePixelRatio: 2.0),
        child: testWidget(pixelRatio: 2.0),
      ));
      expect(find.text('https://example.com/terminal400'), findsOneWidget);

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(devicePixelRatio: 3.0),
        child: testWidget(pixelRatio: 3.0),
      ));
      // Assuming your logic for selecting a variant, adjust the expected URL accordingly
      expect(find.text('https://example.com/terminal600'), findsOneWidget);

      await tester.pumpWidget(MediaQuery(
          data: const MediaQueryData(devicePixelRatio: 4.0),
          child: testWidget(pixelRatio: 4.0)));
      expect(find.text('https://example.com/terminal750'), findsOneWidget,
          reason:
              'Since there is no variant for 800px wide, it should return 750px wide variant should be used by default.');
    });
    testWidgets(
        'Chooses a variant that larger than the largest dimension between width and height',
        (WidgetTester tester) async {
      // Define a test widget that uses MediaQuery
      Widget testWidget({required double pixelRatio}) {
        return MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              const baseUrl = 'https://example.com/';
              final imageUrl =
                  ImageUtil.getTerminalImageVariant(baseUrl, 100, 200, context);
              return Text(imageUrl);
            },
          ),
        );
      }

      // Simulate different device pixel ratios
      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(devicePixelRatio: 1.0),
        child: testWidget(pixelRatio: 1.0),
      ));
      expect(find.text('https://example.com/terminal200'), findsOneWidget);

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(devicePixelRatio: 2.0),
        child: testWidget(pixelRatio: 2.0),
      ));
      expect(find.text('https://example.com/terminal400'), findsOneWidget);

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(devicePixelRatio: 3.0),
        child: testWidget(pixelRatio: 3.0),
      ));
      // Assuming your logic for selecting a variant, adjust the expected URL accordingly
      expect(find.text('https://example.com/terminal600'), findsOneWidget);

      await tester.pumpWidget(MediaQuery(
          data: const MediaQueryData(devicePixelRatio: 4.0),
          child: testWidget(pixelRatio: 4.0)));
      expect(find.text('https://example.com/terminal750'), findsOneWidget,
          reason:
              'Since there is no variant for 800px wide, it should return 750px wide variant should be used by default.');
    });

    testWidgets('throws ArgumentError if requiredWidth or requiredHeight is 0',
        (WidgetTester tester) async {
      // Define a test widget that uses MediaQuery
      Widget testWidget(
          {required double requiredWidth, required double requiredHeight}) {
        return MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              const baseUrl = 'https://example.com/';
              return Text(() {
                try {
                  ImageUtil.getTerminalImageVariant(
                      baseUrl, requiredWidth, requiredHeight, context);
                } on ArgumentError catch (e) {
                  return e.message;
                }
              }());
            },
          ),
        );
      }

      // Simulate different device pixel ratios
      await tester
          .pumpWidget(testWidget(requiredWidth: 0, requiredHeight: 200));
      expect(find.text('requiredWidth and requiredHeight must be positive'),
          findsOneWidget);

      await tester
          .pumpWidget(testWidget(requiredWidth: 200, requiredHeight: 0));
      expect(find.text('requiredWidth and requiredHeight must be positive'),
          findsOneWidget);
    });

    testWidgets('throws ArgumentError if baseUrl is empty',
        (WidgetTester tester) async {
      // Define a test widget that uses MediaQuery
      Widget testWidget() {
        return MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Text(() {
                try {
                  ImageUtil.getTerminalImageVariant('', 200, 200, context);
                } on ArgumentError catch (e) {
                  return e.message;
                }
              }());
            },
          ),
        );
      }

      await tester.pumpWidget(testWidget());
      expect(find.text('baseUrl cannot be empty'), findsOneWidget);
    });
  });
}
