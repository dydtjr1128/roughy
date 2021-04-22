import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OutlineRoundButton extends StatelessWidget {
  OutlineRoundButton({
    this.onTap,
    this.borderSize: 0.5,
    this.radius: 20.0,
    this.borderColor: Colors.transparent,
    this.foregroundColor: Colors.white,
    this.child,
  });

  final onTap;
  final radius;
  final borderSize;
  final borderColor;
  final foregroundColor;
  final child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: new BorderRadius.circular(radius),
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
              child: child ?? SizedBox(),
              onTap: () async {
                if (onTap != null) {
                  onTap();
                }
              }),
        ),
      ),
    );
  }
}
