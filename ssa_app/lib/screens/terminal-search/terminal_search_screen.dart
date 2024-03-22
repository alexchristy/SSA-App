import 'package:flutter/material.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:ssa_app/screens/terminal-search/search_metadata.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ssa_app/screens/terminal-search/terminal_search_result.dart';
import 'package:ssa_app/screens/terminal-search/hits_page.dart';
import 'package:ssa_app/models/terminal.dart';
import 'package:ssa_app/utils/terminal_utils.dart';

class TerminalSearchScreen extends StatefulWidget {
  final TerminalService terminalService;

  TerminalSearchScreen({super.key, TerminalService? terminalService})
      : terminalService = terminalService ?? TerminalService();

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

  // Algolia Search instance
  final _terminalSearcher = HitsSearcher(
      applicationID: 'TO5YM9V5TU',
      apiKey: 'be3d7f96977a9780ffc8cf2c0ea9250d',
      indexName: 'Terminals');

  Stream<SearchMetadata> get _searchMetadata =>
      _terminalSearcher.responses.map(SearchMetadata.fromResponse);

  final PagingController<int, TerminalSearchResult> _pagingController =
      PagingController(firstPageKey: 0);

  Stream<HitsPage> get _searchPage =>
      _terminalSearcher.responses.map(HitsPage.fromResponse);

  @override
  void initState() {
    super.initState();

    _searchTextController
        .addListener(() => _terminalSearcher.query(_searchTextController.text));

    _searchTextController.addListener(
      () => _terminalSearcher.applyState(
        (state) => state.copyWith(
          query: _searchTextController.text,
          page: 0,
        ),
      ),
    );
    _searchPage.listen((page) {
      if (page.pageKey == 0) {
        _pagingController.refresh();
      }
      _pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) => _pagingController.error = error);

    _pagingController.addPageRequestListener(
        (pageKey) => _terminalSearcher.applyState((state) => state.copyWith(
              page: pageKey,
            )));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_showCancelButton) {
        _animationController.forward();
        setState(() {
          _showCancelButton = true;
        });
      } else if (!_focusNode.hasFocus && _showCancelButton) {
        _animationController.reverse();
        setState(() {
          _showCancelButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchTextController.dispose();
    _animationController.dispose();
    _pagingController.dispose();
    _terminalSearcher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchBarSection(), // Padding is applied within this method except for the Divider
          StreamBuilder<SearchMetadata>(
            stream: _searchMetadata,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${snapshot.data!.nbHits} hits'),
              );
            },
          ),
          Expanded(
            child: _hits(context),
          )
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
        ));

    return PreferredSize(
        preferredSize: Size.fromHeight(baseAppBarHeight),
        child: AppBar(
          backgroundColor: AppColors.ghostWhite,
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
        ),
        Padding(
            padding: const EdgeInsets.all(4.0),
            child: StreamBuilder<SearchMetadata>(
              stream: _searchMetadata,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Hits: ${snapshot.data!.nbHits}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )),
        Divider(
          color: Colors.grey.shade400,
          thickness: 1,
        ) // Divider expands to the edge
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
              labelText: 'Terminal Search',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(
                    color: AppColors.greenBlue,
                    width: 1.0,
                  )),
              hintText: 'Name, location, or command',
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
                      TextStyle(fontSize: 16, color: AppColors.prussianBlue)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _hits(BuildContext context) =>
      PagedListView<int, TerminalSearchResult>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<TerminalSearchResult>(
              noItemsFoundIndicatorBuilder: (_) => const Center(
                    child: Text('No results found'),
                  ),
              itemBuilder: (_, item, __) => Container(
                    color: Colors.white,
                    height: 80,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [Expanded(child: Text(item.name))],
                    ),
                  )));
}
