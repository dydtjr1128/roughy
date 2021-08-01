import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OutlineCircleButton extends StatelessWidget {
  const OutlineCircleButton({
    this.onTap,
    this.borderSize = 0.5,
    this.radius = 20.0,
    this.borderColor = Colors.transparent,
    this.foregroundColor = Colors.white,
    this.child,
  });

  final Function? onTap;
  final double radius;
  final double borderSize;
  final Color borderColor;
  final Color foregroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderSize),
          color: foregroundColor,
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: () async {
                if (onTap != null) {
                  onTap!();
                }
              },
              child: child ?? const SizedBox()),
        ),
      ),
    );
  }
}
