import 'package:Roughy/tab/MyAlbumWidget.dart';
import 'package:Roughy/tab/firstTab.dart';
import 'package:Roughy/tab/templateSelectTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class MainTabbedPage extends StatefulWidget {
  MainTabbedPage(this.toggleBrightness);

  final void Function() toggleBrightness;

  @override
  _MainTabbedPageState createState() => _MainTabbedPageState();
}

class _MainTabbedPageState extends State<MainTabbedPage> {
  static final titles = ['템플릿', '앨범', '설정'];
  final items = (BuildContext context) => [
        BottomNavigationBarItem(
          label: titles[0],
          icon: Icon(context.platformIcons.flag),
        ),
        BottomNavigationBarItem(
          label: titles[1],
          icon: Icon(context.platformIcons.book),
        ),
        BottomNavigationBarItem(
          label: titles[2],
          icon: Icon(context.platformIcons.settings),
        ),
      ];

  // This needs to be captured here in a stateful widget
  PlatformTabController tabController = PlatformTabController(
    initialIndex: 1,
  );

  @override
  void initState() {
    super.initState();
  }

  Widget bottomAppBar() {
    return Container(
      color: Colors.white,
      child: Container(
        height: 70,
        padding: EdgeInsets.only(bottom: 10, top: 5),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.red,
          indicatorWeight: 2,
          labelColor: Colors.blueAccent,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontFamily: 'Yanolja'),
          tabs: [
            Tab(
              icon: Icon(context.platformIcons.flag),
              text: titles[0],
            ),
            Tab(
              icon: Icon(context.platformIcons.book),
              text: titles[1],
            ),
            Tab(
              icon: Icon(context.platformIcons.settings),
              text: titles[2],
            )
          ],
        ),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Tab demo"),
        ),
        bottomNavigationBar: bottomAppBar(),
        body: TabBarView(
          children: <Widget>[
            TemplateSelectWidget(),
            MyAlbumWidget(),
            FirstTabPage(widget.toggleBrightness),
          ],
        ),
      ),
    );
  }*/

/*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoughyCenterAppBar(title: "rrr",),
      bottomNavigationBar: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: TabBarView(
              children: [
                TemplateSelectWidget(),
                MyAlbumWidget(),
                FirstTabPage(widget.toggleBrightness),
              ],
            ),
            bottomNavigationBar: bottomAppBar(),
          )),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
      pageBackgroundColor: Colors.white,
      tabController: tabController,
      bodyBuilder: ((context, index) {
        print(index);
        switch (index) {
          case 0:
            return TemplateSelectWidget();
          case 1:
            return MyAlbumWidget();
          default:
            return FirstTabPage(widget.toggleBrightness);
        }
      }),
      items: items(context),
    );
  }
}
