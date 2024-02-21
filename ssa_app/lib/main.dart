import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure plugin services are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TerminalsList(),
    );
  }
}

class TerminalsList extends StatelessWidget {
  const TerminalsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terminals"),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getTerminals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                subtitle: Text(doc['location']),
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
