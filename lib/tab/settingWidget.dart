import 'package:Roughy/component/roughyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class SettingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RoughyAppBar(
          titleText: "SETTING",
        ),
        body: ListView(children: <Widget>[
          ListTile(
            leading: Icon(Icons.map),
            title: Text('약관 및 정책'),
          ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('라이선스'),
            onTap: () {
              showAboutDialog(
                  context: context,
                  applicationIcon:
                      SvgPicture.asset('assets/images/logo.svg', height: 100, width: 100),
                  applicationName: "Roughy",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "Developed by dydtjr1128",
                  children: <Widget>[
                    Text(
                        "This is an application that helps you look like you're photographed with a polaroid camera.")
                  ]);
            },
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('공식 인스타그램'),
          )
        ]));
  }
}
