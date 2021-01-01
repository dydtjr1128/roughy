import 'package:Roughy/page/ImageViewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:Roughy/component/roughyAppBar.dart';
import 'package:Roughy/component/templateContainer.dart';

class TemplateSelectWidget extends StatelessWidget {
  final List<TemplateContainer> templateList = List();
  final List<String> imageList = List();

  TemplateSelectWidget() {
    initializeTemplateContainers();
  }

  void initializeTemplateContainers() {
    //임의 템플릿
    for (int i = 0; i < 9; i++) {
      imageList.add("base.png");
    }
    imageList.add("base2.jpg");

    for (int i = 0; i < imageList.length; i++) {
      templateList.add(new TemplateContainer(
        onTap: _onTemplateSelect,
        containerIndex: i,
        templateImagePath: "assets/templates/${imageList[i]}",
      ));
    }
  }

  void _onTemplateSelect(int index, BuildContext context) {
    print("call _onTemplateSelect() $index page");

    Navigator.push(
        context,
        platformPageRoute(
            builder: (_) {
              return ImageViewPage(
                path: "assets/templates/${imageList[index]}",
              );
            },
            context: context));
  }

  void _onFavoriteButtonClicked(bool isFavoriteSelected) {
    print(isFavoriteSelected.toString() + "입니다.");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 3;
    final double itemWidth = size.width / 2;

    return Scaffold(
      appBar: RoughyAppBar(onClickedCallback: _onFavoriteButtonClicked),
      body: new GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        children: new List.generate(templateList.length, (index) {
          return new GridTile(
            child: templateList[index],
          );
        }),
      ),
    );
  }
}
