import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundShadowButton extends StatelessWidget {
  bool isSelect;
  final onRemove;
  final Widget? child;
  final Function onTap;

  RoundShadowButton({
    this.onRemove,
    this.child,
    required this.isSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(color: Colors.yellow),
        padding: isSelect ? const EdgeInsets.all(50) : EdgeInsets.zero,
        margin: isSelect ? EdgeInsets.zero : const EdgeInsets.all(50),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 80,
            minWidth: 80,
            maxHeight: itemHeight,
            maxWidth: itemWidth
          ),
          child: GestureDetector(
            onTap: () {
              onTap();
            },
            child: DottedBorder(
                color: isSelect ? Colors.black : Colors.transparent,
                dashPattern: [8, 4],
                strokeWidth: 2,
                child: Container(child: child)
            ),
          ),
        ),
      ),
      if (isSelect)
        Positioned(
          top: 40,
          right: 40,
          child: ClipOval(
            child: Material(
              color: Colors.black,
              child: InkWell(
                splashColor: Colors.red,
                onTap: () {
                  onRemove();
                }, // inkwell color
                child: const Icon(
                  Icons.close_rounded,
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
      final rrectBorder = RRect.fromRectAndRadius(
          Offset.zero & size, const Radius.circular(_kRadius));
      final rrectShadow = RRect.fromRectAndRadius(
          const Offset(0, 3) & size, const Radius.circular(_kRadius));

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
