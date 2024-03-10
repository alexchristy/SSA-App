import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ssa_app/screens/terminal-detail-page/terminal_detail_screen.dart';
import 'package:ssa_app/utils/image_utils.dart';
import 'package:ssa_app/utils/terminal_utils.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:ssa_app/models/terminal.dart';
import 'package:ssa_app/models/filter.dart';
import 'package:ssa_app/screens/terminal-list/list_filters_widget.dart';

// Terminal Location Filters
List<Filter> filters = [
  Filter(id: "CENTCOM TERMINALS", name: "Middle East"),
  Filter(id: "AMC CONUS TERMINALS", name: "USA"),
  Filter(id: "EUCOM TERMINALS", name: "Europe"),
  Filter(id: "INDOPACOM TERMINALS", name: "Asia-Pacific"),
  Filter(id: "SOUTHCOM TERMINALS", name: "South America"),
  Filter(id: "NON-AMC CONUS TERMINALS", name: "Non-AMC"),
  Filter(id: "ANG & RESERVE TERMINALS", name: "ANG & Reserve"),
];

class TerminalsList extends StatefulWidget {
  final TerminalService terminalService;

  // If TerminalService is passed, use it; otherwise, create a new instance
  TerminalsList({super.key, TerminalService? terminalService})
      : terminalService = terminalService ?? TerminalService();

  @override
  State<TerminalsList> createState() => _TerminalsListState();
}

class _TerminalsListState extends State<TerminalsList> {
  List<String> selectedGroupIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terminals")),
      body: Column(
        children: [
          TerminalFilterWidget(
            filters: filters, // Assuming 'filters' is already defined somewhere
            onFiltersSelected: (List<String> groupIds) {
              setState(() {
                selectedGroupIds = groupIds;
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<Terminal>>(
              future: widget.terminalService.getTerminalsByGroups(
                groups: selectedGroupIds,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.data!.isEmpty) {
                  return const Center(child: Text("No terminals found."));
                } else {
                  return buildTerminalList(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTerminalList(
      BuildContext context, AsyncSnapshot<List<Terminal>> snapshot) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double tileWidth = getTileWidth(screenWidth);
    final double tileHeight =
        getTileHeight(MediaQuery.of(context).size.shortestSide);

    final double listEdgePadding = (screenWidth - tileWidth) / 2;

    // Build your list view here based on the snapshot.data
    return Padding(
        padding: EdgeInsets.only(top: listEdgePadding),
        child: ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return TerminalListItem(
              terminal: snapshot.data![index],
              screenWidth: screenWidth,
              tileWidth: tileWidth,
              tileHeight: tileHeight,
              egdePadding: listEdgePadding,
            );
          },
        ));
  }

  void clearImageCache() {
    DefaultCacheManager().emptyCache();
  }

  double getTileWidth(double screenWidth) {
    return ((screenWidth * 0.9) / 2).ceil() * 2; // Ensure it's an even number
  }

  // Calculate the tile height based on the shortest side of the screen
  // and the tile width.
  double getTileHeight(double shortestSide) {
    double portraitTileWidth = getTileWidth(shortestSide);
    return (portraitTileWidth * 0.36).ceilToDouble();
  }
}

class TerminalListItem extends StatefulWidget {
  final double screenWidth, tileWidth, tileHeight, egdePadding;
  final Terminal terminal;

  const TerminalListItem({
    super.key,
    required this.terminal,
    required this.screenWidth,
    required this.tileWidth,
    required this.tileHeight,
    required this.egdePadding,
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
        left: widget.egdePadding,
        right: widget.egdePadding,
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
        imageUrl, widget.tileHeight, widget.tileHeight, context);

    // If the image variant URL is empty, this means
    // the link from the DB is invalid or the image is not available.
    if (imageVariantUrl.isEmpty) {
      return buildFallbackImageWidget();
    }

    return SizedBox(
        height: widget.tileHeight,
        width: widget.tileHeight,
        child: CachedNetworkImage(
          imageUrl: imageVariantUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: AppColors.white),
          errorWidget: (context, url, error) => buildFallbackImageWidget(),
          fadeInDuration: const Duration(milliseconds: 300),
        ));
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
        // Use a Column to ensure the text is top-aligned if it doesn't occupy all the available lines.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.terminal.getName(),
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              maxLines: 2, // Limit the text to 2 lines.
              overflow:
                  TextOverflow.ellipsis, // Show ellipsis if the text overflows.
            ),
          ],
        ),
      ),
    );
  }
}
