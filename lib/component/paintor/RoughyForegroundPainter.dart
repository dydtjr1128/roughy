import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class RoughyForegroundPainter extends CustomPainter {
  final ui.Image templateImage, croppedImage;

  RoughyForegroundPainter({
    @required this.templateImage,
    @required this.croppedImage,
  });

  @override
  void paint(Canvas canvas, Size size) async {
    // TODO: implement paint
    print("사이즈는요~ " + size.width.toString() + " " + size.height.toString());
    final double width = size.width.toDouble();
    final double height = size.height.toDouble();
    canvas.drawLine(Offset(0,height/2), Offset(1000,1000), Paint());
    if (croppedImage != null) {
      canvas.drawImageRect(
          croppedImage,
          Rect.fromLTRB(0, 0, croppedImage.width.toDouble(),
              croppedImage.height.toDouble()),
          Rect.fromLTRB(0, 0, width, height),
          Paint());
    }
    if (templateImage != null) {
      canvas.drawImageRect(
          templateImage,
          Rect.fromLTRB(0, 0, templateImage.width.toDouble(),
              templateImage.height.toDouble()),
          Rect.fromLTRB(0, 0, width, height),
          Paint());
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
