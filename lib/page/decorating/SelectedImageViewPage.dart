import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:Roughy/component/OutlineCircleButton.dart';
import 'package:Roughy/component/OutlineRoundButton.dart';
import 'package:Roughy/component/paintor/RoughyBackgroundPainter.dart';
import 'package:Roughy/component/roughyCenterAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectedImageViewPage extends StatefulWidget {
  final File templateImage, croppedImage;

  SelectedImageViewPage(
      {@required this.croppedImage, @required this.templateImage});

  @override
  _SelectedImageViewPageState createState() => _SelectedImageViewPageState();
}

class _SelectedImageViewPageState extends State<SelectedImageViewPage> {
  File changedImage;
  ui.Image _templateImage, _croppedImage;
  bool isDrawingPanelVisible;
  bool isTextEditPanelVisible;
  final List<ui.Color> drawingColors = [];
  final List<int> drawingLineDepths = [];

  _SelectedImageViewPageState() {
    this.isDrawingPanelVisible = true;
    this.isTextEditPanelVisible = false;
    this.drawingColors..add(Color.fromRGBO(255, 255, 255, 1))..add(
        Color.fromRGBO(126, 126, 126, 1))..add(Color.fromRGBO(0, 0, 0, 1))..add(
        Color.fromRGBO(229, 36, 36, 1))..add(
        Color.fromRGBO(255, 169, 36, 1))..add(
        Color.fromRGBO(12, 178, 101, 1))..add(Color.fromRGBO(0, 26, 197, 1));
    drawingLineDepths..add(1)..add(3)..add(5)..add(7)..add(9);
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

  Widget getDrawingPanelWidgets() {
    List<Widget> list = [];
    for (var myColor in drawingColors) {
      list.add(ClipOval(
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              color: myColor,
              shape: BoxShape.circle,
            ),
            child: Material(
            color: Colors.transparent,
            child: InkWell(
                child: SizedBox(),
                onTap: () async {
/*                  if(onTap != null) {
                    onTap();
                  }*/
                }
            ),
          )
      )));
    }
    return Row(
    children: [
    Container(
    height: 50,
    decoration: new BoxDecoration(
    color: Colors.white,
    border:
    Border.all(color: Color.fromRGBO(9, 9, 9, 1), width: 1)),
    child: Row(children: list))
    ]
    ,
    );
  }

  Widget getDrawingLineDepthPanelWidgets() {
    List<Widget> list = [];
    for (var myColor in drawingLineDepths) {
      list.add(ClipOval(
          child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                color: Colors.black,
                shape: BoxShape.circle,
              ))));
    }
    return Row(
      children: [
        Container(
            height: 50,
            decoration: new BoxDecoration(
                color: Colors.white,
                border:
                Border.all(color: Color.fromRGBO(9, 9, 9, 1), width: 1)),
            child: Row(children: list))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(235, 235, 235, 1),
        appBar: RoughyCenterAppBar(
          title: "template",
        ),
        body: Container(
            width: itemWidth,
            height: itemHeight,
            decoration: new BoxDecoration(
              color: Colors.red,
              border: Border.all(width: 1),
            ),
            child: Column(
              children: [
                Expanded(
                    child: Row(
                      children: [
                        widget.croppedImage == null ||
                            widget.templateImage == null
                            ? Text('No image selected.')
                            : Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1),
                            ),
                            child: CustomPaint(
                                size: Size(_templateImage.width.toDouble(),
                                    _templateImage.height.toDouble()),
                                painter: RoughyBackgroundPainter(
                                    croppedImage: _croppedImage,
                                    templateImage: _templateImage)))
                      ],
                    )),
                isDrawingPanelVisible
                    ? getDrawingPanelWidgets()
                    : new Container(),
                isDrawingPanelVisible
                    ? getDrawingLineDepthPanelWidgets()
                    : new Container(),
                Row(
                  children: [
                    Container(
                        width: itemWidth,
                        height: 50.0,
                        decoration: new BoxDecoration(color: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
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
                                                color: Colors.white,
                                                fontSize: 30),
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
                                        mainAxisAlignment: MainAxisAlignment
                                            .end,
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
                                                    style:
                                                    TextStyle(
                                                        color: Colors.white),
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
