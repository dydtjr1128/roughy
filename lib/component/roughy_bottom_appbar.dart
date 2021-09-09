import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoughyBottomAppbar extends StatelessWidget {
  const RoughyBottomAppbar({
    this.onTap,
    this.height = 50.0,
    this.foregroundColor = Colors.white,
    this.child,
  });

  final Function? onTap;
  final double height;
  final Color foregroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
        height: height + additionalBottomPadding,
        decoration: BoxDecoration(
            color: foregroundColor,
            border: const Border(
              top: BorderSide(
                color: Color.fromRGBO(112, 112, 112, 1),
                width: 0.1,
              ),
            )),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15), child: child ?? const SizedBox()));
  }
}
