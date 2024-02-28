import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ssa_app/screens/terminal-detail-page/terminal_detail_screen.dart';
import 'package:ssa_app/utils/image_utils.dart';
import 'package:ssa_app/utils/terminal_utils.dart';

class TerminalsList extends StatelessWidget {
  TerminalsList({super.key});
  final TerminalService _terminalService = TerminalService();

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
        future: _terminalService.getTerminals(),
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
                  terminalImageUrl = ImageUtil.getTerminalImageVariant(
                      terminalImageUrl,
                      imageWidth,
                      tileHeight.toDouble(),
                      context);
                  // Preload images for the next 5 terminals
                  for (int i = 1; i <= 5; i++) {
                    if (index + i < snapshot.data!.length) {
                      var nextDoc = snapshot.data![index + i].data()
                          as Map<String, dynamic>;
                      String? nextImageUrl = nextDoc['terminalImageUrl'];
                      if (nextImageUrl != null && nextImageUrl.isNotEmpty) {
                        nextImageUrl = ImageUtil.getTerminalImageVariant(
                            nextImageUrl,
                            imageWidth,
                            tileHeight.toDouble(),
                            context);
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
                      child: GestureDetector(
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
}
