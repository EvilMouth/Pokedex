import 'package:Pokedex/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

extension PaletteImageListener on Image {
  listen({@required Function(Color color) callback}) async {
    try {
      PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        image,
        size: Size(width, height),
        region: Offset.zero & Size(width, height),
        maximumColorCount: 1,
        targets: [PaletteTarget.lightMuted],
      );
      Color color = paletteGenerator?.dominantColor?.color;
      if (color != null) {
        callback?.call(color);
      }
    } catch (e, stack) {
      logger.e('palette error', e, stack);
    }
  }

  listenIf(
      {@required bool Function(Image) check,
      @required Function(Color color) callback}) {
    if (check(this)) {
      this.listen(callback: callback);
    }
  }
}
