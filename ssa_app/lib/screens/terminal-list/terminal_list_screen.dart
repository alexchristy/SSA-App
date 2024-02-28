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
    return Scaffold(
      appBar: AppBar(title: const Text("Terminals")),
      backgroundColor: const Color.fromRGBO(242, 242, 247, 1.0),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _terminalService.getTerminals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Better error handling
            debugPrint('Error loading terminals: ${snapshot.error}');
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return buildTerminalList(context, snapshot);
          }
        },
      ),
    );
  }

  Widget buildTerminalList(BuildContext context,
      AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileWidth = getTileWidth(screenWidth);
    final tileHeight = getTileHeight(tileWidth);
    return ListView.builder(
      itemCount: snapshot.data?.length ?? 0,
      itemBuilder: (context, index) => TerminalListItem(
        doc: snapshot.data![index].data() as Map<String, dynamic>,
        screenWidth: screenWidth,
        tileWidth: tileWidth.toDouble(),
        tileHeight: tileHeight.toDouble(),
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

class TerminalListItem extends StatelessWidget {
  final Map<String, dynamic> doc;
  final double screenWidth, tileWidth, tileHeight;

  const TerminalListItem({
    Key? key,
    required this.doc,
    required this.screenWidth,
    required this.tileWidth,
    required this.tileHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? terminalImageUrl = doc['terminalImageUrl'];
    final imageWidth =
        tileHeight; // Use the tile height as the image width for a square image

    // Image URL processing
    terminalImageUrl = ImageUtil.getTerminalImageVariant(
      terminalImageUrl ?? '',
      imageWidth,
      tileHeight,
      context,
    );

    // Preload images logic can be encapsulated in a separate method if needed

    return Padding(
      padding: EdgeInsets.only(
        bottom: 16.0,
        left: (screenWidth - tileWidth) / 2,
        right: (screenWidth - tileWidth) / 2,
      ),
      child: RepaintBoundary(
        child: buildTerminalCard(context, terminalImageUrl),
      ),
    );
  }

  Widget buildTerminalCard(BuildContext context, String? terminalImageUrl) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TerminalDetailPage(terminalData: doc),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: buildCardContent(context, terminalImageUrl),
        ),
      ),
    );
  }

  Widget buildCardContent(BuildContext context, String? terminalImageUrl) {
    return Row(
      children: [
        buildImageSection(terminalImageUrl),
        buildTextSection(),
      ],
    );
  }

  Widget buildImageSection(String? imageUrl) {
    return Expanded(
      flex: 35,
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.white),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fadeInDuration: const Duration(milliseconds: 300),
            )
          : Container(color: Colors.white, height: tileHeight),
    );
  }

  Widget buildTextSection() {
    return Expanded(
      flex: 65,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          doc['name'] ?? 'Unknown',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
