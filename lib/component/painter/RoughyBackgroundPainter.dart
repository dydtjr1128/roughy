import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

import 'package:Roughy/data/RoughyData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoughyBackgroundPainter extends CustomPainter {
  final ui.Image templateImage;

  Color? drawingColor;
  double? drawingDepth;

  List<dynamic> points = [RoughyDrawingPoint, RoughyTextPoint];

  RoughyBackgroundPainter({
    required this.templateImage,
    /*required this.croppedImage,*/
    required this.points,
    required this.drawingColor,
    required this.drawingDepth,
  });

  @override
  void paint(Canvas canvas, Size size) async {
    //print("사이즈는요~ " + size.width.toString() + " " + size.height.toString());
    final double width = size.width.toDouble();
    final double height = size.height.toDouble();
/*    if (croppedImage != null) {
      canvas.drawImageRect(
          croppedImage,
          Rect.fromLTRB(0, 0, croppedImage.width.toDouble(), croppedImage.height.toDouble()),
          Rect.fromLTRB(0, 0, width, height),
          Paint());
    }*/
    if (templateImage != null) {
      canvas.drawImageRect(
          templateImage,
          Rect.fromLTRB(0, 0, templateImage.width.toDouble(), templateImage.height.toDouble()),
          Rect.fromLTRB(0, 0, width, height),
          Paint());
    }

    ui.Paint paint = new ui.Paint()..strokeCap = StrokeCap.round;
    int len = points.length;
    for (int i = 0; i < len && i + 1 < len; i++) {
      if (points[i] == null) {
        continue;
      } else if (points[i + 1] != null) {
        paint
          ..color = points[i].color
          ..strokeWidth = points[i].depth;
        canvas.drawLine(points[i].offset, points[i + 1].offset, paint);
      } else if (points[i + 1] == null) {
        paint
          ..color = points[i].color
          ..strokeWidth = points[i].depth;
        canvas.drawPoints(ui.PointMode.points, [points[i].offset], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
