import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:Roughy/component/outline_circle_button.dart';
import 'package:Roughy/component/outline_round_button.dart';
import 'package:Roughy/component/painter/roughy_background_painter.dart';
import 'package:Roughy/component/roughy_app_bar.dart';
import 'package:Roughy/component/roughy_bottom_appbar.dart';
import 'package:Roughy/component/roughy_gesture_text.dart';
import 'package:Roughy/component/roughy_gesture_text_controller.dart';
import 'package:Roughy/data/roughy_data.dart';
import 'package:Roughy/page/decorating/text_input_page.dart';
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
  final File templateImage;
  final File croppedImage;

  const SelectedImageViewPage(
      {required this.croppedImage, required this.templateImage});

  @override
  _SelectedImageViewPageState createState() => _SelectedImageViewPageState();
}

class _SelectedImageViewPageState extends State<SelectedImageViewPage> {
  String titleText;
  late ui.Image _templateImage;
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
  final Color selectedIconColor;
  final Color unselectedIconColor;
  List<Widget> stackChildren = [];
  bool isInteractiveViewerFront;
  bool isNextButtonClicked;
  bool isIgnoreTouch;
  bool isImageLoaded;

  _SelectedImageViewPageState()
      : titleText = "Roughy",
        isCaptureMode = false,
        isDrawingPanelVisible = false,
        isTextEditPanelVisible = false,
        isImageLoaded = false,
        selectedIconColor = const Color.fromRGBO(134, 185, 232, 1),
        unselectedIconColor = const Color.fromRGBO(217, 217, 217, 1),
        drawingColors = [
          const Color.fromRGBO(255, 255, 255, 1.0),
          const Color.fromRGBO(126, 126, 126, 1.0),
          const Color.fromRGBO(0, 0, 0, 1.0),
          const Color.fromRGBO(255, 58, 58, 1.0),
          const Color.fromRGBO(255, 251, 138, 1.0),
          const Color.fromRGBO(11, 209, 135, 1.0),
          const Color.fromRGBO(17, 0, 254, 1.0)
        ],
        drawingLineDepths = [1, 3, 5, 7, 9],
        textFontList = [
          "Eulyoo1945-SemiBold",
          "Pretendard-Medium",
          "UhBee-Rice",
          "Solinsunny",
          "PFStardust",
        ],
        isNextButtonClicked = false,
        isIgnoreTouch = true,
        isInteractiveViewerFront = true {
    selectedTextRoughyFont = textFontList[1];
    selectedDrawingColor = drawingColors[2];
    selectedDrawingLineDepth = drawingLineDepths[2];
  }

  @override
  void initState() {
    super.initState();
    initializeImages().then((templateImage) {
      setState(() {
        _templateImage = templateImage;
        isImageLoaded = true;
      });
    });
  }

