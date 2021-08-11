import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AlbumContainer extends StatefulWidget {
  final Function onTap;
  final int containerIndex;
  final BorderRadius _baseBorderRadius = BorderRadius.circular(38);
  final String path;

  AlbumContainer({required this.onTap, required this.containerIndex, required this.path});

  @override
  _AlbumContainerState createState() => _AlbumContainerState();
}

class _AlbumContainerState extends State<AlbumContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        //padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 25.0),
        margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 25.0),
        decoration: BoxDecoration(
          borderRadius: widget._baseBorderRadius,
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipOval(
                      child: Container(
                    width: 20,
                    height: 20,
                    color: Colors.black,
                    child: Center(
                      child: Text((widget.containerIndex + 1).toString(),
                          style: const TextStyle(
                              fontFamily: 'SimplicityRegular', fontSize: 15, color: Colors.white)),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.scaleDown, image: FileImage(File(widget.path))),
                    ),
                  ))
                ],
              ),
            ),
            Positioned.fill(
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      //splashColor: Colors.lightGreenAccent,
                      onTap: () => widget.onTap(widget.containerIndex, widget.path, context),
                    ))),
          ],
        ));
  }
}
