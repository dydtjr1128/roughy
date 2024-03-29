import 'package:flutter/material.dart';

class RoughyAppBar extends StatefulWidget with PreferredSizeWidget {
  final double appBarHeight = 60.0;
  final String titleText;
  final String tooltipText;
  final Widget? iconWidget;
  final bool isCenterTitle;

  RoughyAppBar(
      {this.titleText = "ROUGHY",
      this.tooltipText = "",
      this.iconWidget,
      this.isCenterTitle = false});

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  _RoughyAppBarState createState() => _RoughyAppBarState();
}

class _RoughyAppBarState extends State<RoughyAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(widget.appBarHeight),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AppBar(
            automaticallyImplyLeading: true,
            elevation: 1,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            toolbarHeight: widget.appBarHeight,
            title: Text(widget.titleText,
                style: const TextStyle(
                    fontFamily: 'SimplicityRegular', fontSize: 37, color: Colors.black)),
            backgroundColor: Colors.white,
            centerTitle: widget.isCenterTitle,
            actions: widget.iconWidget == null ? null : <Widget>[widget.iconWidget!],
          ),
        ]));
  }
}
