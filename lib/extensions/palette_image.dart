import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

extension PaletteImageListener on Image {
  listen({
    @required Function(Color color) callback,
    Color fallback,
  }) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      image,
      size: Size(width, height),
      region: Offset.zero & Size(width, height),
      targets: [PaletteTarget.lightMuted],
    );
    final color = paletteGenerator?.dominantColor?.color;
    if (color != null) {
      callback?.call(color);
    } else if (fallback != null) {
      callback?.call(fallback);
    }
  }

  listenIf({
    @required bool Function(Image) check,
    @required Function(Color color) callback,
    Color fallback,
  }) {
    if (check(this)) {
      this.listen(
        callback: callback,
        fallback: fallback,
      );
    }
  }
}
