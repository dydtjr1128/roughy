import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class RoughyAppBar extends StatefulWidget with PreferredSizeWidget {
  final double appBarHeight = 60.0;
  final Function(bool) onClickedCallback;

  RoughyAppBar({@required this.onClickedCallback});

  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  @override
  _RoughyAppBarState createState() => _RoughyAppBarState(appBarHeight);
}

class _RoughyAppBarState extends State<RoughyAppBar> {
  bool _isFavoriteSelected = false;
  final double _appBarHeight;

  _RoughyAppBarState(this._appBarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(_appBarHeight),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AppBar(
            toolbarHeight: _appBarHeight,
            title: PlatformText("ROUGHY",
                style: TextStyle(
                    fontFamily: 'Simplicity-Regular',
                    fontSize: 37,
                    color: Colors.black)),
            backgroundColor: Colors.white,
            centerTitle: false,
            actions: <Widget>[
              new IconButton(
                icon: _isFavoriteSelected
                    ? Icon(context.platformIcons.favoriteSolid)
                    : Icon(context.platformIcons.favoriteOutline),
                tooltip: "favorite",
                onPressed: () {
                  setState(() {
                    _isFavoriteSelected = !_isFavoriteSelected;
                    print(_isFavoriteSelected);
                    widget.onClickedCallback(_isFavoriteSelected);
                  });
                },
                color: Colors.red,
              )
            ],
          ),
        ]));
  }
}
