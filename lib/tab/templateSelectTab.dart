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
  bool _isFavoriteSelected = false;

  @override
  void initState() {
    super.initState();
    initializeTemplates();
  }

  Future<void> initializeTemplates() async {
    final List<Template> templateList = List();
    // 템플릿 셋팅 부분
    for (int i = 0; i < 2; i++) {
      templateList.add(new Template(
          uniqueName: "base" + i.toString(), imageName: "base.png"));
    }
    templateList
        .add(new Template(uniqueName: "base2.jpg", imageName: "base2.jpg"));

    // 사용자가 설정한 Favorite 값 로드
    final prefs = await SharedPreferences.getInstance();
    templateList.forEach((template) {
      bool temp = prefs.getBool(templateKey + template.uniqueName);
      if (temp != null && temp == true) {
        template.isFavorite = true;
      }
    });

    setState(() {
      for (int i = 0; i < templateList.length; i++) {
        templateContainerList.add(new TemplateContainer(
          onTap: _onTemplateSelect,
          onFavoriteTap: _onTemplateFavoriteSelect,
          containerIndex: i,
          template: templateList[i],
        ));
      }
    });
  }

  void _onTemplateFavoriteSelect(
      int index, bool isSelected, BuildContext context) async {
    print("call _onTemplateFavoriteSelect() $index page " +
        isSelected.toString());

    setState(() {
      templateContainerList[index].template.isFavorite = isSelected;
    });
    final prefs = await SharedPreferences.getInstance();
    if (isSelected) {
      prefs.setBool(
          templateKey + templateContainerList[index].template.uniqueName, true);
    } else {
      prefs.remove(
          templateKey + templateContainerList[index].template.uniqueName);
    }
  }

  void _onTemplateSelect(int index, BuildContext context) {
    print("call _onTemplateSelect() $index page");

    Navigator.push(
        context,
        platformPageRoute(
            builder: (_) {
              return ImageViewPage(
                path: "assets/templates/${templateContainerList[index].template.imageName}",
              );
            },
            context: context));
  }

  void _onFavoriteButtonClicked(bool isFavoriteSelected) async {
    setState(() {
      _isFavoriteSelected = isFavoriteSelected;
    });
    print(isFavoriteSelected.toString() + "입니다.");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 3.5;
    final double itemWidth = size.width / 2;

    var gridTileList = _isFavoriteSelected
        ? templateContainerList
            .where((container) => container.template.isFavorite)
            .map((container) => new GridTile(
                  child: container,
                ))
            .toList()
        : templateContainerList
            .map((container) => new GridTile(
                  child: container,
                ))
            .toList();

    return Scaffold(
      appBar: RoughyAppBar(onClickedCallback: _onFavoriteButtonClicked),
      body: new GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
          children: gridTileList),
    );
  }
}
