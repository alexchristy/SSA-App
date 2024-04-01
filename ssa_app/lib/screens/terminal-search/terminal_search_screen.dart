import 'package:flutter/material.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ssa_app/utils/terminal_utils.dart';
import 'package:flutter_mimir/flutter_mimir.dart';

class TerminalSearchScreen extends StatefulWidget {
  final TerminalService terminalService;
  final double terminalCardHeight;

  TerminalSearchScreen({
    super.key,
    TerminalService? terminalService,
    required this.terminalCardHeight,
  }) : terminalService = terminalService ?? TerminalService();

  @override
  TerminalSearchScreenState createState() => TerminalSearchScreenState();
}

class TerminalSearchScreenState extends State<TerminalSearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _showCancelButton = false;
  late MimirIndex _mimirIndex;
  bool _isMimirInitialized = false;
  final PagingController<int, Map<String, dynamic>> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    initializeMimir().then((index) {
      setState(() {
        _mimirIndex = index;
        _isMimirInitialized = true;
      });
    });

    _searchTextController.addListener(_searchTerminals);
    _pagingController.addPageRequestListener(_loadMoreTerminals);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_showCancelButton) {
        _animationController.forward();
        setState(() => _showCancelButton = true);
      } else if (!_focusNode.hasFocus && _showCancelButton) {
        _animationController.reverse();
        setState(() => _showCancelButton = false);
      }
    });
  }

  Future<MimirIndex> initializeMimir() async {
    final instance = await Mimir.defaultInstance;
    _mimirIndex = await instance.openIndex('Terminals', primaryKey: 'localId');

    // Build the index with terminal data
    final terminalData = await widget.terminalService.getTerminals();
    for (final terminal in terminalData) {
      final terminalMap = terminal.getSearchMap();
      await _mimirIndex.addDocument(terminalMap);
    }
    return _mimirIndex;
  }

  void _searchTerminals() {
    if (_searchTextController.text.isEmpty) {
      return;
    }

    final query = _searchTextController.text;

    // Assuming a simple search without pagination for the initial search
    _mimirIndex
        .search(
      query: query,
      resultsLimit: 20,
    )
        .then((results) {
      // Assuming `results` is a list of maps
      final terminals = List<Map<String, dynamic>>.from(results);
      _pagingController.itemList = terminals;
    }).catchError((error) {
      debugPrint("Error searching terminals: $error");
    });
  }

  void _loadMoreTerminals(int pageKey) {
    final query = _searchTextController.text;
    // Implementing pagination logic with Mimir search, assuming `pageKey` is used for pagination
    // This is a simplified version. Adjust according to your pagination strategy.
    _mimirIndex
        .search(
      query: query,
      // Assuming `pageKey` corresponds to offset for demonstration purposes
      resultsLimit: 20, // Limit for each page
    )
        .then((results) {
      final terminals = List<Map<String, dynamic>>.from(results);
      final isLastPage = terminals.length < 20; // Assuming 20 is the page size
      if (isLastPage) {
        _pagingController.appendLastPage(terminals);
      } else {
        _pagingController.appendPage(terminals, pageKey + 1);
      }
    }).catchError((error) {
      print("Error loading more terminals: $error");
      _pagingController.error = error;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchTextController.dispose();
    _animationController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          searchBarSection(), // This remains non-scrollable at the top
          Expanded(
            // This makes everything inside it scrollable
            child: CustomScrollView(
              slivers: [
                if (_searchTextController
                    .text.isEmpty) // Conditionally include this
                  SliverToBoxAdapter(
                    child:
                        suggestedText(), // Non-scrollable text becomes part of the scrollable area
                  ),
                _isMimirInitialized
                    ? _hits(context)
                    : const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ), // This method should return a Sliver widget to be compatible
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget suggestedText() {
    return const Padding(
      padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0, right: 16.0),
      child: Text(
        'SUGGESTED TERMINALS',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: AppColors.prussianBlue,
        ),
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
        ));

    return PreferredSize(
        preferredSize: Size.fromHeight(baseAppBarHeight),
        child: AppBar(
          surfaceTintColor: AppColors.white,
          backgroundColor: AppColors.white,
          title: const Text(
            "Search",
            style: TextStyle(fontSize: 24.0),
            overflow: TextOverflow.ellipsis,
          ),
          leading: Padding(
            // Apply left padding to the leading icon
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Applying the customized theme to the AppBar
          iconTheme: appBarTheme.iconTheme,
          actionsIconTheme: appBarTheme.actionsIconTheme,
        ));
  }

  Widget searchBarSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0), // Apply horizontal padding to the search bar
          child: searchBarAndCancelBtn(),
        )
      ],
    );
  }

  Widget searchBarAndCancelBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            focusNode: _focusNode,
            controller: _searchTextController,
            decoration: const InputDecoration(
              fillColor: AppColors.white,
              filled: true,
              labelText: 'Terminal Search',
              labelStyle: TextStyle(
                fontSize: 18.0,
                overflow: TextOverflow.ellipsis,
              ),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  )),
              hintText: 'Name, location, or command',
              hintStyle: TextStyle(
                fontSize: 18.0,
                overflow: TextOverflow.ellipsis,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(
                  color: AppColors.greenBlue,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _opacityAnimation,
          axis: Axis.horizontal,
          axisAlignment: -1.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton(
              onPressed: () {
                _searchTextController.clear();
                _focusNode.unfocus();
                if (_showCancelButton) {
                  _animationController.reverse();
                  setState(() {
                    _showCancelButton = false;
                  });
                }
              },
              child: const Text('Cancel',
                  style:
                      TextStyle(fontSize: 16.0, color: AppColors.prussianBlue)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _hits(BuildContext context) {
    return PagedSliverList<int, Map<String, dynamic>>.separated(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
        itemBuilder: (context, item, index) => terminalResult(context, item),
        noItemsFoundIndicatorBuilder: (_) => const Center(
          child: Text(
            'No results found.',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
      separatorBuilder: (context, index) =>
          const Divider(), // Add dividers between items
    );
  }

  Widget terminalResult(
      BuildContext context, Map<String, dynamic> terminalData) {
    return InkWell(
        onTap: () {
          // TODO: Create map of terminal name to terminal data maps
        },
        child: Column(children: [
          SizedBox(
              height: getTerminalResultHeight(),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: stackedTerminalInfo(terminalData),
                ),
              )),
        ]));
  }

  Widget stackedTerminalInfo(Map<String, dynamic> terminalData) {
    final resultHeight = getTerminalResultHeight();
    final textSeperatorHeight = (resultHeight * 0.08).ceilToDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        nameText(terminalData['name']),
        SizedBox(height: textSeperatorHeight),
        locationText(terminalData['location']),
      ],
    );
  }

  Widget nameText(String name) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget locationText(String location) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        location,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.ellipsis,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  double getTerminalResultHeight() {
    // 80% of the terminal card height rounded up to the nearest whole number
    return (widget.terminalCardHeight * 0.8).ceilToDouble();
  }
}
