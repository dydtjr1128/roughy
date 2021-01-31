import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoughyForegroundPainter extends CustomPainter {
  Color drawingColor;
  double drawingDepth;

  List<ui.Offset> points;

  RoughyForegroundPainter({
    @required this.points,
    @required this.drawingColor,
    @required this.drawingDepth,
  });

  @override
  void paint(Canvas canvas, Size size) async {
    ui.Paint paint = new ui.Paint()
      ..color = drawingColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = drawingDepth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(ui.PointMode.points, [points[i]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RoughyForegroundPainter oldDelegate) {
    return true;
  }
}
