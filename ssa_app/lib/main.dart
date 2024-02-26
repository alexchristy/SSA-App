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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'logger.dart'; // Import the logger setup

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure plugin services are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLogging();
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
        cardColor: Colors.white,
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
      'pdf72HourHash': '72 Hour Schedule',
      'pdf30DayHash': '30 Day Schedule',
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
    final tileWidth = getTileWidth(screenWidth);
    final tileHeight = getTileHeight(tileWidth);
    final imageWidth = tileHeight
        .toDouble(); // Use the tile height as the image width for a square image

    return Scaffold(
      appBar: AppBar(title: const Text("Terminals")),
      backgroundColor: const Color.fromRGBO(
          242, 242, 247, 1.0), // Use a light gray background
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
                if (terminalImageUrl != null && terminalImageUrl.isNotEmpty) {
                  terminalImageUrl = getTerminalImageVariant(terminalImageUrl,
                      imageWidth, tileHeight.toDouble(), context);
                  // Preload images for the next 5 terminals
                  for (int i = 1; i <= 5; i++) {
                    if (index + i < snapshot.data!.length) {
                      var nextDoc = snapshot.data![index + i].data()
                          as Map<String, dynamic>;
                      String? nextImageUrl = nextDoc['terminalImageUrl'];
                      if (nextImageUrl != null && nextImageUrl.isNotEmpty) {
                        nextImageUrl = getTerminalImageVariant(nextImageUrl,
                            imageWidth, tileHeight.toDouble(), context);
                        final imageProvider =
                            CachedNetworkImageProvider(nextImageUrl);
                        precacheImage(imageProvider, context);
                      }
                    }
                  }
                }
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: 16.0, // Adjusted for demonstration
                    left: (screenWidth - tileWidth) / 2, // Center the tile
                    right: (screenWidth - tileWidth) / 2,
                  ),
                  child: RepaintBoundary(
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0.0,
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
                                    ? CachedNetworkImage(
                                        imageUrl: terminalImageUrl,
                                        width: imageWidth,
                                        height: tileHeight.toDouble(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(color: Colors.white),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        fadeInDuration:
                                            const Duration(milliseconds: 300),
                                      )
                                    : Container(
                                        color: Colors.white,
                                        height: tileHeight.toDouble(),
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
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        doc['name'] ?? 'Unknown',
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      )
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

  void clearImageCache() {
    DefaultCacheManager().emptyCache();
  }

  int getTileWidth(double screenWidth) {
    return ((screenWidth * 0.9) / 2).ceil() * 2; // Ensure it's an even number
  }

  int getTileHeight(int tileWidth) {
    return (tileWidth * 0.35).ceil(); // 35% tall of the tile width
  }

  // Function to select the appropriate image variant
  String getTerminalImageVariant(String baseUrl, double requiredWidth,
      double requiredHeight, BuildContext context) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Adjust required dimensions according to the pixel ratio
    final adjustedWidth = requiredWidth * pixelRatio;
    final adjustedHeight = requiredHeight * pixelRatio;

    appWideLogger.finest(
        "Adjusted width: $adjustedWidth, adjusted height: $adjustedHeight");

    const variants = [
      150,
      200,
      250,
      300,
      350,
      400,
      450,
      500,
      600,
      700,
      750,
    ]; // Image size variants

    int requiredSize = 400;

    if (adjustedWidth >= adjustedHeight) {
      requiredSize = adjustedWidth.ceil(); // Use the larger dimension
    } else {
      requiredSize = adjustedHeight.ceil(); // Use the larger dimension
    }

    for (final variant in variants) {
      if (requiredSize <= variant) {
        return "${baseUrl}terminal$variant"; // Use the first variant that's larger than or equal to the required width
      }
    }

    // Default to 400
    return "${baseUrl}terminal400";
  }

  Future<List<QueryDocumentSnapshot>> getTerminals() async {
    var collection = FirebaseFirestore.instance.collection('Terminals');
    var querySnapshot = await collection.get();
    return querySnapshot.docs;
  }
}
