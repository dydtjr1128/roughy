import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TemplateContainer extends StatelessWidget {
  final Function onTap;
  final int containerIndex;
  final BorderRadius _baseBorderRadius = BorderRadius.circular(8);
  final String templateImagePath;

  TemplateContainer(
      {@required this.onTap,
      @required this.containerIndex,
      @required this.templateImagePath});

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
            child: Column(children: [
              new Text(
                'Tile $containerIndex',
                style: TextStyle(fontFamily: 'Macadamia'),
              ),
              ClipRRect(
                child: Image.asset(templateImagePath, fit: BoxFit.cover),
              )
            ])),
      ),
    );
  }
}
