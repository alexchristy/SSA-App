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
import 'package:ssa_app/screens/terminal-search/terminal_search_screen.dart';
import 'package:ssa_app/transitions/slide_up_transition.dart';

// Terminal Location Filters
List<Filter> filters = [
  Filter(id: "AMC CONUS TERMINALS", name: "USA"),
  Filter(id: "EUCOM TERMINALS", name: "Europe"),
  Filter(id: "INDOPACOM TERMINALS", name: "Asia-Pacific"),
  Filter(id: "CENTCOM TERMINALS", name: "Middle East"),
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
  List<Terminal> filteredTerminals = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTerminals();
  }

  void _loadTerminals({fromCache = true}) async {
    const int delayBeforeShowingIndicator = 50; // Delay in milliseconds
    bool showIndicator = true;

    setState(() {
      errorMessage = null;
    });

    // Delay showing the loading indicator
    Future.delayed(const Duration(milliseconds: delayBeforeShowingIndicator))
        .then((_) {
      if (showIndicator) {
        setState(() {
          isLoading = true;
        });
      }
    });

    try {
      List<Terminal> terminals = await widget.terminalService
          .getTerminalsByGroups(groups: selectedGroupIds, fromCache: fromCache);

      // By the time terminals are fetched, decide not to show the indicator if loaded quickly
      showIndicator = false;

      setState(() {
        filteredTerminals = terminals;
        isLoading =
            false; // Ensure isLoading is set to false in case it was set to true
      });
    } catch (e) {
      setState(() {
        errorMessage =
            "Failed to load terminals. Check your connection and try again.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double tileWidth = getTileWidth(screenWidth);
    final double tileHeight =
        getTileHeight(MediaQuery.of(context).size.shortestSide);
    final double listEdgePadding =
        ((screenWidth - tileWidth) / 2).floorToDouble();
    final double topFilterPadding = (0.8 * listEdgePadding).floorToDouble();

    return Scaffold(
      appBar: buildAppBar(context, edgePadding: listEdgePadding),
      body: Stack(
        children: [
          buildList(
            screenWidth: screenWidth,
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            listEdgePadding: listEdgePadding,
            topFilterPadding: topFilterPadding,
          ),
          // Overlay the loading indicator when loading
          if (isLoading && errorMessage == null)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.prussianBlue,
                ),
              ),
            ),
          // Display a message when no terminals are found
          if (filteredTerminals.isEmpty && !isLoading && errorMessage == null)
            const Positioned.fill(
              child: Center(
                child: Text(
                  "No terminals found.",
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ),
          // Display an error message if loading fails
          if (errorMessage != null)
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Use min to fit content size
                  children: [
                    const Icon(
                      Icons.error, // Example icon
                      size: 64.0, // Icon size
                      color: AppColors.errorRed,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24.0, color: AppColors.errorRed),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context, {double edgePadding = 8.0}) {
    // Calculate the app bar height with consideration for the icon size and padding
    double baseAppBarHeight = 50.0;

    // Customizing the AppBar theme locally
    final appBarTheme = Theme.of(context).appBarTheme.copyWith(
          iconTheme: const IconThemeData(
            size: 32, // Set your desired back arrow icon size
          ),
          actionsIconTheme: const IconThemeData(
            size:
                32, // Set your desired action icon size, affects the search icon here
          ),
        );

    return PreferredSize(
        preferredSize: Size.fromHeight(baseAppBarHeight),
        child: AppBar(
          backgroundColor: AppColors.ghostWhite,
          title: const Text("Terminals", style: TextStyle(fontSize: 32.0)),
          leading: Padding(
            // Apply left padding to the leading icon
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: edgePadding),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).push(SlideUpTransition(
                      builder: (context) => const TerminalSearchScreen()));
                },
              ),
            ),
          ],
          // Applying the customized theme to the AppBar
          iconTheme: appBarTheme.iconTheme,
          actionsIconTheme: appBarTheme.actionsIconTheme,
        ));
  }

  Widget buildList(
      {double screenWidth = 0.0,
      double tileWidth = 0.0,
      double tileHeight = 0.0,
      double listEdgePadding = 0.0,
      double topFilterPadding = 0.0}) {
    return RefreshIndicator(
        onRefresh: () async {
          _loadTerminals(fromCache: false);
        },
        child: CustomScrollView(
          slivers: [
            buildListFilters(
                topFilterPadding: topFilterPadding,
                listEdgePadding: listEdgePadding),
            buildTerminalList(
                screenWidth: screenWidth,
                tileWidth: tileWidth,
                tileHeight: tileHeight,
                listEdgePadding: listEdgePadding),
          ],
        ));
  }

  Widget buildListFilters(
      {double topFilterPadding = 0.0, double listEdgePadding = 0.0}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            EdgeInsets.only(top: topFilterPadding, bottom: listEdgePadding),
        child: TerminalFilterWidget(
          filters: filters, // Assume `filters` is defined globally or passed in
          onFiltersSelected: (List<String> groupIds) {
            setState(() {
              selectedGroupIds = groupIds;
              _loadTerminals(); // Reload terminals based on the new filters
            });
          },
          edgePadding: listEdgePadding,
        ),
      ),
    );
  }

  Widget buildTerminalList(
      {double screenWidth = 0.0,
      double tileWidth = 0.0,
      double tileHeight = 0.0,
      double listEdgePadding = 0.0}) {
    if (isLoading) {
      return const SliverFillRemaining();
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final terminal = filteredTerminals[index];
            return TerminalListItem(
              terminal: terminal,
              screenWidth: screenWidth,
              tileWidth: tileWidth,
              tileHeight: tileHeight,
              egdePadding: listEdgePadding,
            );
          },
          childCount: filteredTerminals.length,
        ),
      );
    }
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
      key: const Key('fallback_image_widget'),
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
