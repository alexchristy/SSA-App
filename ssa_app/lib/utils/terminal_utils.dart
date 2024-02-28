// terminal_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TerminalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getTerminals() async {
    var collection = _firestore.collection('Terminals');
    var querySnapshot = await collection.get();
    return querySnapshot.docs;
  }
}
