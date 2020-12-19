import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TemplateContainer extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final int containerIndex;
  final BorderRadius _baseBorderRadius = BorderRadius.circular(8);

  var templateImage;

  TemplateContainer(
      {@required this.onTap,
      @required this.child,
      @required this.containerIndex/*,
      @required this.templateImage*/});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.teal.shade200,
      shape: RoundedRectangleBorder(borderRadius: _baseBorderRadius),
      margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
      child: InkWell(
        borderRadius: _baseBorderRadius,
        onTap: () => onTap(containerIndex, context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: _baseBorderRadius,
            color: Colors.transparent,
          ),
          child: child,
        ),
      ),
    );
  }
}
