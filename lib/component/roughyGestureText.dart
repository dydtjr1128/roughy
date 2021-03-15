import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class roughyGestureText extends StatefulWidget {
  final String text;
  final String fontFamily;
  final Function onTap;

  roughyGestureText({@required this.text, this.fontFamily, this.onTap});

  @override
  _roughyGestureTextState createState() => _roughyGestureTextState();
}

class _roughyGestureTextState extends State<roughyGestureText> {
  final double scaleRatio = 2;
  final double defaultMinSize = 20;
  final GlobalKey _key = GlobalKey();
  double rotationDegree = 0;
  double fontSize = 18;
  double width;
  double height;

  void onScaleStartHandler(ScaleStartDetails details) {}

  void onScaleEndHandler(ScaleEndDetails details) {}

  void onScaleUpdateHandler(ScaleUpdateDetails details) {
    double scaleValue = details.scale;
    double deg = details.rotation.abs() * (180 / math.pi);

    setState(() {
      width = defaultMinSize + defaultMinSize * scaleValue;
      rotationDegree = deg;
    });
  }

  void onTapHandler() {
    widget.onTap();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Size _size = _key.currentContext.size;
    width = _size.width+5;
    height = _size.height+5;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    bool isBorderExist = false;

    return ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: defaultMinSize,
          minWidth: defaultMinSize,
          maxHeight: itemHeight,
          maxWidth: itemWidth,
        ),
        child: RotationTransition(
          turns: new AlwaysStoppedAnimation(rotationDegree),
          child: Container(
              width: width,
              height: height,
              decoration:
              isBorderExist ? BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)) : null,
              child: GestureDetector(
                  onScaleStart: onScaleStartHandler,
                  onScaleUpdate: onScaleUpdateHandler,
                  onScaleEnd: onScaleEndHandler,
                  onTap: onTapHandler,
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                          widget.text,
                          key: _key,
                          style: TextStyle(fontFamily: widget.fontFamily, /*fontSize: fontSize*/)
                      )
                  )
              )
          ),
        )
    );
  }
}
