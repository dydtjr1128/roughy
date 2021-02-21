import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';

class RoughyDownloadAppBar extends StatefulWidget with PreferredSizeWidget {
  final double appBarHeight = 60.0;
  final Function() onClickedCallback;

  RoughyDownloadAppBar({@required this.onClickedCallback});

  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  @override
  _RoughyDownloadAppBarState createState() =>
      _RoughyDownloadAppBarState(appBarHeight);
}

class _RoughyDownloadAppBarState extends State<RoughyDownloadAppBar> {
  final double _appBarHeight;

  _RoughyDownloadAppBarState(this._appBarHeight);

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
            title: PlatformText("ROUGHY",
                style: TextStyle(
                    fontFamily: 'SimplicityRegular',
                    fontSize: 37,
                    color: Colors.black)),
            backgroundColor: Colors.white,
            centerTitle: true,
            actions: <Widget>[
              new IconButton(
                icon: SvgPicture.asset('assets/images/download.svg',
                    color: Colors.black, height: 25, width: 25),
                tooltip: "download",
                onPressed: () {
                  setState(() {
                    widget.onClickedCallback();
                  });
                },
                color: Colors.red,
              )
            ],
          ),
        ]));
  }
}
