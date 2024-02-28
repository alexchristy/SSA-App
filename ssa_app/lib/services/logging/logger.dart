import 'package:logging/logging.dart';

final Logger appWideLogger = Logger('AppLogger');

void setupLogging() {
  Logger.root.level = Level.INFO; // Capture logs at all levels
  Logger.root.onRecord.listen((record) {
    // Customize log output format here
    print(
        '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });
}
