import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Import packages for downloading and viewing PDFs
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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

class TerminalDetailPage extends StatelessWidget {
  final Map<String, dynamic> terminalData;

  const TerminalDetailPage({super.key, required this.terminalData});

  @override
  Widget build(BuildContext context) {
    // All your existing method implementations (requestStoragePermission, downloadPdf, fetchPdfDetails, openPdf)

    // Existing Scaffold and body setup...
    return Scaffold(
      appBar: AppBar(
        title: Text(terminalData['name']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...buildPdfButtons(
                  context), // This dynamically creates your buttons
              // Any other widgets you want to include
            ],
          ),
        ),
      ),
    );
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<String?> downloadPdf(String url, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = path.join(dir.path, fileName);
      await Dio().download(url, filePath);
      return filePath;
    } catch (e) {
      print("Error downloading file: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchPdfDetails(String hash) async {
    var doc = await FirebaseFirestore.instance
        .collection('PDF_Archive')
        .doc(hash)
        .get();
    return doc.exists ? doc.data() : null;
  }

  void openPdf(BuildContext context, String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PDFViewPage(filePath: filePath)),
    );
  }

  List<Widget> buildPdfButtons(BuildContext context) {
    List<Widget> buttons = [];
    Map<String, String> pdfLabels = {
      'pdf30DayHash': '30 Day Schedule',
      'pdf72HourHash': '72 Hour Schedule',
      'pdfRollcallHash': 'Rollcall Schedule',
    };

    pdfLabels.forEach((hashKey, label) {
      String? hash = terminalData[hashKey];
      if (hash != null && hash.isNotEmpty) {
        buttons.add(ElevatedButton(
          child: Text(label),
          onPressed: () async {
            await requestStoragePermission();
            var pdfDetails = await fetchPdfDetails(hash);
            if (pdfDetails != null) {
              final fileName = path.basename(pdfDetails['cloud_path']);
              final filePath = await downloadPdf(pdfDetails['link'], fileName);
              if (filePath != null) {
                openPdf(context, filePath);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not download PDF.')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF details not found.')),
              );
            }
          },
        ));
      }
    });

    return buttons;
  }
}

// A new widget to display the PDF
class PDFViewPage extends StatelessWidget {
  final String filePath;

  const PDFViewPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Document"),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}

class TerminalsList extends StatelessWidget {
  const TerminalsList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileWidth =
        ((screenWidth * 0.9) / 2).ceil() * 2; // Ensure it's an even number
    final imageWidth =
        (tileWidth * 0.35).ceil().toDouble(); // 35% of tile width for the image

    return Scaffold(
      appBar: AppBar(title: const Text("Terminals")),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getTerminals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                var doc = snapshot.data![index].data() as Map<String, dynamic>;
                String? terminalImageUrl = doc['terminalImageUrl'];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: 16.0, // Adjusted for demonstration
                    left: (screenWidth - tileWidth) / 2, // Center the tile
                    right: (screenWidth - tileWidth) / 2,
                  ),
                  child: RepaintBoundary(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TerminalDetailPage(
                                terminalData: doc,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 35, // Takes up 35% of the row's space
                                child: terminalImageUrl != null &&
                                        terminalImageUrl.isNotEmpty
                                    ? Image.network(
                                        terminalImageUrl,
                                        width: imageWidth,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.white,
                                      ),
                              ),
                              Expanded(
                                flex:
                                    65, // Takes up the remaining 65% of the row's space
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize:
                                        MainAxisSize.min, // Use minimum space
                                    children: [
                                      Text(
                                        doc['name'] ?? 'Unknown',
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(doc['location'] ??
                                          'No location provided'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
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
