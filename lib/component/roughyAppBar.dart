import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class RoughyAppBar extends StatelessWidget with PreferredSizeWidget {
  final double appBarHeight = 60.0;

  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AppBar(
            toolbarHeight: appBarHeight,
            title: PlatformText("ROUGHY",
                style: TextStyle(
                    fontFamily: 'Macadamia',
                    fontSize: 37,
                    color: Colors.black)),
            backgroundColor: Colors.white,
            centerTitle: false,
            actions: <Widget>[
              new IconButton(
                icon: Icon(
                  context.platformIcons.favoriteOutline,
                ),
                tooltip: "favorite",
                onPressed: () => {},
                color: Colors.red,
              )
            ],
          ),
        ]));
  }
}
