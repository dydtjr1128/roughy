import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ImageViewPage extends StatelessWidget {
  ImageViewPage({Key key, this.path}) : super(key: key);
  final String path;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        backgroundColor: Colors.red,
        appBar: PlatformAppBar(
          title: Text('이미지 보기'),
        ),
        body: Center(
          child: Image.asset(path),
        ));
  }
}
