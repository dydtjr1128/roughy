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
    ByteData data = await rootBundle.load(widget.templateImage.path);

    final templateImage = await loadImage(Uint8List.view(data.buffer));
    // croppedImage 와 같이 빌드시 만든 이미지가 아닌 경우 바이트 읽어와서 따로 처리해야함
    final croppedImage = await loadImage(widget.croppedImage.readAsBytesSync());

    setState(() {
      _templateImage = templateImage;
      _croppedImage = croppedImage;
    });
  }

  onImageSettingButtonClicked(BuildContext context) {
    Navigator.pop(context, changedImage);
  }

  onDrawEditButtonClicked(BuildContext context) {}

  onTextEditButtonClicked(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(235, 235, 235, 1),
        appBar: RoughyCenterAppBar(
          title: "template",
        ),
        body: Column(
          children: [
            Expanded(
                child: Row(
              children: [
                widget.croppedImage == null || widget.templateImage == null
                    ? Text('No image selected.')
                    : Container(
                        decoration: new BoxDecoration(color: Colors.white),
                        child: CustomPaint(
                            size: Size(_templateImage.width.toDouble(),
                                _templateImage.height.toDouble()),
                            painter: RoughyBackgroundPainter(
                                croppedImage: _croppedImage,
                                templateImage: _templateImage)))
              ],
            )),
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
                                  onTap: () => onTextEditButtonClicked(context),
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
                                  onTap: () => onDrawEditButtonClicked(context),
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
                                          onImageSettingButtonClicked(context),
                                      child: Center(
                                          child: Text(
                                        "되돌리기",
                                        style: TextStyle(color: Colors.white),
                                      )))
                                ],
                              )
                            ])),
                      ]),
                    ))
              ],
            )
          ],
        ));
/*                child: widget.image == null
                    ? Text('No image selected.')
                    : Image.file(widget.image))),*/
  }
}
