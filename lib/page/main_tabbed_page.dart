import 'dart:developer';

import 'package:Roughy/tab/my_album_widget.dart';
import 'package:Roughy/tab/setting_widget.dart';
import 'package:Roughy/tab/template_select_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class MainTabbedPage extends StatefulWidget {
  const MainTabbedPage(this.toggleBrightness);

  final void Function() toggleBrightness;

  @override
  _MainTabbedPageState createState() => _MainTabbedPageState();
}

class AlbumTabController {
  late void Function() initializeImages;
}

class _MainTabbedPageState extends State<MainTabbedPage> {
  final titles = ['템플릿', '앨범', '설정'];
  int _selectedIndex = 0;

  List<BottomNavigationBarItem> generateBottomNavigationBarItems(
      BuildContext context) {
    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        label: titles[0],
        activeIcon: SvgPicture.asset(
          'assets/icons/template_tab_icon.svg',
          width: 25,
          color: const Color.fromRGBO(134, 185, 232, 1),
        ),
        icon: SvgPicture.asset('assets/icons/template_tab_icon.svg'),
      ),
      BottomNavigationBarItem(
        label: titles[1],
        activeIcon: SvgPicture.asset(
          'assets/icons/album_tab_icon.svg',
          width: 25,
          color: const Color.fromRGBO(134, 185, 232, 1),
        ),
        icon: SvgPicture.asset('assets/icons/album_tab_icon.svg'),
      ),
      BottomNavigationBarItem(
        label: titles[2],
        activeIcon: SvgPicture.asset(
          'assets/icons/setting_tab_icon.svg',
          width: 25,
          color: const Color.fromRGBO(134, 185, 232, 1),
        ),
        icon: SvgPicture.asset('assets/icons/setting_tab_icon.svg'),
      ),
    ];
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final AlbumTabController albumTabController = AlbumTabController();
    final List<Widget> bodyWidgets = [
      TemplateSelectWidget((int index) {
        setState(() {
          _selectedIndex = index;
          log("$_selectedIndex index select!");
          //albumTabController.initializeImages();
        });
      }),
      MyAlbumWidget(albumTabController: albumTabController),
      SettingWidget(),
    ];
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
            //현재 선택된 Index
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: generateBottomNavigationBarItems(context)),
        body: Center(child: bodyWidgets.elementAt(_selectedIndex)));
  }
}