  Future<ui.Image> loadImage(Uint8List list) async {
    final ui.Codec codec = await ui.instantiateImageCodec(list);
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  Future<ui.Image> initializeImages() async {
    final ByteData data = await rootBundle.load(widget.templateImage.path);

    final ui.Image templateImage = await loadImage(Uint8List.view(data.buffer));

    // croppedImage 와 같이 빌드시 만든 이미지가 아닌 경우 바이트 읽어와서 따로 처리해야함
    final ui.Image croppedImage =
        await loadImage(widget.croppedImage.readAsBytesSync());

    // @@@@ 이건 테스트 이미지 코드
/*    ByteData data = await rootBundle.load(widget.templateImage.path);
    ByteData data2 = await rootBundle.load(widget.croppedImage.path);
    final templateImage = await loadImage(Uint8List.view(data.buffer));
    final croppedImage = await loadImage(Uint8List.view(data2.buffer));*/
    return templateImage;
  }

  void onDrawingRollbackButtonClicked() {
    if (points.isEmpty) return;
    setState(() {
      points.removeLast();
      for (int i = points.length - 1; i >= 0; i--) {
        if (points.isEmpty || points[i] == null) break;
        points.removeLast();
      }
    });
  }

  void onNextButtonClicked() {
    setState(() {
      isIgnoreTouch = false;
      isNextButtonClicked = true;
    });
  }

  void onDrawEditButtonClicked() {
    setState(() {
      setAllRoughyGestureTextWidgetChangToNotSelected();
      switchToDrawingEditPanelPanel();
    });
  }

  void onResizeButtonClicked() {
    selectedRoughyGestureText = null;
    setState(() {
      swapStackChildren();
    });
  }

  void onTextEditButtonClicked() async {
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
      final RoughyGestureText target = RoughyGestureText(
          roughyGestureTextController: RoughyGestureTextController(),
          onWidgetSelected: onRoughyTextWidgetSelected,
          onWidgetReleased: onRoughyTextWidgetReleased,
          onTapRoughyGestureTextRemove: onTapRoughyGestureTextRemove,
          key: UniqueKey(),
          text: result,
          fontName: selectedTextRoughyFont,
          fontColor: selectedDrawingColor,
          isWidgetSelected: true);
      gestureTextList.add(target);
      selectedRoughyGestureText = target;
      for (final widget in gestureTextList) {
        print("@@@@!@#$widget :: $target");
        widget.roughyGestureTextController.setWidgetSelected(widget == target);
      }
    });
  }

  void onRoughyTextWidgetSelected(RoughyGestureText target) {
    print("onRoughyTextWidgetSelected");
    selectedRoughyGestureText = target;
    for (final widget in gestureTextList) {
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
      selectedRoughyGestureText!.roughyGestureTextController
          .setFont(selectedFontName);
    }
  }

  void onSelectDrawingColor(ui.Color selectedDrawingColor, int index) {
    print(
        "색상 선택 : " + selectedDrawingColor.toString() + " " + index.toString());
    setState(() {
      this.selectedDrawingColor = selectedDrawingColor;
    });
    if (selectedRoughyGestureText != null && isTextEditPanelVisible) {
      selectedRoughyGestureText!.roughyGestureTextController
          .setFontColor(selectedDrawingColor);
    }
  }

  void onSelectDrawingDepth(double selectedDrawingLineDepth, int index) {
    print("두께 선택 : " +
        selectedDrawingLineDepth.toString() +
        " " +
        index.toString());
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
                onTap: () {
                  onSelectDrawingColor(drawingColors[i], i);
                },
                child: selectedDrawingColor == drawingColors[i]
                    ? Center(
                        child: Container(
                            child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14.0,
                      )))
                    : null,
              )),
            ),
          ),
        ),
      );
    }
    return RoughyBottomAppbar(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, children: list));
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
            decoration: const BoxDecoration(color: Colors.white),
            child: Center(
                child: OutlineCircleButton(
              radius: 25,
              onTap: () {
                onSelectDrawingDepth(drawingLineDepths[i], i);
              },
              child: Padding(
                padding: const EdgeInsets.all(.0),
                child: SvgPicture.asset(
                  'assets/images/logo_depth${i + 1}.svg',
                  color: selectedDrawingLineDepth == drawingLineDepths[i]
                      ? Colors.black
                      : Colors.black12,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            )),
          ),
        ),
      ));
    }
    return RoughyBottomAppbar(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: list),
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
                    color: selectedTextRoughyFont == textFontList[i]
                        ? Colors.black
                        : Colors.grey),
              ))),
        ),
      );
    }

    return RoughyBottomAppbar(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: list),
    ));
  }

  Widget getCanvas(double templateWidth, double templateHeight) {
    return RepaintBoundary(
      key: captureKey,
      child: SizedBox(
        width: templateWidth,
        height: templateHeight,
        child: Stack(children: [
          croppedImageInteractiveViewer(
              templateWidth,
              templateHeight,
              _templateImage.width.toDouble(),
              _templateImage.height.toDouble()),
          IgnorePointer(
            ignoring: isIgnoreTouch,
            child: roughyCustomPaint(),
          )
        ]),
      ),
    );
  }

  CustomPaint roughyCustomPaint() {
    return CustomPaint(
      painter: RoughyBackgroundPainter(
          //croppedImage: _croppedImage,
          templateImage: _templateImage,
          points: points,
          drawingColor: selectedDrawingColor,
          drawingDepth: selectedDrawingLineDepth),
      child: Stack(
        children: [
          for (var widget in gestureTextList) widget,
          //Image.asset(widget.templateImage.path)
        ],
      ),
/*                                          foregroundPainter: RoughyForegroundPainter(
                                                points: points,
                                                drawingColor: selectedDrawingColor,
                                                drawingDepth: selectedDrawingLineDepth),*/
    );
  }

  void swapStackChildren() {
    print("swap");
    isInteractiveViewerFront = !isInteractiveViewerFront;
  }

  Widget croppedImageInteractiveViewer(
      double width, double height, double twidth, double theight) {
    return InteractiveViewer(
        constrained: false,
        panEnabled: true,
        scaleEnabled: true,
        maxScale: 10.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width, maxHeight: height),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(1.0), BlendMode.dstATop),
                      image: FileImage(widget.croppedImage)))),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    final templateHeight = (itemHeight - 150) * 0.7;
    final templateWidth = isImageLoaded
        ? templateHeight *
            _templateImage.width.toDouble() /
            _templateImage.height.toDouble()
        : 0.0;
    /*print("itemHeight : $itemHeight, itemWidth : $itemWidth");
    print("templateHeight : $templateHeight, templateWidth : $templateWidth");*/

    void updateDrawingPosition(ui.Offset localOffset) {
      print("@@@${localOffset.toString()}");
      if (isDrawingPanelVisible) {
        setState(() {
          if (isInsideOffset(localOffset, templateWidth, templateHeight)) {
            setState(() {
              points.add(RoughyDrawingPoint(
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
      RenderRepaintBoundary boundary = captureKey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.5);
      ByteData byteData =
          (await image.toByteData(format: ui.ImageByteFormat.png))!;
      Uint8List pngBytes = byteData.buffer.asUint8List();

      String dir = (await getApplicationSupportDirectory()).path;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
      String fullPath = '$dir/roughy_$formattedDate.png';
      File file = File(fullPath);
      log(fullPath);

/*      DateTime now = DateTime.now();
      String dir = (await getApplicationSupportDirectory()).path;
      String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
      screenshotController.captureAndSave(dir, //set path where screenshot will be saved
          fileName: 'roughy_$formattedDate.png');*/

      await file.writeAsBytes(pngBytes);
    }

    Stack buildMainStack(double templateWidth, double templateHeight) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.transparent),
          ),
          FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: isImageLoaded
                ? Padding(
                    padding: const EdgeInsets.all(35),
                    child: isDrawingPanelVisible
                        ? GestureDetector(
                            onPanStart: (details) =>
                                updateDrawingPosition(details.localPosition),
                            onPanUpdate: (details) =>
                                updateDrawingPosition(details.localPosition),
                            onPanEnd: (details) => initializeDrawingPosition(),
                            child: getCanvas(templateWidth, templateHeight))
                        : getCanvas(templateWidth, templateHeight))
                : const Padding(
                    padding: EdgeInsets.all(100),
                    child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      appBar: RoughyAppBar(
        titleText: titleText,
        isCenterTitle: true,
        iconWidget: IconButton(
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
                  title: const Text('알림'),
                  content: const Text('사진을 사진첩에 저장하시겠습니까?'),
                  actions: <Widget>[
                    PlatformDialogAction(
                        onPressed: () async {
                          await _capturePng();
                          if (!mounted) return;
                          Navigator.pop(context);
                          showPlatformDialog(
                              context: context,
                              builder: (_) => PlatformAlertDialog(
                                      title: const Text('알림'),
                                      content: const Text('저장완료!'),
                                      actions: <Widget>[
                                        PlatformDialogAction(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context, true);
                                            },
                                            child: PlatformText('Okay'))
                                      ]));
                        },
                        child: PlatformText('Yes')),
                    PlatformDialogAction(
                      onPressed: () => Navigator.pop(context),
                      child: PlatformText('No'),
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
          decoration: const BoxDecoration(
            color: Color.fromRGBO(249, 249, 249, 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: isTextEditPanelVisible
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: setAllRoughyGestureTextWidgetChangToNotSelected,
                        child: buildMainStack(templateWidth, templateHeight),
                      )
                    : buildMainStack(templateWidth, templateHeight),
              ),
              if (isTextEditPanelVisible) getColorPanelWidgets() else Row(),
              if (isTextEditPanelVisible) getTextPanelWidgets() else Row(),
              if (isDrawingPanelVisible) getColorPanelWidgets() else Row(),
              if (isDrawingPanelVisible)
                getDrawingLineDepthPanelWidgets()
              else
                Row(),
              /*   if (isNextButtonClicked)
                buildRoughyBottomAppbar()
              else
                buildRoughyBottomResizeAppbar(),*/
            ],
          )),
      bottomNavigationBar: isNextButtonClicked
          ? buildRoughyBottomAppbar()
          : buildRoughyBottomResizeAppbar(),
    );
  }

  RoughyBottomAppbar buildRoughyBottomResizeAppbar() {
    return RoughyBottomAppbar(
        child: Row(children: <Widget>[
      const Expanded(child: SizedBox()),
      OutlineRoundButton(
          radius: 15.0,
          onTap: () => onNextButtonClicked(),
          child: const Center(
              child: Text(
            "다음",
            style: TextStyle(color: Colors.black, fontSize: 16),
          )))
    ]));
  }

  RoughyBottomAppbar buildRoughyBottomAppbar() {
    return RoughyBottomAppbar(
      child: Row(children: <Widget>[
        OutlineCircleButton(
            radius: 45.0,
            onTap: () => onTextEditButtonClicked(),
            child: Center(
                child: SvgPicture.asset('assets/icons/text.svg',
                    width: 24,
                    height: 24,
                    color: isTextEditPanelVisible
                        ? selectedIconColor
                        : unselectedIconColor))),
        OutlineCircleButton(
            radius: 45.0,
            onTap: () => onDrawEditButtonClicked(),
            child: Center(
                child: SvgPicture.asset('assets/icons/roughy_option.svg',
                    width: 28,
                    height: 24,
                    color: isDrawingPanelVisible
                        ? selectedIconColor
                        : unselectedIconColor))),
        const Expanded(child: SizedBox()),
        if (isDrawingPanelVisible)
          OutlineRoundButton(
              radius: 15.0,
              foregroundColor: Colors.white,
              onTap: () => onDrawingRollbackButtonClicked(),
              child: const Center(
                  child: Text(
                "되돌리기",
                style: TextStyle(color: Colors.black, fontSize: 16),
              )))
        else
          Container()
      ]),
    );
  }
}
