import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:Roughy/component/OutlineCircleButton.dart';
import 'package:Roughy/component/OutlineRoundButton.dart';
import 'package:Roughy/component/paintor/RoughyBackgroundPainter.dart';
import 'package:Roughy/component/paintor/RoughyForegroundPainter.dart';
import 'package:Roughy/component/roughyCenterAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectedImageViewPage extends StatefulWidget {
  final File templateImage, croppedImage;

  SelectedImageViewPage(
      {@required this.croppedImage, @required this.templateImage});

  @override
  _SelectedImageViewPageState createState() => _SelectedImageViewPageState();
}

class RoughyDrawingPoint {
  ui.Offset offset;
  ui.Color color;
  double depth;

  RoughyDrawingPoint(
      {@required this.offset, @required this.color, @required this.depth});
}

class RoughyTextPoint {
  ui.Offset offset;
  ui.Color color;
  String text;

  RoughyTextPoint(
      {@required this.offset, @required this.color, @required this.text});
}

class _SelectedImageViewPageState extends State<SelectedImageViewPage> {
  File changedImage;
  ui.Image _templateImage, _croppedImage;
  bool isDrawingPanelVisible;
  bool isTextEditPanelVisible;
  List<RoughyDrawingPoint> points = [];
  Color selectedDrawingColor;
  double selectedDrawingLineDepth;
  final List<ui.Color> drawingColors = [];
  final List<double> drawingLineDepths = [];
  final List<String> textFontList = [];

  _SelectedImageViewPageState() {
    this.isDrawingPanelVisible = true;
    this.isTextEditPanelVisible = false;
    this.drawingColors
      ..add(Color.fromRGBO(255, 255, 255, 1))
      ..add(Color.fromRGBO(126, 126, 126, 1))
      ..add(Color.fromRGBO(0, 0, 0, 1))
      ..add(Color.fromRGBO(229, 36, 36, 1))
      ..add(Color.fromRGBO(255, 169, 36, 1))
      ..add(Color.fromRGBO(12, 178, 101, 1))
      ..add(Color.fromRGBO(0, 26, 197, 1));
    drawingLineDepths..add(1)..add(3)..add(5)..add(7)..add(9);
    textFontList
      ..add("AlphaClouds")
      ..add("AlphaClouds")
      ..add("AlphaClouds")
      ..add("SimplicityRegular")
      ..add("Janitor");
    selectedDrawingColor = drawingColors[2];
    selectedDrawingLineDepth = drawingLineDepths[2];
  }

  @override
  void initState() {
    initializeImages();
  }

