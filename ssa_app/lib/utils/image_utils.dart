// image_util.dart
import 'package:flutter/material.dart';

class ImageUtil {
  static String getTerminalImageVariant(String baseUrl, double requiredWidth,
      double requiredHeight, BuildContext context) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final adjustedWidth = requiredWidth * pixelRatio;
    final adjustedHeight = requiredHeight * pixelRatio;
    const variants = [150, 200, 250, 300, 350, 400, 450, 500, 600, 700, 750];
    int requiredSize = adjustedWidth >= adjustedHeight
        ? adjustedWidth.ceil()
        : adjustedHeight.ceil();

    for (final variant in variants) {
      if (requiredSize <= variant) {
        return "${baseUrl}terminal$variant";
      }
    }
    return "${baseUrl}terminal750"; // Default variant
  }
}
