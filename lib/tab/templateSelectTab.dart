import 'dart:collection';
import 'dart:convert';

import 'package:Roughy/component/roughyAppBar.dart';
import 'package:Roughy/component/templateContainer.dart';
import 'package:Roughy/data/Template.dart';
import 'package:Roughy/page/ImageViewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemplateSelectWidget extends StatefulWidget {
  final _TemplateSelectWidgetState parentState = _TemplateSelectWidgetState();

  @override
  _TemplateSelectWidgetState createState() => parentState;
}

class _TemplateSelectWidgetState extends State<TemplateSelectWidget> {
  final String templateKey = "TEMPLATE_LISTS";
  final List<TemplateContainer> templateContainerList = List();
  final List<String> templateList = List();
  final Set<int> templateFavoriteIndexSet = LinkedHashSet();

  @override
  void initState() {
    super.initState();
    loadTemplates();
  }

  // TODO: 템플릿 업데이트 되었을 경우 이거 문제가 있음 한번 저장되면 템플릿 추가된거 못불러올듯
  void loadTemplates() async {
    final prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < 9; i++) {
      templateList.add("base.png");
    }
    templateList.add("base2.jpg");
    loadTemplateFavoritePrefs();
    loadAllTemplates();
  }

  void loadAllTemplates() {
    setState(() {
      for (int i = 0; i < templateList.length; i++) {
        templateContainerList.add(new TemplateContainer(
          onTap: _onTemplateSelect,
          onFavoriteTap: _onTemplateFavoriteSelect,
          containerIndex: i,
          templateImagePath: "assets/templates/${templateList[i]}",
          isFavorite: templateFavoriteIndexSet.contains(i),
        ));
      }
    });
  }

  void saveTemplateFavoritePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(templateKey,
        templateFavoriteIndexSet.map((value) => value.toString()).toList());
  }

  void loadTemplateFavoritePrefs() async {
    templateFavoriteIndexSet.clear();
    final prefs = await SharedPreferences.getInstance();
    List<String> _templateFavoriteIndexList = prefs.getStringList(templateKey);
    if (_templateFavoriteIndexList != null) {
      templateFavoriteIndexSet.addAll(
          _templateFavoriteIndexList.toSet().map((value) => int.parse(value)));
    }
  }

  void _onTemplateFavoriteSelect(
      int index, bool isSelected, BuildContext context) {
    print("call _onTemplateFavoriteSelect() $index page " +
        isSelected.toString());
    if (isSelected) {
      templateFavoriteIndexSet.remove(index);
    } else {
      templateFavoriteIndexSet.add(index);
    }
    saveTemplateFavoritePrefs();
  }

  void _onTemplateSelect(int index, BuildContext context) {
    print("call _onTemplateSelect() $index page");

    Navigator.push(
        context,
        platformPageRoute(
            builder: (_) {
              return ImageViewPage(
                path: "assets/templates/${templateList[index]}",
              );
            },
            context: context));
  }

  void _onFavoriteButtonClicked(bool isFavoriteSelected) async {
    templateContainerList.clear();
    if (isFavoriteSelected) {
      setState(() {
        List<int> _templateFavoriteIndexList =
            templateFavoriteIndexSet.toList();
        for (int i = 0; i < _templateFavoriteIndexList.length; i++) {
          templateContainerList.add(new TemplateContainer(
            onTap: _onTemplateSelect,
            onFavoriteTap: _onTemplateFavoriteSelect,
            containerIndex: i,
            templateImagePath:
                "assets/templates/${templateList[_templateFavoriteIndexList[i]]}",
            isFavorite: true,
          ));
        }
      });
    } else {
      loadAllTemplates();
    }
    print(isFavoriteSelected.toString() + "입니다.");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 3.5;
    final double itemWidth = size.width / 2;

    return Scaffold(
      appBar: RoughyAppBar(onClickedCallback: _onFavoriteButtonClicked),
      body: new GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        children: templateContainerList
            .map((container) => new GridTile(
                  child: container,
                ))
            .toList(),
        /*children: new List.generate(templateContainerList.length, (index) {
          return new GridTile(
            child: templateContainerList[index],
          );
        }),*/
      ),
    );
  }
}
