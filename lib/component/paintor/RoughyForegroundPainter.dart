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
  });

  @override
  void paint(Canvas canvas, Size size) async {
    ui.Paint paint = new ui.Paint()..strokeCap = StrokeCap.round;
    int len = points.length;
    for (int i = 0; i < len; i++) {
      if (points[i] is RoughyDrawingPoint && points[i] != null && i + 1 < len) {
        if (points[i + 1] != null && points[i + 1] is RoughyDrawingPoint) {
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
      } else if (points[i] is RoughyTextPoint) {
        /*RoughyTextPoint roughyTextPoint = points[i] as RoughyTextPoint;
        // RoughyTextPoint
        final textStyle = TextStyle(
            color: roughyTextPoint.color,
            fontSize: roughyTextPoint.roughyFont.fontSize,
            fontFamily: roughyTextPoint.roughyFont.fontName);
        final textSpan = TextSpan(
          text: roughyTextPoint.text,
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(
          minWidth: 0,
          maxWidth: size.width,
        );
        textPainter.paint(canvas, roughyTextPoint.offset);*/
      }
    }
  }

  @override
  bool shouldRepaint(covariant RoughyForegroundPainter oldDelegate) {
    return true;
  }
}
