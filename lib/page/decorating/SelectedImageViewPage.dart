import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:Roughy/component/OutlineCircleButton.dart';
import 'package:Roughy/component/OutlineRoundButton.dart';
import 'package:Roughy/component/RoughyBottomAppbar.dart';
import 'package:Roughy/component/RoughyGestureTextController.dart';
import 'package:Roughy/component/painter/RoughyBackgroundPainter.dart';
import 'package:Roughy/component/roughyAppBar.dart';
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
  String titleText;
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
  final Color selectedIconColor, unselectedIconColor;
  List<Widget> stackChildren = [];
  double croppedOpacity;
  bool isInteractiveViewerFront;
  late InteractiveViewer _croppedImageInteractiveViewer;
  late CustomPaint _customPaint;
  bool isIgnoreTouch;

  _SelectedImageViewPageState()
      : this.titleText = "Roughy",
        this.isCaptureMode = false,
        this.isDrawingPanelVisible = false,
        this.isTextEditPanelVisible = false,
        this.selectedIconColor = Color.fromRGBO(134, 185, 232, 1),
        this.unselectedIconColor = Color.fromRGBO(217, 217, 217, 1),
        this.drawingColors = [
          Color.fromRGBO(255, 255, 255, 1.0),
          Color.fromRGBO(126, 126, 126, 1.0),
          Color.fromRGBO(0, 0, 0, 1.0),
          Color.fromRGBO(255, 58, 58, 1.0),
          Color.fromRGBO(255, 251, 138, 1.0),
          Color.fromRGBO(11, 209, 135, 1.0),
          Color.fromRGBO(17, 0, 254, 1.0)
        ],
        drawingLineDepths = [1, 3, 5, 7, 9],
        textFontList = [
          "ChosunNm",
          "SpoqaHanSansNeoRegular",
          "SDSamliphopangcheTTFOutline",
          "MiMi",
          "HYUNJUNG"
        ],
        this.isIgnoreTouch = true,
        this.isInteractiveViewerFront = true,
        this.croppedOpacity = 0.7 {
    selectedTextRoughyFont = textFontList[1];
    selectedDrawingColor = drawingColors[2];
    selectedDrawingLineDepth = drawingLineDepths[2];
  }

  @override
  void initState() {
    super.initState();
    initializeImages();
  }

  Future<ui.Image> loadImage(Uint8List list) async {
    ui.Codec codec = await ui.instantiateImageCodec(list);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  initializeImages() async {
    ByteData data = await rootBundle.load(widget.templateImage.path);

    final templateImage = await loadImage(Uint8List.view(data.buffer));

    // croppedImage 와 같이 빌드시 만든 이미지가 아닌 경우 바이트 읽어와서 따로 처리해야함
    final croppedImage = await loadImage(widget.croppedImage.readAsBytesSync());

    // @@@@ 이건 테스트 이미지 코드
/*    ByteData data = await rootBundle.load(widget.templateImage.path);
    ByteData data2 = await rootBundle.load(widget.croppedImage.path);
    final templateImage = await loadImage(Uint8List.view(data.buffer));
    final croppedImage = await loadImage(Uint8List.view(data2.buffer));*/

    setState(() {
      _templateImage = templateImage;
      _croppedImage = croppedImage;
      _croppedImageInteractiveViewer = croppedImageInteractiveViewer(
          templateImage.width.toDouble(), templateImage.height.toDouble());
      _customPaint = roughyCustomPaint();
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

  void onResizeButtonClicked(BuildContext context) {
    selectedRoughyGestureText = null;
    setState(() {
      swapStackChildren();
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
          key: UniqueKey(),
          //Key((gestureTextList.length).toString())
          text: result,
          fontName: selectedTextRoughyFont,
          fontColor: selectedDrawingColor));
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
      titleText = "Text";
    });
  }

  void switchToDrawingEditPanelPanel() {
    selectedRoughyGestureText = null;
    setState(() {
      isTextEditPanelVisible = false;
      isDrawingPanelVisible = true;
      titleText = "Brush";
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
                radius: 20,
                borderColor: selectedDrawingColor == drawingColors[i]
                    ? Color.fromRGBO(0, 0, 0, 1)
                    : Color.fromRGBO(228, 231, 233, 1),
                borderSize: 1.5,
                foregroundColor: drawingColors[i],
                child: selectedDrawingColor == drawingColors[i]
                    ? Center(
                        child: Container(
                            child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14.0,
                      )))
                    : null,
                onTap: () {
                  onSelectDrawingColor(drawingColors[i], i);
                },
              )),
            ),
          ),
        ),
      );
    }
    return RoughyBottomAppbar(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: list));
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
    return RoughyBottomAppbar(
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

    return RoughyBottomAppbar(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: list),
    ));
  }

  /*Widget getCanvas(templateWidth, templateHeight) {
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
                InteractiveViewer(
                    constrained: false,
                    child: Container(
                        width: templateWidth,
                        height: templateHeight,
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.6), BlendMode.dstATop),
                                image: FileImage(
                                  widget.croppedImage
                                ))))),
                for (var widget in gestureTextList) widget,
                //Image.asset(widget.templateImage.path)
              ],
            ),
            painter: RoughyBackgroundPainter(
                //croppedImage: _croppedImage,
                templateImage: _templateImage,
                points: points,
                drawingColor: selectedDrawingColor,
                drawingDepth: selectedDrawingLineDepth),
*/ /*                                          foregroundPainter: RoughyForegroundPainter(
                                              points: points,
                                              drawingColor: selectedDrawingColor,
                                              drawingDepth: selectedDrawingLineDepth),*/ /*
          )),
    );
  }*/
  Widget getCanvas(templateWidth, templateHeight) {
    return RepaintBoundary(
      key: captureKey,
      child: Container(
        width: templateWidth,
        height: templateHeight,
        child: Stack(children: getStackChildren()),
      ),
    );
  }

  CustomPaint roughyCustomPaint() {
    return CustomPaint(
      //size: Size(templateWidth, templateHeight),
      //size: Size(_templateImage.width.toDouble(), _templateImage.height.toDouble()),
      child: Stack(
        children: [
          for (var widget in gestureTextList) widget,
          //Image.asset(widget.templateImage.path)
        ],
      ),
      painter: RoughyBackgroundPainter(
          //croppedImage: _croppedImage,
          templateImage: _templateImage,
          points: points,
          drawingColor: selectedDrawingColor,
          drawingDepth: selectedDrawingLineDepth),
/*                                          foregroundPainter: RoughyForegroundPainter(
                                                points: points,
                                                drawingColor: selectedDrawingColor,
                                                drawingDepth: selectedDrawingLineDepth),*/
    );
  }

  void swapStackChildren() {
    print("swap");
    isInteractiveViewerFront = !isInteractiveViewerFront;
/*    if(isInteractiveViewerFront == false) {
      final temp = stackChildren[0];
      stackChildren[0] = stackChildren[1];
      stackChildren[1] = temp;
    }*/
  }

  List<Widget> getStackChildren() {
    if (isInteractiveViewerFront) {
      isIgnoreTouch = false;
      print("true");
    } else {
      isIgnoreTouch = true;
      print("false");
    }
    stackChildren = [
      croppedImageInteractiveViewer(_templateImage.width.toDouble(),_templateImage.height.toDouble()),
      IgnorePointer(
        ignoring: isIgnoreTouch,
        child:  roughyCustomPaint(),
      )
      ,//새로 안만들면 드로잉이 새로고침이 안됨(리페인트에서)
    ];
    return stackChildren;
  }

  InteractiveViewer croppedImageInteractiveViewer(double width, double height) {
    return InteractiveViewer(
        constrained: true,
        panEnabled: true,
        scaleEnabled: true,
        onInteractionStart: (details) {
          print("!!!dd");
        },
        onInteractionUpdate: (details) {
          print("!!!" + details.toString());
        },
        onInteractionEnd: (details) {
          print("@@@@@@" + details.toString());
        },
        child: Container(
            width: width,
            height: height,
            decoration: new BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(croppedOpacity), BlendMode.dstATop),
                    image: FileImage(widget.croppedImage)))));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    final templateHeight = (itemHeight - 150) * 0.7;
    final templateWidth =
        templateHeight * _templateImage.width.toDouble() / _templateImage.height.toDouble();
    print("templateHeight : " +
        templateHeight.toString() +
        ", templateWidth : " +
        templateWidth.toString());

    print("itemHeight : " + itemHeight.toString() + ", itemWidth : " + itemWidth.toString());

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
      appBar: RoughyAppBar(
        titleText: titleText,
        isCenterTitle: true,
        iconWidget: new IconButton(
          icon: SvgPicture.asset('assets/images/download.svg',
              color: Colors.black, height: 25, width: 25),
          tooltip: "Download",
          onPressed: () {
            setState(() {
              setAllRoughyGestureTextWidgetChangToNotSelected();
              setState(() {
                isCaptureMode = true;
              });
              showPlatformDialog(
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
            });
          },
          color: Colors.red,
        ),
      ),
      body: Container(
          decoration: new BoxDecoration(
            color: Color.fromRGBO(249, 249, 249, 1),
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
                      FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        child: Padding(
                            padding: const EdgeInsets.all(35),
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
                    ],
                  ),
                ),
              ),
              isTextEditPanelVisible ? getColorPanelWidgets() : new Row(),
              isTextEditPanelVisible ? getTextPanelWidgets() : new Row(),
              isDrawingPanelVisible ? getColorPanelWidgets() : new Row(),
              isDrawingPanelVisible ? getDrawingLineDepthPanelWidgets() : new Row(),
              RoughyBottomAppbar(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: Row(children: <Widget>[
                  OutlineCircleButton(
                      radius: 45.0,
                      onTap: () => onTextEditButtonClicked(context),
                      child: Center(
                          child: SvgPicture.asset('assets/icons/text.svg',
                              width: 24,
                              height: 24,
                              color: isTextEditPanelVisible
                                  ? selectedIconColor
                                  : unselectedIconColor))),
                  OutlineCircleButton(
                      radius: 45.0,
                      onTap: () => onDrawEditButtonClicked(context),
                      child: Center(
                          child: SvgPicture.asset('assets/icons/roughy_option.svg',
                              width: 28,
                              height: 24,
                              color: isDrawingPanelVisible
                                  ? selectedIconColor
                                  : unselectedIconColor))),
                  OutlineCircleButton(
                      radius: 45.0,
                      onTap: () => onResizeButtonClicked(context),
                      child: Center(
                          child: SvgPicture.asset('assets/icons/roughy_option.svg',
                              width: 28,
                              height: 24,
                              color: isDrawingPanelVisible
                                  ? selectedIconColor
                                  : unselectedIconColor))),
                  Expanded(child: SizedBox()),
                  isDrawingPanelVisible
                      ? OutlineRoundButton(
                          radius: 15.0,
                          foregroundColor: Colors.white,
                          onTap: () => onDrawingRollbackButtonClicked(context),
                          child: const Center(
                              child: const Text(
                            "되돌리기",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )))
                      : Container()
                ]),
              ))
            ],
          )),
    );
  }
}
