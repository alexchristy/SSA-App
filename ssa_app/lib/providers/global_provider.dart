import 'package:ssa_app/models/terminal.dart';

class GlobalProvider {
  bool downloadedTerminals = false;
  Map<String, Terminal> terminals = {};

  // Dynamic sizing variables
  double screenWidth = 0;
  double shortestSide = 0;
  double cardWidth = 0;
  double cardHeight = 0;
  double cardPadding = 0;
  double halfCardPadding = 0;

  // Authentication variables
  bool isSignedIn = false;

  void setSignedIn(bool value) {
    isSignedIn = value;
  }

  bool getSignedIn() {
    return isSignedIn;
  }

  void setDownloadedTerminals(bool value) {
    downloadedTerminals = value;
  }

  void setTerminals(Map<String, Terminal> value) {
    terminals = value;
  }

  void _setCardWidth(double value) {
    cardWidth = value;
  }

  void _setCardHeight(double value) {
    cardHeight = value;
  }

  void _setCardPadding(double value) {
    cardPadding = value;
  }

  void _setScreenWidth(double value) {
    screenWidth = value;
  }

  void _setShortestSide(double value) {
    shortestSide = value;
  }

  void _setHalfCardPadding(double value) {
    halfCardPadding = value;
  }

  void setDynamicSizes(double screenWidth, double shortestSide) {
    _setScreenWidth(screenWidth);
    _setShortestSide(shortestSide);

    _setCardWidth(_calcTileWidth(screenWidth));
    _setCardHeight(_calcTileHeight(shortestSide));
    _setCardPadding(_calcPadding());
    _setHalfCardPadding(_calcHalfPadding());
  }

  double _calcPadding() {
    return ((screenWidth - cardWidth) / 2).floorToDouble();
  }

  double _calcHalfPadding() {
    return (cardPadding / 2).floorToDouble();
  }

  double _calcTileWidth(double screenWidth) {
    return ((screenWidth * 0.9) / 2).ceil() * 2; // Ensure it's an even number
  }

  double _calcTileHeight(double shortestSide) {
    double portraitTileWidth = _calcTileWidth(shortestSide);
    return (portraitTileWidth * 0.36).ceilToDouble();
  }
}
