import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:Roughy/component/OutlineCircleButton.dart';
import 'package:Roughy/component/roughyAppBar.dart';
import 'package:Roughy/page/decorating/SelectedImageViewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageViewPage extends StatefulWidget {
  final String path;

  ImageViewPage({required this.path});

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  void onClickDecorationButton(BuildContext context) {
    print("클릭~");
    _showPicker(context);
  }

  final ImagePicker imagePicker = ImagePicker();

  _getImage({@required source}) async {
    final pickedFile = await imagePicker.getImage(source: source, imageQuality: 100);
    if (pickedFile != null) {
      // 템플릿 이미지 가로 세로 길이 구하는 부분
      final Image templateImage = Image(image: AssetImage(widget.path));
      Completer<ui.Image> completer = new Completer<ui.Image>();
      templateImage.image
          .resolve(new ImageConfiguration())
          .addListener(new ImageStreamListener((ImageInfo image, bool _) {
        completer.complete(image.image);
      }));
      ui.Image info = await completer.future;
      int width = info.width;
      int height = info.height;

      // 템플릿 이미지 가로 세로 사이즈에 맞게 자르도록 크롭
      File croppedImage = (await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(
            ratioX: width.toDouble(), ratioY: height.toDouble()),
        compressQuality: 100,
        //maxHeight: 700,
        //maxWidth: 700,
        compressFormat: ImageCompressFormat.png,
      ))!;

      await Navigator.push(
          context,
          platformPageRoute(
              builder: (_) {
                return SelectedImageViewPage(
                    croppedImage: croppedImage, templateImage: File(widget.path));
              },
              context: context));
      Navigator.of(context).pop();
    } else {
      print('No image selected.');
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('앨범'),
                      onTap: () {
                        _getImage(source: ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('카메라'),
                    onTap: () {
                      _getImage(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 0.65;
    final double itemWidth = size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        appBar: RoughyAppBar(
          titleText: "Template",
          isCenterTitle: true,
        ),
        body: Center(
            child: Container(
                height: itemHeight,
                width: itemWidth,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Center(child: Image.asset(widget.path, fit: BoxFit.fitHeight)),
                  ],
                ))),
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                OutlineCircleButton(
                    radius: 50.0,
                    foregroundColor: Colors.black,
                    onTap: () => onClickDecorationButton(context),
                    child: Center(
                        child: Text(
                      "꾸미기",
                      style: TextStyle(color: Colors.white),
                    )))
              ],
            ),
          ),
        ));
  }
}
