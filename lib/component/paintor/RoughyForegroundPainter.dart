import 'dart:ui' as ui;

import 'package:Roughy/data/RoughyData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoughyForegroundPainter extends CustomPainter {
  Color drawingColor;
  double drawingDepth;

  List<dynamic> points = [RoughyDrawingPoint, RoughyTextPoint];

  RoughyForegroundPainter({
    @required this.points,
    @required this.drawingColor,
    @required this.drawingDepth,
  }) {
    print("@@생성자");
  }

  @override
  void paint(Canvas canvas, Size size) async {
    ui.Paint paint = new ui.Paint()..strokeCap = StrokeCap.round;
    int len = points.length;
    for (int i = 0; i < len - 1; i++) {
      if (points[i] is RoughyDrawingPoint) {
        if (points[i] != null && points[i + 1] != null && points[i+1] is RoughyDrawingPoint) {
          paint
            ..color = points[i].color
            ..strokeWidth = points[i].depth;
          canvas.drawLine(points[i].offset, points[i + 1].offset, paint);
        } else if (points[i] != null && points[i + 1] == null) {
          paint
            ..color = points[i].color
            ..strokeWidth = points[i].depth;
          canvas.drawPoints(ui.PointMode.points, [points[i].offset], paint);
        }
      } else {
        // RoughyTextPoint

      }
    }
  }

  @override
  bool shouldRepaint(covariant RoughyForegroundPainter oldDelegate) {
    return true;
  }
}
