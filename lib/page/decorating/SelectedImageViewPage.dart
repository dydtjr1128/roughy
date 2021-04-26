import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:Roughy/component/OutlineCircleButton.dart';
import 'package:Roughy/component/OutlineRoundButton.dart';
import 'package:Roughy/component/RoughyGestureTextController.dart';
import 'package:Roughy/component/painter/RoughyBackgroundPainter.dart';
import 'package:Roughy/component/roughyDownloadAppBar.dart';
import 'package:Roughy/component/roughyGestureText.dart';
import 'package:Roughy/data/RoughyData.dart';
import 'package:Roughy/page/decorating/TextInputPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class SelectedImageViewPage extends StatefulWidget {
  final File templateImage, croppedImage;

  SelectedImageViewPage({required this.croppedImage, required this.templateImage});

  @override
  _SelectedImageViewPageState createState() => _SelectedImageViewPageState();
}

class _SelectedImageViewPageState extends State<SelectedImageViewPage> {
  late ui.Image _templateImage, _croppedImage;
  bool isDrawingPanelVisible = false;
  bool isTextEditPanelVisible = false;
  final List<dynamic> points = [];
  final List<String> textFontList;
  final List<RoughyGestureText> gestureTextList = [];
  RoughyGestureText? selectedRoughyGestureText;
  final List<ui.Color> drawingColors;
  final List<double> drawingLineDepths;
  late String selectedTextRoughyFont;
  late Color selectedDrawingColor;
  late double selectedDrawingLineDepth;
  GlobalKey captureKey = GlobalKey();
  bool isCaptureMode = false;

