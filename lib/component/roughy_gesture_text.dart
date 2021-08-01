import 'dart:math' as math;

import 'package:Roughy/component/roughy_gesture_text_controller.dart';
import 'package:Roughy/component/round_shadow_button.dart';
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

  RoughyGestureText(
      {required this.text,
      required this.fontName,
      required this.fontColor,
      required this.onWidgetSelected,
      required this.onWidgetReleased,
      required this.onTapRoughyGestureTextRemove,
      required this.roughyGestureTextController,
      required Key key})
      : super(key: key);

  @override
  _RoughyGestureTextState createState() => _RoughyGestureTextState(
      roughyGestureTextController, text, fontName, fontColor);
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

  _RoughyGestureTextState(RoughyGestureTextController _controller, this.text,
      this.fontName, this.fontColor) {
    _controller.setWidgetSelected = setWidgetSelected;
    _controller.setFont = setFont;
    _controller.setFontColor = setFontColor;
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

  void onScaleStartHandler(ScaleStartDetails details) {
    print("~~~~");
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
    return Positioned(
        left: localOffset.dx,
        top: localOffset.dy,
        child: Transform.rotate(
          angle: _rotation,
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: onScaleStartHandler,
              onScaleUpdate: onScaleUpdateHandler,
              onTap: onTapHandler,
              child: buildTextContainer()),
        ));
  }

  Stack buildTextContainer() {
    return Stack(children: [
      RoundShadowButton(
        isSelect: isWidgetSelected,
        onRemove: onTapRoughyGestureTextRemoveCallback,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: fontName,
                      color: fontColor,
                      fontSize: 30 * _scale)),
            ]),
      ),
    ]);
  }
}
