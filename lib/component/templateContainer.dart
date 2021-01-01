import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TemplateContainer extends StatefulWidget {
  final Function onTap;
  final int containerIndex;
  final BorderRadius _baseBorderRadius = BorderRadius.circular(8);
  final String templateImagePath;

  TemplateContainer(
      {@required this.onTap,
      @required this.containerIndex,
      @required this.templateImagePath});

  @override
  _TemplateContainerState createState() => _TemplateContainerState();
}

class _TemplateContainerState extends State<TemplateContainer> {
  bool _isFavoriteSelected = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;
    final index = widget.containerIndex;
    return Card(
      elevation: 2,
      color: Colors.teal.shade200,
      shape: RoundedRectangleBorder(borderRadius: widget._baseBorderRadius),
      margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
      child: InkWell(
          borderRadius: widget._baseBorderRadius,
          onTap: () => widget.onTap(widget.containerIndex, context),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: widget._baseBorderRadius,
                color: Colors.transparent,
              ),
              child: new Stack(
                children: <Widget>[
                  ClipRRect(
                      child: Center(
                    child: Container(
                      child: Image.asset(widget.templateImagePath,
                          fit: BoxFit.fill),
                      height: MediaQuery.of(context).size.height,
                      margin:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                    ),
                  )),
                  new Positioned(
                      left: 5.0,
                      top: 5.0,
                      child: new Container(
                          //decoration: new BoxDecoration(color: Colors.red),
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isFavoriteSelected = !_isFavoriteSelected;
                                    print(_isFavoriteSelected);
                                  });
                                },
                                child: _isFavoriteSelected
                                    ? Icon(context.platformIcons.favoriteSolid,
                                        color: Colors.red)
                                    : Icon(
                                        context.platformIcons.favoriteOutline,
                                        color: Colors.red)),
                          ]))),
                ],
              ))),
    );
  }
}
