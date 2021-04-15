import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AlbumContainer extends StatefulWidget {
  final Function onTap;
  final int containerIndex;
  final BorderRadius _baseBorderRadius = BorderRadius.circular(38);
  final String path;

  AlbumContainer({@required this.onTap, @required this.containerIndex, @required this.path});

  @override
  _AlbumContainerState createState() => _AlbumContainerState();
}

class _AlbumContainerState extends State<AlbumContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        //padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 25.0),
        margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 25.0),
        decoration: BoxDecoration(
          borderRadius: widget._baseBorderRadius,
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    ClipOval(
                        child: Container(
                      width: 20,
                      height: 20,
                      color: Colors.black,
                      child: Center(
                        child: PlatformText((widget.containerIndex + 1).toString(),
                            style: TextStyle(
                                fontFamily: 'SimplicityRegular',
                                fontSize: 15,
                                color: Colors.white)),
                      ),
                    )),
                    Icon(context.platformIcons.bookmark)
                  ]),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: new BoxDecoration(
                            image:
                                DecorationImage(fit: BoxFit.cover, image: FileImage(File(widget.path))),
                          ),
                      )
                  )
                ],
              ),
            ),
            new Positioned.fill(
                child: new Material(
                    color: Colors.transparent,
                    child: new InkWell(
                      //splashColor: Colors.lightGreenAccent,
                      onTap: () => widget.onTap(widget.containerIndex, widget.path, context),
                    ))),
          ],
        ));
  }
}
