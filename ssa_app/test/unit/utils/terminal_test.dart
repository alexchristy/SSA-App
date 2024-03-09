import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssa_app/utils/terminal_utils.dart';
import 'package:ssa_app/models/terminal.dart';

void main() {
  group("Terminal object tests.", () {
    test(
        "Test that terminal objects are built from firestore terminal documents.",
        () async {
      final FakeFirebaseFirestore firestore = FakeFirebaseFirestore();

      final Map<String, dynamic> terminalData = {
        "archiveDir": "",
        "group": "Group 1",
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
        "terminalImageUrl": "https://example.com/terminal1/image.jpg",
        "timezone": "America/New_York",
      };

      // Add a terminal document to the fake firestore
      await firestore.collection("Terminals").add(terminalData);

      // Get the terminal document from the fake firestore
      List<Terminal> terminals =
          await TerminalService(firestore: firestore).getTerminals();

      // Test that the terminal object was built correctly
      expect(terminals.length, 1);
      expect(terminalData, terminals[0].toMap());
    });
  });
}
