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
                    //child: Image.asset(templateImagePath, fit: BoxFit.fitWidth),
                    child: Container(
                      child: Image.asset(widget.templateImagePath,
                          fit: BoxFit.fill),
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  new Positioned(
                      left: 10.0,
                      top: 10.0,
                      child: new Container(
                          /*decoration: new BoxDecoration(color: Colors.red),*/
                          child: new Row(children: <Widget>[
                        new IconButton(
                          icon: _isFavoriteSelected
                              ? Icon(context.platformIcons.favoriteSolid)
                              : Icon(context.platformIcons.favoriteOutline),
                          tooltip: "favorite",
                          onPressed: () {
                            setState(() {
                              _isFavoriteSelected = !_isFavoriteSelected;
                              print(_isFavoriteSelected);
                            });
                          },
                          color: Colors.red,
                        ),
                        new Text(
                          'Tile $index',
                          style: TextStyle(fontFamily: 'Macadamia'),
                        ),
                      ]))),
                ],
              ))),
    );
  }
}
