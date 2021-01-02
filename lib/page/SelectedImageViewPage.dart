
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectedImageViewPage extends StatefulWidget {
  final File image;
  SelectedImageViewPage({@required this.image});

  @override
  _SelectedImageViewPageState createState() => _SelectedImageViewPageState();
}

class _SelectedImageViewPageState extends State<SelectedImageViewPage> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