  Future<ui.Image> loadImage(Uint8List list) async {
    ui.Codec codec = await ui.instantiateImageCodec(list);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  initializeImages() async {
    /*ByteData data = await rootBundle.load(widget.templateImage.path);

    final templateImage = await loadImage(Uint8List.view(data.buffer));

    // croppedImage 와 같이 빌드시 만든 이미지가 아닌 경우 바이트 읽어와서 따로 처리해야함
    final croppedImage = await loadImage(widget.croppedImage.readAsBytesSync());*/

    // @@@@ 이건 테스트 이미지 코드
    ByteData data = await rootBundle.load(widget.templateImage.path);
    ByteData data2 = await rootBundle.load(widget.croppedImage.path);
    final templateImage = await loadImage(Uint8List.view(data.buffer));
    final croppedImage = await loadImage(Uint8List.view(data2.buffer));

    setState(() {
      _templateImage = templateImage;
      _croppedImage = croppedImage;
    });
  }

  onImageSettingButtonClicked(BuildContext context) {
    Navigator.pop(context, changedImage);
  }

  onDrawEditButtonClicked(BuildContext context) {
    setState(() {
      isDrawingPanelVisible = !isDrawingPanelVisible;
      isTextEditPanelVisible = false;
    });
  }

  onTextEditButtonClicked(BuildContext context) {
    setState(() {
      isTextEditPanelVisible = !isTextEditPanelVisible;
      isDrawingPanelVisible = false;
    });
  }

  void onSelectDrawingColor(ui.Color selectedDrawingColor, int index) {
    print(
        "색상 선택 : " + selectedDrawingColor.toString() + " " + index.toString());
    this.selectedDrawingColor = selectedDrawingColor;
  }

  void onSelectDrawingDepth(double selectedDrawingLineDepth, int index) {
    print("두께 선택 : " +
        selectedDrawingLineDepth.toString() +
        " " +
        index.toString());
    this.selectedDrawingLineDepth = selectedDrawingLineDepth;
  }

  Widget getDrawingPanelWidgets() {
    List<Widget> list = [];
    for (int i = 0; i < drawingColors.length; i++) {
      list.add(ClipOval(
          child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(228, 231, 233, 1), width: 1),
                color: drawingColors[i],
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    child: SizedBox(),
                    onTap: () async {
                      onSelectDrawingColor(drawingColors[i], i);
                    }),
              ))));
    }
    return Container(
        height: 50,
        decoration: new BoxDecoration(
            color: Colors.white,
            border:
                Border.all(color: Color.fromRGBO(245, 245, 245, 1), width: 2)),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: list)));
  }

  Widget getDrawingLineDepthPanelWidgets() {
    List<Widget> list = [];
    for (int i = 0; i < drawingLineDepths.length; i++) {
      list.add(ClipOval(
          child: Container(
        child: Material(
          child: InkWell(
              child: SvgPicture.asset(
                'assets/images/logo_depth' + (i + 1).toString() + '.svg',
                color: Colors.black,
              ),
              onTap: () async {
                onSelectDrawingDepth(drawingLineDepths[i], i);
              }),
        ),
      )));
    }
    return Container(
        height: 50,
        decoration: new BoxDecoration(
            color: Colors.white,
            border:
                Border.all(color: Color.fromRGBO(245, 245, 245, 1), width: 1)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: list),
        ));
  }

  Widget getTextPanelWidgets() {
    List<Widget> list = [];
    for (int i = 0; i < textFontList.length; i++) {
      list.add(ClipOval(
          child: Container(
        child: Material(
          child: InkWell(
              child: PlatformText("ABCabc",
                  style: TextStyle(
                      fontFamily: textFontList[i],
                      fontSize: 15,
                      color: Colors.black)),
              onTap: () async {
                onSelectDrawingDepth(drawingLineDepths[i], i);
              }),
        ),
      )));
    }
    return Container(
        height: 50,
        decoration: new BoxDecoration(
            color: Colors.white,
            border:
                Border.all(color: Color.fromRGBO(245, 245, 245, 1), width: 1)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: list),
        ));
  }

  bool isInsideOffset(ui.Offset offset, double width, double height) {
    return offset.dx >= 0 &&
        offset.dy >= 0 &&
        offset.dx <= width &&
        offset.dy <= height;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    final double templateHeight = (itemHeight - 150) * 0.7;
    final double templateWidth = templateHeight *
        _templateImage.width.toDouble() /
        _templateImage.height.toDouble();

    void updateDrawingPosition(ui.Offset localOffset) {
      if (isDrawingPanelVisible) {
        setState(() {
          if (isInsideOffset(localOffset, templateWidth, templateHeight)) {
            points.add(RoughyDrawingPoint(
                offset: localOffset,
                color: selectedDrawingColor,
                depth: selectedDrawingLineDepth));
          }
        });
      }
    }

    return Scaffold(
        backgroundColor: Color.fromRGBO(235, 235, 235, 1),
        appBar: RoughyCenterAppBar(
          title: "template",
        ),
        body: Container(
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.croppedImage == null || widget.templateImage == null
                        ? Text('No image selected.')
                        : Container(
                            width: templateWidth,
                            height: templateHeight,
                            decoration: new BoxDecoration(
                              color: Colors.black,
                            ),
                            child: GestureDetector(
                                onPanDown: (details) {
                                  updateDrawingPosition(details.localPosition);
                                },
                                onPanUpdate: (details) {
                                  updateDrawingPosition(details.localPosition);
                                },
                                onPanEnd: (details) => points.add(null),
                                child: Container(
                                    width: templateWidth,
                                    height: templateHeight,
                                    child: CustomPaint(
                                      //size: Size(templateWidth, templateHeight),
                                      //size: Size(_templateImage.width.toDouble(), _templateImage.height.toDouble()),
                                      painter: RoughyBackgroundPainter(
                                          croppedImage: _croppedImage,
                                          templateImage: _templateImage),
                                      foregroundPainter:
                                          RoughyForegroundPainter(
                                              points: points,
                                              drawingColor:
                                                  selectedDrawingColor,
                                              drawingDepth:
                                                  selectedDrawingLineDepth),
                                    ))),
                          )
                  ],
                )),
                isTextEditPanelVisible ? getDrawingPanelWidgets() : new Row(),
                isTextEditPanelVisible ? getTextPanelWidgets() : new Row(),
                isDrawingPanelVisible ? getDrawingPanelWidgets() : new Row(),
                isDrawingPanelVisible
                    ? getDrawingLineDepthPanelWidgets()
                    : new Row(),
                Row(
                  children: [
                    Container(
                        width: itemWidth,
                        height: 50.0,
                        decoration: new BoxDecoration(color: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          child: Row(children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  OutlineCircleButton(
                                      radius: 45.0,
                                      foregroundColor: Colors.black,
                                      onTap: () =>
                                          onTextEditButtonClicked(context),
                                      child: Center(
                                          child: Text(
                                        "T",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      )))
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  OutlineCircleButton(
                                      radius: 45.0,
                                      foregroundColor: Colors.black,
                                      onTap: () =>
                                          onDrawEditButtonClicked(context),
                                      child: Center(
                                          child: SvgPicture.asset(
                                              'assets/images/logo.svg',
                                              color: Colors.white,
                                              height: 25,
                                              width: 25)))
                                ]),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlineRoundButton(
                                          radius: 15.0,
                                          foregroundColor: Colors.black,
                                          onTap: () =>
                                              onImageSettingButtonClicked(
                                                  context),
                                          child: Center(
                                              child: Text(
                                            "되돌리기",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          )))
                                    ],
                                  )
                                ])),
                          ]),
                        ))
                  ],
                )
              ],
            )));
  }
}
