import 'package:flutter/foundation.dart';
import 'package:ssa_app/models/terminal.dart';

class GlobalProvider with ChangeNotifier {
  bool downloadedTerminals = false;
  Map<String, Terminal> terminals = {};
}
