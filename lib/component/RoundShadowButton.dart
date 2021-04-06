import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundShadowButton extends StatelessWidget {
  RoundShadowButton({
    Key key,
    this.onTap,
    this.onRemove,
    this.child,
    this.isSelect,
  }) : super(key: key);

  bool isSelect;
  final onTap;
  final onRemove;
  final child;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    return Stack(children: [
      Container(
        padding: EdgeInsets.all(30),
        child: ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: 100,
            minWidth: 150,
            maxHeight: itemHeight,
            maxWidth: itemWidth,
          ),
          child: GestureDetector(
              child: Container(
                  child: CustomPaint(
                      painter: MyPainter(isSelect),
                      child: Container(padding: EdgeInsets.all(10), child: child))),
              onTap: () async {
                if (onTap != null) {
                  onTap();
                }
              }),
        ),
      ),
      Positioned(
        top: 15,
        right: 15,
        child: ClipOval(
          child: Material(
            color: Colors.black,
            child: InkWell(
              splashColor: Colors.red, // inkwell color
              child: Icon(
                Icons.horizontal_rule,
                color: Colors.white,
                size: 28,
              ),
              onTap: () {
                onRemove();
              },
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

  MyPainter(bool isSelect) {
    this.isSelect = isSelect;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (isSelect) {
      final rrectBorder = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(_kRadius));
      final rrectShadow = RRect.fromRectAndRadius(Offset(0, 3) & size, Radius.circular(_kRadius));

      final shadowPaint = Paint()
        ..strokeWidth = 1
        ..color = Colors.grey
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
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
