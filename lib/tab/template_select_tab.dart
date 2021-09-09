import 'dart:convert';

import 'package:Roughy/component/roughy_app_bar.dart';
import 'package:Roughy/component/template_container.dart';
import 'package:Roughy/data/Template.dart';
import 'package:Roughy/page/decorating/image_view_page.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemplateSelectWidget extends StatefulWidget {
  const TemplateSelectWidget(this.setTabIndex);
  final void Function(int index) setTabIndex;

  @override
  _TemplateSelectWidgetState createState() => _TemplateSelectWidgetState();
}

class _TemplateSelectWidgetState extends State<TemplateSelectWidget> {
  final String templateKey = "TEMPLATE_LISTS";
  final List<TemplateContainer> templateContainerList = [];
  bool _isFavoriteSelected = false;

  @override
  void initState() {
    super.initState();
    initializeTemplates();
  }

  Future<void> initializeTemplates() async {
    final List<Template> templateList = [];
    // 템플릿 셋팅 부분, 하트 정렬은 uniqueName 으로 셋팅하기 때문에 이미지 이름이 같아도 됨.
    final String manifestJson =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Iterable iterable = json.decode(manifestJson).keys as Iterable;
    final List<String> imagePaths = iterable
        .map((v) => v as String)
        .where((String key) => key.startsWith('assets/templates'))
        .where((String key) => key.endsWith('.png'))
        .map((String key) => key.substring(key.lastIndexOf("/") + 1))
        .toList();

    imagePaths.sort(compareNatural);
    for (final String path in imagePaths) {
      templateList.add(Template(imageName: path));
    }
/*    templateList
      ..add(Template(imageName: "FRAME_circle1.png"))
      ..add(Template(imageName: "FRAME_circle2.png"))
      ..add(Template(imageName: "FRAME_circle3.png"))
      ..add(Template(imageName: "FRAME_circle4.png"))
      ..add(Template(imageName: "FRAME_circle5.png"))
      ..add(Template(imageName: "FRAME_free1.png"))
      ..add(Template(imageName: "FRAME_heart1.png"))
      ..add(Template(imageName: "FRAME_polaroid1.png"))
      ..add(Template(imageName: "FRAME_polaroid2.png"))
      ..add(Template(imageName: "FRAME_square1.png"))
      ..add(Template(imageName: "FRAME_square2.png"));*/

    // 사용자가 설정한 Favorite 값 로드
    final prefs = await SharedPreferences.getInstance();
    for (final Template template in templateList) {
      final bool? temp = prefs.getBool(template.imageName);
      if (temp == true) {
        template.isFavorite = true;
      }
    }

    setState(() {
      for (int i = 0; i < templateList.length; i++) {
        precacheImage(Image.asset("assets/templates/${templateList[i].imageName}").image, context);
        templateContainerList.add(TemplateContainer(
          onTap: _onTemplateSelect,
          onFavoriteTap: _onTemplateFavoriteSelect,
          containerIndex: i,
          template: templateList[i],
        ));
      }
    });
  }

  void _onTemplateFavoriteSelect(int index, bool isSelected, BuildContext context) async {
    print("${"call _onTemplateFavoriteSelect() $index page "}$isSelected");

    setState(() {
      templateContainerList[index].template.isFavorite = isSelected;
    });
    final prefs = await SharedPreferences.getInstance();
    if (isSelected) {
      prefs.setBool(templateKey + templateContainerList[index].template.imageName, true);
    } else {
      prefs.remove(templateKey + templateContainerList[index].template.imageName);
    }
  }

  Future<void> _onTemplateSelect(int index, BuildContext context) async {
    print("call _onTemplateSelect() $index page");

    final bool? result = await Navigator.push(
        context,
        platformPageRoute(
            builder: (_) {
              return ImageViewPage(
                path: "assets/templates/${templateContainerList[index].template.imageName}",
              );
            },
            context: context));
    if(result == true) {
      widget.setTabIndex(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 3.5;
    final double itemWidth = size.width / 2;

    final gridTileList = _isFavoriteSelected
        ? templateContainerList
            .where((container) => container.template.isFavorite)
            .map((container) => GridTile(
                  child: container,
                ))
            .toList()
        : templateContainerList
            .map((container) => GridTile(
                  child: container,
                ))
            .toList();

    return Scaffold(
      appBar: RoughyAppBar(
          iconWidget: IconButton(
        icon: SvgPicture.asset('assets/icons/for_you.svg',
            color: _isFavoriteSelected
                ? const Color.fromRGBO(146, 196, 242, 1)
                : const Color.fromRGBO(217, 217, 217, 1)),
        tooltip: "favorite",
        onPressed: () {
          setState(() {
            _isFavoriteSelected = !_isFavoriteSelected;
            print(_isFavoriteSelected);
          });
          print("_onFavoriteButtonClicked : $_isFavoriteSelected");
        },
        color: Colors.red,
      )),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: GridView.count(
            crossAxisCount: 2, childAspectRatio: itemWidth / itemHeight, children: gridTileList),
      ),
    );
  }
}
