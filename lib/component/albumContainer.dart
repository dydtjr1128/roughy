import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AlbumContainer extends StatefulWidget {
  final Function onTap;
  final int containerIndex;
  final BorderRadius _baseBorderRadius = BorderRadius.circular(8);
  final String path;

  AlbumContainer(
      {@required this.onTap,
      @required this.containerIndex,
      @required this.path});

  @override
  _AlbumContainerState createState() => _AlbumContainerState();
}

class _AlbumContainerState extends State<AlbumContainer> {
  Future<File> _getLocalFile() async {
    File f = new File(widget.path);
    return f;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Color.fromRGBO(235, 235, 235, 1),
      shape: RoundedRectangleBorder(borderRadius: widget._baseBorderRadius),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: InkWell(
          borderRadius: widget._baseBorderRadius,
          onTap: () =>
              widget.onTap(widget.containerIndex, widget.path, context),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: widget._baseBorderRadius,
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: ClipOval(
                              child: Container(
                                width: 20,
                                height: 20,
                                color: Colors.black,
                                child: Center(
                                  child: PlatformText(
                                      widget.containerIndex.toString(),
                                      style: TextStyle(
                                          fontFamily: 'SimplicityRegular',
                                          fontSize: 15,
                                          color: Colors.white)),
                                ),
                              )),
                        ),
                        Icon(context.platformIcons.bookmark)
                      ]),
                  Row(
                    children: [
                      ClipRRect(
                          child: Center(
                        child: Container(
                          child: new FutureBuilder(
                              future: _getLocalFile(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<File> snapshot) {
                                return snapshot.data != null
                                    ? new Image.file(snapshot.data,
                                        fit: BoxFit.contain)
                                    : new Container();
                              }),
                          height: MediaQuery.of(context).size.height,
                          margin: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 0.0),
                        ),
                      ))
                    ],
                  )
                ],
              ))),
    );
  }
}
