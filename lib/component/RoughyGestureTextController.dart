import 'package:flutter/widgets.dart';

class RoughyGestureTextController {
  void Function(bool isSelected) setWidgetSelected;
  void Function(ScaleStartDetails details) onScaleStartHandler;
  void Function(ScaleUpdateDetails details) onScaleUpdateHandler;
  void Function(String fontName) setFont;
  void Function(Color fontColor) setFontColor;
}
