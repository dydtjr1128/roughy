import 'package:Roughy/component/roughyCenterAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageViewPage extends StatelessWidget {
  ImageViewPage({Key key, this.path}) : super(key: key);
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        appBar: RoughyCenterAppBar(
          title: "template",
        ),
        body: Center(
          child: Image.asset(path),
        ));
  }
}
