import 'package:Roughy/component/roughy_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingWidget extends StatelessWidget {
  Future<void> launchBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RoughyAppBar(
          titleText: "SETTING",
        ),
        body: ListView(children: <Widget>[
          const ListTile(
            title: Text('약관 및 정책'),
          ),
          ListTile(
            title: const Text('오픈 소스 라이센스'),
            onTap: () {
              showAboutDialog(
                  context: context,
                  applicationIcon:
                      SvgPicture.asset('assets/images/logo.svg', height: 100, width: 100),
                  applicationName: "Roughy",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "Developed by dydtjr1128",
                  children: <Widget>[
                    const Text(
                        "This is an application that helps you look like you're photographed with a polaroid camera.")
                  ]);
            },
          ),
          ListTile(
              title: const Text('프레임 제안하기'),
              onTap: () => launchBrowser(
                  "https://docs.google.com/forms/d/1dYwS5T_-CsumfTOQjWvrKBPiHH-5lDgWkps9OKoc_tg/edit?usp=sharing")),
          ListTile(
              title: const Text('공식 인스타그램'),
              onTap: () => launchBrowser("https://www.instagram.com/vanila_people/"))
        ]));
  }
}
