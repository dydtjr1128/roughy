import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OutlineRoundButton extends StatelessWidget {
  const OutlineRoundButton({
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        //width: 100,
        height: 40.0,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          color: foregroundColor,
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
