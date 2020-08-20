import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

extension PaletteImageListener on Image {
  listen({@required Function(Color color) callback}) async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      image,
      // size: Size(width, height),
      // region: Offset.zero & Size(width, height),
      maximumColorCount: 1,
    );
    if (paletteGenerator != null && paletteGenerator.colors.isNotEmpty) {
      callback?.call(paletteGenerator.colors.first);
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
