import 'dart:math' as math;

import 'package:Roughy/component/RoughyGestureTextController.dart';
import 'package:Roughy/component/RoundShadowButton.dart';
import 'package:Roughy/data/RoughyData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoughyGestureText extends StatefulWidget {
  final String text;
  final String fontFamily;
  final Function onWidgetSelected;
  final Function onWidgetReleased;
  final Function onTapRoughyGestureTextRemove;
  final RoughyTextPoint roughyTextPoint;
  final RoughyGestureTextController roughyGestureTextController;

  RoughyGestureText(
      {this.text,
      this.fontFamily,
      this.onWidgetSelected,
      this.onWidgetReleased,
      this.onTapRoughyGestureTextRemove,
      this.roughyTextPoint,
      this.roughyGestureTextController,
      Key key})
      : super(key: key);

  @override
  _RoughyGestureTextState createState() => _RoughyGestureTextState(roughyGestureTextController);
}

class _RoughyGestureTextState extends State<RoughyGestureText> {
  final double scaleRatio = 2;
  final double defaultMinSize = 20;
  double rotationDegree = 0;
  bool isWidgetSelected = false;
  double _scale = 1.0;
  double _previousScale = 1;
  Offset _previousOffset = Offset.zero;
  Offset localOffset = Offset.zero;
  String fontName;
  Color fontColor;

  _RoughyGestureTextState(RoughyGestureTextController _controller) {
    _controller.setWidgetSelected = setWidgetSelected;
    _controller.setFont = setFont;
    _controller.setFontColor = setFontColor;
  }

  @override
  void initState() {
    super.initState();
    print("@@@@~~~" + widget.toString());
    this.fontName = widget.roughyTextPoint.roughyFont.fontName;
    this.fontColor = widget.roughyTextPoint.color;
  }

  void setFont(String fontName) {
    setState(() {
      this.fontName = fontName;
    });
  }

  void setFontColor(Color fontColor) {
    setState(() {
      this.fontColor = fontColor;
    });
  }

  void setWidgetSelected(bool selected) {
    print(localOffset.toString());
    setState(() {
      isWidgetSelected = selected;
    });
  }

  void onTapRoughyGestureTextRemoveCallback() {
    if (!isWidgetSelected) return;
    print("지우기!");
    widget.onTapRoughyGestureTextRemove(widget);
  }

  void onScaleGlobalStartHandler(ScaleStartDetails details) {
    if (!isWidgetSelected) return;
    _previousScale = _scale;
    _previousOffset = details.focalPoint;
    print("prev : " + details.focalPoint.toString() + details.localFocalPoint.toString());
  }

  void onScaleGlobalUpdateHandler(ScaleUpdateDetails details) {
    if (!isWidgetSelected) return;
    if (details.scale != 1) {
      setState(() {
        _scale = _previousScale * details.scale;
      });
    }

    double scaleValue = details.scale;
    double deg = details.rotation.abs() * (180 / math.pi);
  }

  void onScaleStartHandler(ScaleStartDetails details) {
    print("~~~~");
    if (!isWidgetSelected) return;
    _previousScale = _scale;
    _previousOffset = details.focalPoint;
    print("prev : " + details.focalPoint.toString() + details.localFocalPoint.toString());
  }

  void onScaleUpdateHandler(ScaleUpdateDetails details) {
    if (!isWidgetSelected) return;
    if (details.scale == 1) {
      Offset delta = details.focalPoint - _previousOffset;
      _previousOffset = details.focalPoint;
      setState(() {
        localOffset = Offset(localOffset.dx + delta.dx, localOffset.dy + delta.dy);
      });
    } else {
      setState(() {
        _scale = _previousScale * details.scale;
      });
    }

    double scaleValue = details.scale;
    double deg = details.rotation.abs() * (180 / math.pi);
  }

  void onTapHandler() {
    setState(() {
      isWidgetSelected = !isWidgetSelected;
    });
    if (isWidgetSelected) {
      widget.onWidgetSelected(widget);
    } else {
      widget.onWidgetReleased(widget);
    }
  }

  BoxDecoration myBoxDecoration(Color selectedColor) {
    return BoxDecoration(
      border: Border.all(
        width: 2.0,
        color: selectedColor,
      ),
      borderRadius: BorderRadius.all(Radius.circular(2.0) //                 <--- border radius here
          ),
    );
  }

  ButtonStyle myButtonDecoration(Color shadowColor, Color borderColor) {
    return ElevatedButton.styleFrom(
        primary: Colors.transparent, // background
        onPrimary: Colors.transparent,
        shadowColor: shadowColor,
        side: BorderSide(
          width: 2.0,
          color: borderColor,
        ));
  }

  /*@override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;

    return InteractiveViewer(
        panEnabled: true,
        // Set it to false to prevent panning.
        boundaryMargin: EdgeInsets.all(180),
        minScale: 0.5,
        maxScale: 10,
        child: Text(widget.roughyTextPoint.text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: widget.roughyTextPoint.roughyFont.fontName,
                fontSize: 30 * _scale)));
  }*/

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: localOffset.dx,
        top: localOffset.dy,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onScaleStart: onScaleStartHandler,
          onScaleUpdate: onScaleUpdateHandler,
          child: buildTextContainer(),
        ));
  }

  List<Positioned> buildBorders() {
    double top = 0;
    double left = 0;
  }

  Stack buildTextContainer() {
    return Stack(children: [
      RoundShadowButton(
          isSelect: isWidgetSelected,
          onRemove: onTapRoughyGestureTextRemoveCallback,
          onTap: onTapHandler,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.roughyTextPoint.text,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontFamily: fontName, color: fontColor, fontSize: 30 * _scale)),
              ]),
        ),
    ]);
  }
/*Stack buildTextContainer(double itemHeight, double itemWidth) {
    return Stack(children: [
      if (isWidgetSelected)
        Positioned(
          left: 0,
          bottom: 0,
          top: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
          ),
        ),
      ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 150,
          minWidth: 200,
          maxHeight: itemHeight,
          maxWidth: itemWidth,
        ),
        child: Container(
            margin: EdgeInsets.all(50),
            padding: EdgeInsets.all(15),
            decoration: isWidgetSelected
                ? myBoxDecoration(Colors.black54)
                : myBoxDecoration(Colors.transparent),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onTapHandler,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.roughyTextPoint.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: fontName, color: fontColor, fontSize: 30 * _scale)),
                  ]),
            )),
      ),
      if (isWidgetSelected)
        Positioned(
          top: 40,
          right: 40,
          child: ClipOval(
            child: Material(
              color: Colors.black,
              child: InkWell(
                splashColor: Colors.red, // inkwell color
                child: Icon(
                  Icons.horizontal_rule,
                  color: Colors.white,
                  size: 28,
                ),
                onTap: onTapRoughyGestureTextRemoveCallback,
              ),
            ),
          ),
        )
    ]);
  }*/
}
