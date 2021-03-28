import 'dart:math' as math;

import 'package:Roughy/component/RoughyGestureTextController.dart';
import 'package:Roughy/data/RoughyData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoughyGestureText extends StatefulWidget {
  final String text;
  final String fontFamily;
  final Function onTap;
  final RoughyTextPoint roughyTextPoint;
  final RoughyGestureTextController roughyGestureTextController;

  RoughyGestureText(
      {this.text,
      this.fontFamily,
      this.onTap,
      this.roughyTextPoint,
      this.roughyGestureTextController});

  @override
  _RoughyGestureTextState createState() => _RoughyGestureTextState(roughyGestureTextController);
}

class _RoughyGestureTextState extends State<RoughyGestureText> {
  final double scaleRatio = 2;
  final double defaultMinSize = 20;
  double rotationDegree = 0;
  double width;
  double height;
  bool isWidgetSelected = false;
  double _scale = 1.0;
  double _previousScale = 1;
  Offset _previousOffset = Offset.zero;
  Offset localOffset = Offset.zero;

  _RoughyGestureTextState(RoughyGestureTextController _controller) {
    _controller.setWidgetSelected = setWidgetSelected;
    print("연결!");
  }

  void setWidgetSelected(bool selected) {
    print("call@@@@ " + isWidgetSelected.toString() + "@@" + selected.toString());
    setState(() {
      isWidgetSelected = selected;
    });
  }

  void onScaleStartHandler(ScaleStartDetails details) {
    if (!isWidgetSelected) return;
    _previousScale = _scale;
    _previousOffset = details.focalPoint;
    print("prev : " + details.focalPoint.toString() + details.localFocalPoint.toString());
  }

  void onScaleEndHandler(ScaleEndDetails details) {}

  void onScaleUpdateHandler(ScaleUpdateDetails details) {
    if (!isWidgetSelected) return;
    if (details.scale == 1) {
      Offset delta = details.focalPoint - _previousOffset;
      _previousOffset = details.focalPoint;
      //print("@@ delta : " + delta.dx.toString() + " " + delta.dy.toString());
      setState(() {
        localOffset = Offset(localOffset.dx + delta.dx, localOffset.dy + delta.dy);
      });
    } else {
      setState(() {
        _scale = _previousScale * details.scale;
      });
      print("@@ scale : " +
          _scale.toString() +
          " " +
          _previousScale.toString() +
          " " +
          details.scale.toString());
    }

    double scaleValue = details.scale;
    double deg = details.rotation.abs() * (180 / math.pi);
  }

  void onTapHandler() {
    print("@@@@");
    setState(() {
      isWidgetSelected = !isWidgetSelected;
    });
    if (isWidgetSelected) {
      widget.onTap(widget);
    }
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
        child: GestureDetector(
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
                decoration: isWidgetSelected
                    ? myBoxDecoration(Colors.black)
                    : myBoxDecoration(Colors.transparent),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.roughyTextPoint.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: widget.roughyTextPoint.roughyFont.fontName,
                            fontSize: 30 * _scale)),
                  ],
                ),
              )),
        ));
  }
}
