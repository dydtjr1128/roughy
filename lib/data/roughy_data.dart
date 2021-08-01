import 'dart:ui' as ui;

class RoughyDrawingPoint {
  ui.Offset offset;
  ui.Color? color;
  double? depth;

  RoughyDrawingPoint(
      {required this.offset, required this.color, required this.depth});
}

class RoughyTextPoint {
  ui.Offset offset;
  ui.Color? color;
  RoughyFont? roughyFont;
  String text;

  RoughyTextPoint(
      {required this.offset,
      required this.color,
      required this.roughyFont,
      required this.text});
}

class RoughyFont {
  String fontName;
  double fontSize;

  RoughyFont({required this.fontName, required this.fontSize});
}
