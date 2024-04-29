// image_util.dart
import 'package:flutter/material.dart';

class ImageUtil {
  static String getTerminalImageVariant(String? baseUrl, double requiredWidth,
      double requiredHeight, BuildContext context) {
    if (baseUrl == null || baseUrl.isEmpty) {
      return "";
    }

    if (requiredWidth <= 0 || requiredHeight <= 0) {
      throw ArgumentError('requiredWidth and requiredHeight must be positive');
    }

    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final adjustedWidth = requiredWidth * pixelRatio;
    final adjustedHeight = requiredHeight * pixelRatio;
    const variants = [
      150,
      200,
      250,
      300,
      350,
      400,
      450,
      500,
      600,
      700,
      750,
      900,
      1000,
      1100,
      1250,
      1500,
      1750,
      2000
    ];

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
