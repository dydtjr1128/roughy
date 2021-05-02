import 'dart:io';

import 'package:Roughy/page/decorating/ImageViewPage.dart';
import 'package:Roughy/page/decorating/SelectedImageViewPage.dart';
import 'package:Roughy/tab/secondTab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class FirstTabPage extends StatelessWidget {
  //페이지는 무조건 statelessWidget 으로 만들어져야함
  FirstTabPage(this.toggleBrightness);

  final void Function() toggleBrightness;

  @override
  Widget build(BuildContext context) {
    return FirstPageWidget(title: '진짜 타이틀', toggleBrightness: toggleBrightness);
  }
}

class FirstPageWidget extends StatefulWidget {
  FirstPageWidget({required this.title, required this.toggleBrightness});
  final String title;
  final void Function() toggleBrightness;
  int titleValue = 100;

  @override
  _FirstPageWidgetState createState() => _FirstPageWidgetState();
}

class _FirstPageWidgetState extends State<FirstPageWidget> {
  final Brightness brightness = Brightness.light;
  int _counter = 0;
  bool isSelectedDarkTheme = false;

  void _changePage(context) {
    print("call _changePage()");
    //Navigator.pushNamed(context, "/second");

    Navigator.push(
        context,
        platformPageRoute(
            context: context,
            builder: (context) {
              return SecondTabPage();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Floating action 버튼을 클릭해 보세요',
            ),
            Text(
              '$_counter 번 눌렸어요',
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                PlatformButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    // Column is also a layout widget. It takes a list of children and
                    print("add");
                    setState(() {
                      ++_counter;
                      widget.titleValue = _counter;
                    });
                  },
                ),
                PlatformButton(
                    // 기본 위젯 이동 애니메이션에서 hero 태그로 구분, 같은 위젯이 있는경우 hero 태그가 다르게 존재해야하는데 미 선언시 동일 태그로 오류 발생
                    child: Icon(Icons.remove),
                    onPressed: () => {
                          print("minus"),
                          setState(() {
                            --_counter;
                            widget.titleValue = _counter;
                          })
                        }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlatformButton(
                  child: PlatformText('테마 변경'),
                  onPressed: () => {
                    if (isMaterial(context))
                      {PlatformProvider.of(context)!.changeToCupertinoPlatform()}
                    else
                      {PlatformProvider.of(context)!.changeToMaterialPlatform()}
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlatformButton(
                    child: Text("페이지 이동"),
                    onPressed: () => {
                          _changePage(context),
                        })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlatformButton(
                    child: Text("테스트"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          platformPageRoute(
                              context: context,
                              builder: (context) {
                                return SelectedImageViewPage(croppedImage: File("assets/images/test.jpg"), templateImage: File("assets/templates/base.png"));
                              }));
                    })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlatformButton(
                    child: Text("라이선스"),
                    onPressed: () {
                      showLicensePage(
                        context: context
                      );
                    })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlatformButton(
                    child: Text("이미지 확인"),
                    onPressed: () => {
                          Navigator.push(
                              context,
                              platformPageRoute(
                                  context: context,
                                  builder: (context) {
                                    return ImageViewPage(
                                        path: "assets/templates/base.png");
                                  }))
                        })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlatformSwitch(
                  onChanged: (isOpen) {
                    setState(() {
                      isSelectedDarkTheme = isOpen;
                    });
                    widget.toggleBrightness();
                  },
                  value: isSelectedDarkTheme,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
