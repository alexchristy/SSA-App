import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure plugin services are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TerminalsList(),
    );
  }
}

class TerminalsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terminals"),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getTerminals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              var doc = snapshot.data![index];
              return ListTile(
                title: Text(
                    doc['name']), // Assuming each document has a 'name' field
                subtitle:
                    Text(doc['description']), // Assuming a 'description' field
              );
            },
          );
        },
      ),
    );
  }

  Future<List<QueryDocumentSnapshot>> getTerminals() async {
    var collection = FirebaseFirestore.instance.collection('Terminals');
    var querySnapshot = await collection.get();
    return querySnapshot.docs;
  }
}
