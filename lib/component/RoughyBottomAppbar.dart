import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoughyBottomAppbar extends StatelessWidget {
  RoughyBottomAppbar({
    this.onTap,
    this.height: 50.0,
    this.foregroundColor: Colors.white,
    this.child,
  });

  final Function? onTap;
  final double height;
  final Color foregroundColor;
  final child;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        decoration: new BoxDecoration(
            color: foregroundColor,
            border: new Border(
              top: BorderSide(
                color: Color.fromRGBO(112, 112, 112, 1),
                width: 0.1,
              ),
            )),
        child: child ?? SizedBox());
  }
}
