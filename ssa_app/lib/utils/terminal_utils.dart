import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ssa_app/models/terminal.dart';

class TerminalService {
  final FirebaseFirestore _firestore;

  TerminalService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Terminal>> getTerminals() async {
    List<Terminal> terminals = [];
    try {
      var docs = await getTerminalDocs();
      for (var doc in docs) {
        try {
          // Attempt to parse the document into a Terminal object
          var terminal = getTerminalFromDoc(doc);
          terminals.add(terminal);
        } catch (e) {
          // If an error occurs, skip this document and continue with the next
          debugPrint("Error converting document to Terminal: $e");
        }
      }
      return terminals;
    } catch (e) {
      // Handle errors or exceptions that may occur during the fetch of documents
      debugPrint("Error loading terminals from Firestore: $e");
      return [];
    }
  }

  Terminal getTerminalFromDoc(QueryDocumentSnapshot doc) {
    return Terminal.fromDocumentSnapshot(doc);
  }

  Future<List<QueryDocumentSnapshot>> getTerminalDocs() async {
    var collection = _firestore.collection('Terminals');
    var querySnapshot = await collection.get();
    return querySnapshot.docs;
  }
}
