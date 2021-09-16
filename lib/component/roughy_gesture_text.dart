import 'dart:math' as math;

import 'package:Roughy/component/roughy_gesture_text_controller.dart';
import 'package:Roughy/component/round_shadow_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoughyGestureText extends StatefulWidget {
  final String text;
  final String fontName;
  final Color fontColor;
  final Function onWidgetSelected;
  final Function onWidgetReleased;
  final Function onTapRoughyGestureTextRemove;
  final RoughyGestureTextController roughyGestureTextController;
  final bool isWidgetSelected;

  RoughyGestureText(
      {required this.text,
      required this.fontName,
      required this.fontColor,
      required this.onWidgetSelected,
      required this.onWidgetReleased,
      required this.onTapRoughyGestureTextRemove,
      required this.roughyGestureTextController,
      required this.isWidgetSelected,
      required Key key})
      : super(key: key);

  @override
  _RoughyGestureTextState createState() => _RoughyGestureTextState(
      fontColor: fontColor,
      fontName: fontName,
      text: text,
      controller: roughyGestureTextController,
      isWidgetSelected: isWidgetSelected);
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
  double _rotation = 0.0;
  double _previousRotation = 0.0;
  String text;
  String fontName;
  Color fontColor;

  _RoughyGestureTextState(
      {required RoughyGestureTextController controller,
      required this.text,
      required this.fontName,
      required this.fontColor,
      required this.isWidgetSelected}) {
    controller.setWidgetSelected = setWidgetSelected;
    controller.setFont = setFont;
    controller.setFontColor = setFontColor;
  }

  @override
  void initState() {
    super.initState();
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
    print("@@@@setWidgetSelected : $selected");
    setState(() {
      isWidgetSelected = selected;
    });
  }

  void onTapRoughyGestureTextRemoveCallback() {
    if (!isWidgetSelected) return;
    print("onTapRoughyGestureTextRemoveCallback!");
    widget.onTapRoughyGestureTextRemove(widget);
  }

  void onScaleStartHandler(ScaleStartDetails details) {
    print("onScaleStartHandler");
    if (!isWidgetSelected) return;
    _previousScale = _scale;
    _previousOffset = details.focalPoint;
    _previousRotation = 0;
  }

  void onScaleUpdateHandler(ScaleUpdateDetails details) {
    if (!isWidgetSelected) return;
    if (details.scale == 1) {
      Offset delta = details.focalPoint - _previousOffset;
      _previousOffset = details.focalPoint;
      setState(() {
        localOffset =
            Offset(localOffset.dx + delta.dx, localOffset.dy + delta.dy);
      });
    } else {
      setState(() {
        _scale = _previousScale * details.scale;
        final double tempRotation =
            _rotation - _previousRotation - details.rotation;
        final deg = tempRotation.abs() * (180 / math.pi);
        if (deg < 20) {
          _rotation = 0;
          _previousRotation = 0;
        } else {
          _rotation -= _previousRotation - details.rotation;
        }
        _previousRotation = details.rotation;
      });
    }
  }

  void onTapHandler() {
    print("@onTapHandler");
    setState(() {
      isWidgetSelected = !isWidgetSelected;
    });
    if (isWidgetSelected) {
      widget.onWidgetSelected(widget);
    } else {
      widget.onWidgetReleased(widget);
    }
  }

  @override
  Widget build(BuildContext context) {
    /*return InteractiveViewer(
      maxScale: 10,
      minScale: 1,
      child: GestureDetector(
        onTap: () { onTapHandler();},
        child: DottedBorder(
            color: isWidgetSelected ? Colors.black : Colors.transparent,
            dashPattern: [8, 4],
            strokeWidth: 2,
            child: Container(padding: const EdgeInsets.all(20), child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fontName,
                    color: fontColor,
                    fontSize: 30 * _scale)))),
      ),
    );*/
    final size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    return isWidgetSelected
        ? Positioned(
            left: localOffset.dx,
            top: localOffset.dy,
            child: Transform.rotate(
              angle: _rotation,
              child: GestureDetector(
                  onScaleStart: onScaleStartHandler,
                  onScaleUpdate: onScaleUpdateHandler,
                  child: buildTextContainer2(itemWidth, itemHeight)),
            ))
        : Positioned(
            left: localOffset.dx,
            top: localOffset.dy,
            child: Transform.rotate(
                angle: _rotation,
                child: buildTextContainer2(itemWidth, itemHeight)),
          );
  }

  Stack buildTextContainer() {
    return Stack(children: [
      RoundShadowButton(
        isSelect: isWidgetSelected,
        onTap: onTapHandler,
        onRemove: onTapRoughyGestureTextRemoveCallback,
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: fontName,
                color: fontColor,
                backgroundColor: Colors.blue,
                fontSize: 35 * _scale)),
      ),
    ]);
  }

  Stack buildTextContainer2(double itemWidth, double itemHeight) {
    /* for(int i=1; i<10; i++) {
      final double scaleSize = 50.0 * math.pow(0.95, i);
      print("@@@@@!!$i : ${text.length} - $scaleSize");
    }*/
    final double calc = 30.0 * math.pow(0.95, text.length);
    final double textScale = _scale * calc;
    if (text.length < 7) {}
    return Stack(children: [
      Container(
        decoration: BoxDecoration(color: Colors.transparent),
        margin: isWidgetSelected ? EdgeInsets.zero : const EdgeInsets.all(50),
        child: Stack(
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                padding: isWidgetSelected
                    ? const EdgeInsets.all(50)
                    : EdgeInsets.zero,
                child: GestureDetector(
                  onTap: () {
                    onTapHandler();
                  },
                  child: DottedBorder(
                    color: isWidgetSelected ? Colors.black : Colors.transparent,
                    dashPattern: [8, 4],
                    strokeWidth: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15 - _scale, horizontal: 25 - _scale),
                      child: Text(text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: fontName,
                              color: fontColor,
                              //backgroundColor: Colors.blue,
                              fontSize: 2 * textScale)),
                    ),
                  ),
                ),
              ),
            ),
            if (isWidgetSelected)
              Positioned(
                top: 40,
                right: 40,
                child: ClipOval(
                  child: Material(
                    color: Colors.black,
                    child: InkWell(
                      splashColor: Colors.red,
                      onTap: () {
                        onTapRoughyGestureTextRemoveCallback();
                      }, // inkwell color
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    ]);
  }
}
