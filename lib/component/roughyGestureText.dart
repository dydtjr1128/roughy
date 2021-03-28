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
  double _scale = 1.0;
  double _previousScale = 1;
  Offset _previousOffset = Offset.zero;
  Offset localOffset = Offset.zero;

  void onScaleStartHandler(ScaleStartDetails details) {
    _previousScale = _scale;
    _previousOffset = details.focalPoint;
    print("prev : " + details.focalPoint.toString() + details.localFocalPoint.toString());
  }

  void onScaleEndHandler(ScaleEndDetails details) {}

  void onScaleUpdateHandler(ScaleUpdateDetails details) {
    if (details.scale == 1) {
      Offset delta = details.focalPoint - _previousOffset;
      _previousOffset = details.focalPoint;
      //print("@@ delta : " + delta.dx.toString() + " " + delta.dy.toString());
      setState(() {
        localOffset = Offset(localOffset.dx + delta.dx, localOffset.dy + delta.dy);
      });
    } else {
      print("@@ scale : " + details.scale.toString() + " " + _previousScale.toString());
      setState(() {
        _scale = _previousScale * details.scale;
      });
    }

    double scaleValue = details.scale;
    double deg = details.rotation.abs() * (180 / math.pi);
  }

  void onTapHandler() {
    //widget.onTap();
    print("@@@@");
    setState(() {
      isBorderExist = !isBorderExist;
    });
  }

  void onPanUpdateHandler(DragUpdateDetails details) {
    setState(() {
      //localOffset = Offset(details.focalPoint.dx - width / 2, details.focalPoint.dy - 70 - height/2);
      localOffset = Offset(localOffset.dx + details.delta.dx, localOffset.dy + details.delta.dy);
    });
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
      color: Colors.blueAccent,
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
        child: GestureDetector(
//                  onPanUpdate: onPanUpdateHandler,
          onScaleStart: onScaleStartHandler,
          onScaleUpdate: onScaleUpdateHandler,
          //onScaleEnd: onScaleEndHandler,
          onTap: onTapHandler,
          child: ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 100,
                minWidth: 150,
                maxHeight: itemHeight,
                maxWidth: itemWidth,
              ),
              child: Container(
                decoration: isBorderExist
                    ? myBoxDecoration(Colors.black)
                    : myBoxDecoration(Colors.transparent),
                child: Text(widget.roughyTextPoint.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: widget.roughyTextPoint.roughyFont.fontName,
                        fontSize: 30 * _scale)),
              )),
        ));
  }
}
