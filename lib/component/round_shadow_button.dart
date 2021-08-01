import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundShadowButton extends StatelessWidget {
  bool isSelect;
  final onRemove;
  final Widget? child;

  RoundShadowButton({
    this.onRemove,
    this.child,
    required this.isSelect,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    return Stack(children: [
      Container(
        padding: const EdgeInsets.all(30),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 80,
            minWidth: 120,
            maxHeight: itemHeight,
            maxWidth: itemWidth,
          ),
          child: Container(
              child: CustomPaint(
                  painter: MyPainter(isSelect),
                  child: Container(padding: const EdgeInsets.all(10), child: child))),
        ),
      ),
      if (isSelect)
        Positioned(
          top: 15,
          right: 15,
          child: ClipOval(
            child: Material(
              color: Colors.black,
              child: InkWell(
                splashColor: Colors.red,
                onTap: () {
                  onRemove();
                }, // inkwell color
                child: const Icon(
                  Icons.horizontal_rule,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        )
    ]);
  }
}

const double _kRadius = 1;
const double _kBorderWidth = 2;

class MyPainter extends CustomPainter {
  bool isSelect;

  MyPainter(this.isSelect);

  @override
  void paint(Canvas canvas, Size size) {
    if (isSelect) {
      final rrectBorder = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(_kRadius));
      final rrectShadow = RRect.fromRectAndRadius(const Offset(0, 3) & size, const Radius.circular(_kRadius));

      final shadowPaint = Paint()
        ..strokeWidth = 1
        ..color = Colors.grey
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      final borderPaint = Paint()
        ..strokeWidth = _kBorderWidth
        ..color = Colors.white
        ..style = PaintingStyle.stroke;

      canvas.drawRRect(rrectShadow, shadowPaint);
      canvas.drawRRect(rrectBorder, borderPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
