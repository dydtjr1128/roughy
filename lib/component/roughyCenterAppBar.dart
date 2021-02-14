import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class RoughyCenterAppBar extends StatefulWidget with PreferredSizeWidget {
  final double appBarHeight = 50.0;
  final String title;

  RoughyCenterAppBar({@required this.title});

  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  @override
  _RoughyCenterAppBarState createState() =>
      _RoughyCenterAppBarState(appBarHeight);
}

class _RoughyCenterAppBarState extends State<RoughyCenterAppBar> {
  final double _appBarHeight;

  _RoughyCenterAppBarState(this._appBarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(_appBarHeight),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AppBar(
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            toolbarHeight: _appBarHeight,
            title: PlatformText(widget.title,
                style: TextStyle(
                    fontFamily: 'Simplicity-Regular',
                    fontSize: 30,
                    color: Colors.black)),
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
        ]));
  }
}
