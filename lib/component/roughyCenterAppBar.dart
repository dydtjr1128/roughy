import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class RoughyCenterAppBar extends StatefulWidget with PreferredSizeWidget {
  final double appBarHeight = 50.0;
  final String title;
  final IconButton? iconButton;
  final bool isCenterTitle;

  RoughyCenterAppBar({required this.title, this.iconButton, this.isCenterTitle = false});

  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  @override
  _RoughyCenterAppBarState createState() => _RoughyCenterAppBarState();
}

class _RoughyCenterAppBarState extends State<RoughyCenterAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(widget.appBarHeight),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AppBar(
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            toolbarHeight: widget.appBarHeight,
            title: PlatformText(widget.title,
                style:
                    TextStyle(fontFamily: 'SimplicityRegular', fontSize: 35, color: Colors.black)),
            backgroundColor: Colors.white,
            centerTitle: widget.isCenterTitle,
            actions: [widget.iconButton!],
          ),
        ]));
  }
}
