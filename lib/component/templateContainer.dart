import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TemplateContainer extends StatefulWidget {
  final Function onTap;
  final Function onFavoriteTap;
  final int containerIndex;
  final BorderRadius _baseBorderRadius = BorderRadius.circular(8);
  final String templateImagePath;
  final bool isFavorite;

  TemplateContainer(
      {@required this.onTap,
      @required this.containerIndex,
      @required this.templateImagePath,
      @required this.onFavoriteTap,
      @required this.isFavorite});

  @override
  _TemplateContainerState createState() =>
      _TemplateContainerState(this.isFavorite);
}

class _TemplateContainerState extends State<TemplateContainer> {
  bool _isFavoriteSelected;

  _TemplateContainerState(this._isFavoriteSelected);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;
    final index = widget.containerIndex;
    return Card(
      elevation: 0,
      color: Color.fromRGBO(235, 235, 235, 1),
      shape: RoundedRectangleBorder(borderRadius: widget._baseBorderRadius),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                                    widget.onFavoriteTap(widget.containerIndex,
                                        _isFavoriteSelected, context);
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