  _SelectedImageViewPageState()
      : this.isCaptureMode = false,
        this.isDrawingPanelVisible = false,
        this.isTextEditPanelVisible = false,
        this.drawingColors = [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(126, 126, 126, 1),
          Color.fromRGBO(0, 0, 0, 1),
          Color.fromRGBO(229, 36, 36, 1),
          Color.fromRGBO(255, 169, 36, 1),
          Color.fromRGBO(12, 178, 101, 1),
          Color.fromRGBO(0, 26, 197, 1)
        ],
        drawingLineDepths = [1, 3, 5, 7, 9],
        textFontList = [
          "AdobeHebrewRegular",
          "AppleSDGothicNeoB",
          "AlphaClouds",
          "SimplicityRegular",
          "Janitor"
        ] {
    selectedTextRoughyFont = textFontList[1];
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

  void onDrawingRollbackButtonClicked(BuildContext context) {
    if (points.isEmpty) return;
    setState(() {
      points.removeLast();
      for (int i = points.length - 1; i >= 0; i--) {
        if (points.isEmpty || points[i] == null) break;
        points.removeLast();
      }
    });
  }

  void onDrawEditButtonClicked(BuildContext context) {
    setState(() {
      setAllRoughyGestureTextWidgetChangToNotSelected();
      switchToDrawingEditPanelPanel();
    });
  }

  void onTextEditButtonClicked(BuildContext context) async {
    final String? result = await Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => TextInputPage(),
      ),
    );
    if (result == null || result.trim().isEmpty) {
      return;
    }
    setState(() {
      switchToTextEditPanel();
      gestureTextList.add(new RoughyGestureText(
          roughyGestureTextController: RoughyGestureTextController(),
          onWidgetSelected: onRoughyTextWidgetSelected,
          onWidgetReleased: onRoughyTextWidgetReleased,
          onTapRoughyGestureTextRemove: onTapRoughyGestureTextRemove,
          key: Key((gestureTextList.length).toString()),
          roughyTextPoint: new RoughyTextPoint(
            offset: Offset(100, 100),
            color: selectedDrawingColor,
            roughyFont: selectedTextRoughyFont,
            text: result,
          )));
    });
  }

  void onRoughyTextWidgetSelected(RoughyGestureText target) {
    print("onRoughyTextWidgetSelected");
    selectedRoughyGestureText = target;
    for (var widget in gestureTextList) {
      if (widget != target) {
        widget.roughyGestureTextController.setWidgetSelected(false);
      }
    }
    switchToTextEditPanel();
  }

  void onRoughyTextWidgetReleased(RoughyGestureText target) {
    print("onRoughyTextWidgetReleased");
    if (selectedRoughyGestureText == target) selectedRoughyGestureText = null;
    switchToTextEditPanel();
  }

  void onTapRoughyGestureTextRemove(RoughyGestureText target) {
    print("onTapRoughyGestureTextRemove");
    if (selectedRoughyGestureText == target) selectedRoughyGestureText = null;
    gestureTextList.remove(target);
    switchToTextEditPanel();
  }

  void switchToTextEditPanel() {
    setState(() {
      isTextEditPanelVisible = true;
      isDrawingPanelVisible = false;
    });
  }

  void switchToDrawingEditPanelPanel() {
    selectedRoughyGestureText = null;
    setState(() {
      isTextEditPanelVisible = false;
      isDrawingPanelVisible = true;
    });
  }

  void setAllRoughyGestureTextWidgetChangToNotSelected() {
    selectedRoughyGestureText = null;
    for (var widget in gestureTextList) {
      widget.roughyGestureTextController.setWidgetSelected(false);
    }
  }

  void onSelectTextFont(String selectedFontName, int index) {
    print("폰트 선택 : " + selectedFontName.toString() + " " + index.toString());
    setState(() {
      this.selectedTextRoughyFont = selectedFontName;
    });
    if (selectedRoughyGestureText != null && isTextEditPanelVisible) {
      selectedRoughyGestureText!.roughyGestureTextController.setFont(selectedFontName);
    }
  }

  void onSelectDrawingColor(ui.Color selectedDrawingColor, int index) {
    print("색상 선택 : " + selectedDrawingColor.toString() + " " + index.toString());
    setState(() {
      this.selectedDrawingColor = selectedDrawingColor;
    });
    if (selectedRoughyGestureText != null && isTextEditPanelVisible) {
      selectedRoughyGestureText!.roughyGestureTextController.setFontColor(selectedDrawingColor);
    }
  }

  void onSelectDrawingDepth(double selectedDrawingLineDepth, int index) {
    print("두께 선택 : " + selectedDrawingLineDepth.toString() + " " + index.toString());
    setState(() {
      this.selectedDrawingLineDepth = selectedDrawingLineDepth;
    });
  }

  bool isInsideOffset(ui.Offset offset, double width, double height) {
    final double lineDepth = selectedDrawingLineDepth / 2;
    return offset.dx >= lineDepth &&
        offset.dy >= lineDepth &&
        offset.dx <= width - lineDepth &&
        offset.dy <= height - lineDepth;
  }

  Widget getColorPanelWidgets() {
    List<Widget> list = [];
    for (int i = 0; i < drawingColors.length; i++) {
      list.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              onSelectDrawingColor(drawingColors[i], i);
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                  child: OutlineCircleButton(
                radius: 15,
                borderColor: selectedDrawingColor == drawingColors[i]
                    ? Color.fromRGBO(0, 0, 0, 1)
                    : Color.fromRGBO(228, 231, 233, 1),
                borderSize: 1.5,
                foregroundColor: drawingColors[i],
                onTap: () {
                  onSelectDrawingColor(drawingColors[i], i);
                },
              )),
            ),
          ),
        ),
      );
    }
    return Container(
        height: 50,
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color.fromRGBO(245, 245, 245, 1), width: 1)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: list));
  }

  Widget getDrawingLineDepthPanelWidgets() {
    List<Widget> list = [];
    for (int i = 0; i < drawingLineDepths.length; i++) {
      list.add(Expanded(
        child: GestureDetector(
          onTap: () {
            onSelectDrawingDepth(drawingLineDepths[i], i);
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
                child: OutlineCircleButton(
              radius: 25,
              child: Padding(
                padding: EdgeInsets.all(.0),
                child: SvgPicture.asset(
                  'assets/images/logo_depth' + (i + 1).toString() + '.svg',
                  fit: BoxFit.contain,
                  color: selectedDrawingLineDepth == drawingLineDepths[i]
                      ? Colors.black
                      : Colors.black12,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
              onTap: () {
                onSelectDrawingDepth(drawingLineDepths[i], i);
              },
            )),
          ),
        ),
      ));
    }
    return Container(
      height: 50,
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color.fromRGBO(245, 245, 245, 1), width: 1)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: list),
    );
  }

  Widget getTextPanelWidgets() {
    List<Widget> list = [];
    for (int i = 0; i < textFontList.length; i++) {
      list.add(
        Container(
          child: OutlineRoundButton(
              radius: 15.0,
              onTap: () => onSelectTextFont(textFontList[i], i),
              child: Center(
                  child: Text(
                "ABCabc",
                style: TextStyle(
                    fontFamily: textFontList[i],
                    fontSize: 14,
                    color: selectedTextRoughyFont == textFontList[i] ? Colors.black : Colors.grey),
              ))),
        ),
      );
    }

    return Container(
        height: 50,
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color.fromRGBO(245, 245, 245, 1), width: 1)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: list),
        ));
  }

  Widget getCanvas(templateWidth, templateHeight) {
    return RepaintBoundary(
      key: captureKey,
      child: Container(
          width: templateWidth,
          height: templateHeight,
          child: CustomPaint(
            //size: Size(templateWidth, templateHeight),
            //size: Size(_templateImage.width.toDouble(), _templateImage.height.toDouble()),
            child: Stack(
              children: [
                for (var widget in gestureTextList) widget,
              ],
            ),
            painter: RoughyBackgroundPainter(
                croppedImage: _croppedImage,
                templateImage: _templateImage,
                points: points,
                drawingColor: selectedDrawingColor,
                drawingDepth: selectedDrawingLineDepth),
/*                                          foregroundPainter: RoughyForegroundPainter(
                                              points: points,
                                              drawingColor: selectedDrawingColor,
                                              drawingDepth: selectedDrawingLineDepth),*/
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    final double templateHeight = (itemHeight - 150) * 0.7;
    final double templateWidth =
        templateHeight * _templateImage.width.toDouble() / _templateImage.height.toDouble();

    void updateDrawingPosition(ui.Offset localOffset) {
      if (isDrawingPanelVisible) {
        setState(() {
          if (isInsideOffset(localOffset, templateWidth, templateHeight)) {
            setState(() {
              points.add(new RoughyDrawingPoint(
                  offset: localOffset,
                  color: selectedDrawingColor,
                  depth: selectedDrawingLineDepth));
            });
          }
        });
      }
    }

    void initializeDrawingPosition() {
      if (isDrawingPanelVisible) {
        setState(() {
          points.add(null);
        });
      }
    }

    Future<void> _capturePng() async {
      RenderRepaintBoundary boundary =
          captureKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3);
      ByteData byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      Uint8List pngBytes = byteData.buffer.asUint8List();

      String dir = (await getApplicationSupportDirectory()).path;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
      String fullPath = '$dir/roughy_$formattedDate.png';
      File file = File(fullPath);
      print(fullPath);
      await file.writeAsBytes(pngBytes);

/*      DateTime now = DateTime.now();
      String dir = (await getApplicationSupportDirectory()).path;
      String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
      screenshotController.captureAndSave(dir, //set path where screenshot will be saved
          fileName: 'roughy_$formattedDate.png');*/
      setState(() {
        isCaptureMode = false;
      });
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 235, 235, 1),
      appBar: RoughyDownloadAppBar(
        onClickedCallback: () async {
          setAllRoughyGestureTextWidgetChangToNotSelected();
          setState(() {
            isCaptureMode = true;
          });
          await showPlatformDialog(
            context: context,
            builder: (_) => PlatformAlertDialog(
              title: Text('알림'),
              content: Text('사진을 사진첩에 저장하시겠습니까?'),
              actions: <Widget>[
                PlatformDialogAction(
                    child: PlatformText('Yes'),
                    onPressed: () {
                      _capturePng();
                      Navigator.pop(context);
                      showPlatformDialog(
                          context: context,
                          builder: (_) => PlatformAlertDialog(
                                  title: Text('알림'),
                                  content: Text('저장완료!'),
                                  actions: <Widget>[
                                    PlatformDialogAction(
                                        child: PlatformText('Okay'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        })
                                  ]));
                    }),
                PlatformDialogAction(
                  child: PlatformText('No'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
          setState(() {
            isCaptureMode = false;
          });
        },
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
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: setAllRoughyGestureTextWidgetChangToNotSelected,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.transparent),
                      ),
                      Container(
                        child: Center(
                          child: Container(
                              width: templateWidth,
                              height: templateHeight,
                              decoration: new BoxDecoration(
                                color: Colors.black,
                              ),
                              child: isDrawingPanelVisible
                                  ? GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onPanCancel: () => initializeDrawingPosition(),
                                      onPanStart: (details) =>
                                          updateDrawingPosition(details.localPosition),
                                      onPanDown: (details) =>
                                          updateDrawingPosition(details.localPosition),
                                      onPanUpdate: (details) =>
                                          updateDrawingPosition(details.localPosition),
                                      onPanEnd: (details) => initializeDrawingPosition(),
                                      child: getCanvas(templateWidth, templateHeight))
                                  : getCanvas(templateWidth, templateHeight)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isTextEditPanelVisible ? getColorPanelWidgets() : new Row(),
              isTextEditPanelVisible ? getTextPanelWidgets() : new Row(),
              isDrawingPanelVisible ? getColorPanelWidgets() : new Row(),
              isDrawingPanelVisible ? getDrawingLineDepthPanelWidgets() : new Row(),
              Row(
                children: [
                  Container(
                      width: itemWidth,
                      height: 50.0,
                      decoration: new BoxDecoration(color: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        child: Row(children: <Widget>[
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                            OutlineCircleButton(
                                radius: 45.0,
                                foregroundColor: Colors.black,
                                onTap: () => onTextEditButtonClicked(context),
                                child: const Center(
                                    child: const Text(
                                  "T",
                                  style: TextStyle(color: Colors.white, fontSize: 30),
                                )))
                          ]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                            OutlineCircleButton(
                                radius: 45.0,
                                foregroundColor: Colors.black,
                                onTap: () => onDrawEditButtonClicked(context),
                                child: Center(
                                    child: SvgPicture.asset('assets/images/logo.svg',
                                        color: Colors.white, height: 25, width: 25)))
                          ]),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isDrawingPanelVisible
                                        ? OutlineRoundButton(
                                            radius: 15.0,
                                            foregroundColor: Colors.black,
                                            onTap: () => onDrawingRollbackButtonClicked(context),
                                            child: const Center(
                                                child: const Text(
                                              "되돌리기",
                                              style: TextStyle(color: Colors.white, fontSize: 16),
                                            )))
                                        : Container()
                                  ],
                                )
                              ])),
                        ]),
                      ))
                ],
              )
            ],
          )),
    );
  }
}
