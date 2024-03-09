import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ssa_app/models/terminal.dart';

class TerminalService {
  final FirebaseFirestore _firestore;

  TerminalService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // This method correctly assumes the Terminal class has a fromDocumentSnapshot method
  Terminal getTerminalFromDoc(QueryDocumentSnapshot doc) {
    return Terminal.fromDocumentSnapshot(doc);
  }

  Future<List<Terminal>> getTerminals() async {
    try {
      var docs = await getTerminalDocs();
      return docs.map((doc) => getTerminalFromDoc(doc)).toList();
    } catch (e) {
      // Handle errors or exceptions that may occur during the fetch
      debugPrint("Error loading terminals from Firestore: $e");
      return [];
    }
  }

  Future<List<QueryDocumentSnapshot>> getTerminalDocs() async {
    var collection = _firestore.collection('Terminals');
    var querySnapshot = await collection.get();
    return querySnapshot.docs;
  }
}
