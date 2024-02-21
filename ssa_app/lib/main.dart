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

class TerminalDetailPage extends StatelessWidget {
  final Map<String, dynamic> terminalData;

  const TerminalDetailPage({super.key, required this.terminalData});

  @override
  Widget build(BuildContext context) {
    // Helper function to check if hash is not empty and return a widget for the timestamp
    Widget buildTimestampInfo(
        String hashKey, String timestampKey, String label) {
      // Check if the PDF hash is not empty
      if (terminalData[hashKey].toString().isNotEmpty) {
        // If not empty, return the timestamp info widget
        return Text(
            '$label: ${terminalData[timestampKey].toDate().toString()}');
      }
      // If the hash is empty, return an empty Container (no widget)
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(terminalData['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${terminalData['location']}'),
            Text('Group: ${terminalData['group']}'),
            // Dynamically display timestamps based on hash presence
            buildTimestampInfo('pdf30DayHash', 'last30DayUpdateTimestamp',
                'Last 30 Day Update'),
            buildTimestampInfo('pdf72HourHash', 'last72HourUpdateTimestamp',
                'Last 72 Hour Update'),
            buildTimestampInfo('pdfRollcallHash', 'lastRollcallUpdateTimestamp',
                'Last Rollcall Update'),
            // Continue with other fields...
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
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
              return Card(
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      4.0), // Match this with InkWell's borderRadius
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TerminalDetailPage(
                          terminalData: doc.data()
                              as Map<String, dynamic>, // Pass the terminal data
                        ),
                      ),
                    );
                  },
                  // Use ClipRRect to clip the ripple effect to the card's border radius
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        4.0), // Ensure this matches the Card's borderRadius
                    child: Material(
                      type: MaterialType.transparency, // Use transparency
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc['name'], // Assuming each document has a 'name' field
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                                doc['location']), // Assuming a 'location' field
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
