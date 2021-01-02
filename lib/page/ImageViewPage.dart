import 'dart:io';

import 'package:Roughy/component/OutlineCircleButton.dart';
import 'package:Roughy/component/roughyCenterAppBar.dart';
import 'package:Roughy/page/SelectedImageViewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';

class ImageViewPage extends StatefulWidget {
  final String path;

  ImageViewPage({Key key, this.path}) : super(key: key);

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  void onClickDecorationButton(BuildContext context) {
    print("클릭~");
    _showPicker(context);
  }

  File _image;
  final ImagePicker imagePicker = ImagePicker();

  _getImage({@required source}) async {
    final pickedFile =
        await imagePicker.getImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      Navigator.push(
          context,
          platformPageRoute(
              builder: (_) {
                return SelectedImageViewPage(image: _image);
              },
              context: context));
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
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getImage(source: ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
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
        backgroundColor: Color.fromRGBO(235, 235, 235, 1),
        appBar: RoughyCenterAppBar(
          title: "template",
        ),
        body: Center(
            child: Container(
          height: itemHeight,
          width: itemWidth,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Image.asset(widget.path, fit: BoxFit.fitHeight),
        )),
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
