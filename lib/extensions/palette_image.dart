import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

extension PaletteImageListener on Image {
  listen({Function(Color color) callback}) async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      image,
      size: Size(width, height),
      region: Offset.zero & Size(width, height),
      maximumColorCount: 5,
    );
    if (paletteGenerator != null && paletteGenerator.colors.isNotEmpty) {
      callback?.call(paletteGenerator.colors.first);
    }
  }
}
