import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ssa_app/screens/terminal-detail-page/terminal_detail_screen.dart';
import 'package:ssa_app/utils/image_utils.dart';
import 'package:ssa_app/utils/terminal_utils.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:ssa_app/models/terminal.dart';
import 'package:ssa_app/models/filter.dart';
import 'package:ssa_app/screens/terminal-list/list_filters_widget.dart';
import 'package:ssa_app/screens/terminal-search/terminal_search_screen.dart';
import 'package:ssa_app/transitions/slide_up_transition.dart';
import 'package:ssa_app/providers/global_provider.dart';
import 'package:provider/provider.dart';

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
  bool isLoading = false;
  String? errorMessage;
  bool downloadedTerminals = false;
  bool showLoadingIndicator = false;

  @override
  void initState() {
    super.initState();
    downloadedTerminals =
        Provider.of<GlobalProvider>(context, listen: false).downloadedTerminals;

    if (!downloadedTerminals) {
      _loadTerminals(fromCache: false);
      Provider.of<GlobalProvider>(context, listen: false).downloadedTerminals =
          true;
    } else {
      _loadTerminals(fromCache: true);
    }
  }

  void _loadTerminals({bool fromCache = true}) async {
    isLoading = true;
    const int delayBeforeShowingIndicator = 100; // Delay in milliseconds
    showLoadingIndicator =
        false; // Reset this flag each time the method is called

    setState(() {
      errorMessage = null; // Reset error message at the start
    });

    // Start a timer that will set showLoadingIndicator to true after the specified delay
    Future.delayed(const Duration(milliseconds: delayBeforeShowingIndicator),
        () {
      if (!mounted || !isLoading) {
        return; // Check if the widget is still in the tree
      }
      setState(() {
        showLoadingIndicator = true;
      });
    });

    try {
      List<Terminal> terminals = await widget.terminalService
          .getTerminalsByGroups(groups: selectedGroupIds, fromCache: fromCache);
      if (!mounted) {
        return; // Ensure the widget is still mounted before updating the state
      }
      setState(() {
        filteredTerminals = terminals;
        isLoading = false;
        showLoadingIndicator =
            false; // Ensure the loading indicator is hidden after terminals are loaded
      });

      // Save the loaded terminals to the global provider only
      // if we have not loaded them before
      if (!downloadedTerminals) {
        // Map Name --> Terminal
        Provider.of<GlobalProvider>(context, listen: false).terminals = {
          for (var item in terminals) (item).name: item
        };
      }
    } catch (e) {
      if (!mounted) {
        return; // Check if the widget is still in the tree before setting state
      }
      setState(() {
        errorMessage =
            "Failed to load terminals. Check your connection and try again.";
        isLoading = false;
        showLoadingIndicator =
            false; // Ensure the loading indicator is hidden on error as well
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double tileWidth = Provider.of<GlobalProvider>(context).cardWidth;
    final double tileHeight = Provider.of<GlobalProvider>(context).cardHeight;
    final double edgePadding = Provider.of<GlobalProvider>(context).cardPadding;
    final double topFilterPadding = (0.8 * edgePadding).floorToDouble();

    return Scaffold(
      appBar: buildAppBar(context, edgePadding: edgePadding),
      body: Stack(
        children: [
          buildList(
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            listEdgePadding: edgePadding,
            topFilterPadding: topFilterPadding,
          ),
          // Overlay the loading indicator when loading
          if (showLoadingIndicator)
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
          title: Text("Terminals", style: GoogleFonts.ubuntu(fontSize: 24.0)),
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
                  navigateToSearchScreen(context);
                },
              ),
            ),
          ],
          // Applying the customized theme to the AppBar
          iconTheme: appBarTheme.iconTheme,
          actionsIconTheme: appBarTheme.actionsIconTheme,
        ));
  }

  void navigateToSearchScreen(BuildContext context) {
    Navigator.of(context)
        .push(SlideUpTransition(builder: (context) => TerminalSearchScreen()));
  }

  Widget buildList(
      {double tileWidth = 0.0,
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
      {double tileWidth = 0.0,
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
}

class TerminalListItem extends StatefulWidget {
  final double tileWidth, tileHeight, egdePadding;
  final Terminal terminal;

  const TerminalListItem({
    super.key,
    required this.terminal,
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
                  TerminalDetailPage(terminal: widget.terminal),
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
              style: GoogleFonts.ubuntu(
                  fontSize: 18.0, fontWeight: FontWeight.bold),
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
