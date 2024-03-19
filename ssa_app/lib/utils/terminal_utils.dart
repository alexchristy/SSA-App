import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ssa_app/models/terminal.dart';

class TerminalService {
  final FirebaseFirestore _firestore;

  TerminalService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Terminal>> getTerminals({fromCache = true}) async {
    List<Terminal> terminals = [];
    try {
      var docs = await getTerminalDocs(fromCache: fromCache);
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

  Future<List<QueryDocumentSnapshot>> getTerminalDocs(
      {fromCache = true}) async {
    var collection = _firestore.collection('Terminals');

    try {
      if (fromCache) {
        var querySnapshot =
            await collection.get(const GetOptions(source: Source.cache));
        if (querySnapshot.docs.isNotEmpty) {
          debugPrint(
              "Loaded ${querySnapshot.docs.length} terminal docs from cache");
          return querySnapshot.docs;
        }
      }

      var querySnapshot = await collection.get();
      debugPrint(
          "Loaded ${querySnapshot.docs.length} terminal docs from server");
      return querySnapshot.docs;
    }
    // Handle errors or exceptions that may occur during the fetch of documents
    catch (e) {
      debugPrint("Error loading terminal documents from Firestore: $e");
      var querySnapshot =
          await collection.get(const GetOptions(source: Source.serverAndCache));
      return querySnapshot.docs;
    }
  }

  Future<List<Terminal>> getTerminalsByGroups(
      {required List<String> groups, fromCache = true}) async {
    // Return all terminals if no groups are provided
    if (groups.isEmpty) {
      return getTerminals(fromCache: fromCache);
    }

    return getTerminals(fromCache: fromCache).then((terminals) {
      return terminals
          .where((terminal) => groups.contains(terminal.getGroup()))
          .toList();
    });
  }
}
