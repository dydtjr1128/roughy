import 'dart:math' as math;

import 'package:Roughy/data/RoughyData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoughyGestureText extends StatefulWidget {
  final String text;
  final String fontFamily;
  final Function onTap;
  final RoughyTextPoint roughyTextPoint;

  RoughyGestureText({this.text, this.fontFamily, this.onTap, this.roughyTextPoint});

  @override
  _RoughyGestureTextState createState() => _RoughyGestureTextState();
}

class _RoughyGestureTextState extends State<RoughyGestureText> {
  final double scaleRatio = 2;
  final double defaultMinSize = 20;
  final GlobalKey _key = GlobalKey();
  double rotationDegree = 0;
  double width;
  double height;
  bool isBorderExist = false;
  Offset localOffset = Offset(0, 0);

  void onScaleStartHandler(ScaleStartDetails details) {

  }

  void onScaleEndHandler(ScaleEndDetails details) {}

  void onScaleUpdateHandler(ScaleUpdateDetails details) {
    print("@@" + details.focalPoint.toString() + details.localFocalPoint.toString());
    setState(() {
      localOffset = details.localFocalPoint;
    });
    /*double scaleValue = details.scale;
    double deg = details.rotation.abs() * (180 / math.pi);
    print("scaleValue : " +
        scaleValue.toString() +
        " deg : " +
        deg.toString() +
        " width : " +
        (defaultMinSize + defaultMinSize * scaleValue).toString());
    setState(() {
      width = width + defaultMinSize * scaleValue;
      rotationDegree = deg;
    });*/
  }

  void onTapHandler() {
    //widget.onTap();
    setState(() {
      isBorderExist = !isBorderExist;
    });
  }
  void onPanUpdateHandler(DragUpdateDetails details) {
    print("pan update : " + details.globalPosition.dx.toString() + " " + details.globalPosition.dy.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    width = 100;
    height = 50;
  }

  BoxDecoration myBoxDecoration(Color selectedColor) {
    return BoxDecoration(
      border: Border.all(
        width: 1.0,
        color: selectedColor,
      ),
      borderRadius: BorderRadius.all(Radius.circular(2.0) //                 <--- border radius here
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;

    return Positioned(
      left: localOffset.dx,
      top: localOffset.dy,
      child: ConstrainedBox(
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
                  isBorderExist ? myBoxDecoration(Colors.black) : myBoxDecoration(Colors.transparent),
              child: GestureDetector(
                  //onPanUpdate: onPanUpdateHandler,
                  onScaleStart: onScaleStartHandler,
                  onScaleUpdate: onScaleUpdateHandler,
                  onScaleEnd: onScaleEndHandler,
                  onTap: onTapHandler,
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(widget.roughyTextPoint.text,
                          style: TextStyle(
                            fontFamily:
                                widget.roughyTextPoint.roughyFont.fontName, /*fontSize: fontSize*/
                          )))),
            )),
      ),
    );
  }
}
