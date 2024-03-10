import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ssa_app/screens/terminal-detail-page/terminal_detail_screen.dart';
import 'package:ssa_app/utils/image_utils.dart';
import 'package:ssa_app/utils/terminal_utils.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:ssa_app/models/terminal.dart';

class TerminalsList extends StatelessWidget {
  final TerminalService terminalService;

  // If TerminalService is passed, use it; otherwise, create a new instance
  TerminalsList({super.key, TerminalService? terminalService})
      : terminalService = terminalService ?? TerminalService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terminals")),
      body: FutureBuilder<List<Terminal>>(
        future: terminalService.getTerminals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Keeps the loading indicator while terminals are being loaded.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Improved error handling with user feedback.
            debugPrint('Error: ${snapshot.error}');
            return const Center(
              child: Text(
                "Failed to load terminals. Check your connection and try again.",
                textAlign: TextAlign.center,
              ),
            );
          } else {
            // Consider adding a check for an empty list and display a message if no terminals are found.
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No terminals found."),
              );
            }
            return buildTerminalList(context, snapshot);
          }
        },
      ),
    );
  }

  Widget buildTerminalList(
      BuildContext context, AsyncSnapshot<List<Terminal>> snapshot) {
    double screenWidth = MediaQuery.of(context).size.width;
    int tileWidth = getTileWidth(screenWidth);
    int tileHeight = getTileHeight(tileWidth);
    // Build your list view here based on the snapshot.data
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        Terminal terminal = snapshot.data![index];
        return TerminalListItem(
          terminal: terminal,
          screenWidth: screenWidth,
          tileWidth: tileWidth.toDouble(),
          tileHeight: tileHeight.toDouble(),
        );
      },
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

class TerminalListItem extends StatefulWidget {
  final double screenWidth, tileWidth, tileHeight;
  final Terminal terminal;

  const TerminalListItem({
    super.key,
    required this.terminal,
    required this.screenWidth,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  TerminalListItemState createState() => TerminalListItemState();
}

class TerminalListItemState extends State<TerminalListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16.0,
        left: (widget.screenWidth - widget.tileWidth) / 2,
        right: (widget.screenWidth - widget.tileWidth) / 2,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  TerminalDetailPage(terminalData: widget.terminal.toMap()),
            ),
          );
        },
        child: RepaintBoundary(
          child:
              buildTerminalCard(context, widget.terminal.getTerminalImageUrl()),
        ),
      ),
    );
  }

  Widget buildTerminalCard(BuildContext context, String? terminalImageUrl) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: buildCardContent(context, terminalImageUrl),
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
    String imageVariantUrl = ImageUtil.getTerminalImageVariant(
        imageUrl, widget.tileWidth, widget.tileHeight, context);

    // If the image variant URL is empty, this means
    // the link from the DB is invalid or the image is not available.
    if (imageVariantUrl.isEmpty) {
      return buildFallbackImageWidget();
    }

    return Expanded(
      flex: 35,
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageVariantUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.white),
              errorWidget: (context, url, error) => buildFallbackImageWidget(),
              fadeInDuration: const Duration(milliseconds: 300),
            )
          : Container(color: AppColors.white, height: widget.tileHeight),
    );
  }

  Widget buildFallbackImageWidget() {
    final double imageWidth = widget.tileHeight;
    final double imageHeight = widget.tileHeight;

    return Container(
      width: imageWidth,
      height: imageHeight,
      color: AppColors.white,
      child: Center(
        child: Icon(Icons.flight_takeoff, size: imageWidth * 0.5),
      ),
    );
  }

  Widget buildTextSection() {
    return Expanded(
      flex: 65,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          widget.terminal.getName(),
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
