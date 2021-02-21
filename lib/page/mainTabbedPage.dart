import 'package:Roughy/tab/MyAlbumWidget.dart';
import 'package:Roughy/tab/firstTab.dart';
import 'package:Roughy/tab/templateSelectTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'file:///F:/dev/Mobile/roughy/lib/example/DynamicTabbedPage.dart';

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
  PlatformTabController tabController;

  @override
  void initState() {
    super.initState();

    // If you want further control of the tabs have one of these
    if (tabController == null) {
      tabController = PlatformTabController(
        initialIndex: 1,
      );
    }
  }

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
            break;
          case 1:
            return MyAlbumWidget();
            break;
          case 2:
            return FirstTabPage(widget.toggleBrightness);
            break;
        }
        return null;
      }),
      items: items(context),
      /*cupertino: (_, __) => CupertinoTabScaffoldData(
        //   Having this property as false (default true) forces it not to use CupertinoTabView which will show
        //   the back button, but does required transitionBetweenRoutes set to false (see above)
        useCupertinoTabView: false,
      ),*/
    );
  }
}
