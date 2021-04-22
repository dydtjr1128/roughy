import 'package:flutter/widgets.dart';

class RoughyGestureTextController {
  late void Function(bool isSelected) setWidgetSelected;
  late void Function(ScaleStartDetails details) onScaleStartHandler;
  late void Function(ScaleUpdateDetails details) onScaleUpdateHandler;
  late void Function(String fontName) setFont;
  late void Function(Color fontColor) setFontColor;
}
