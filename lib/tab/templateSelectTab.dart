import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_example/component/roughyAppBar.dart';
import 'package:flutter_example/component/templateContainer.dart';
import 'package:flutter_example/tab/ImageViewPage.dart';
import 'package:flutter_example/tab/secondTab.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TemplateSelectWidget extends StatelessWidget {
  List<TemplateContainer> templateList;
  final List<String> imageList = List();

  TemplateSelectWidget() {
    initializeTemplateContainers();
  }

  void initializeTemplateContainers() {
    //임의 템플릿
    for (int i = 0; i < 3; i++) {
      imageList.add("base.png");
    }
    imageList.add("base2.jpg");

    templateList = List();
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      appBar: RoughyAppBar(),
      body: new GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        children: new List.generate(templateList.length, (index) {
          return new GridTile(
            child: templateList[
                index], /*new Card(
              color: Colors.teal.shade200,
              margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
              child: new Center(
                child: new Text(
                  'Tile $index',
                  style: TextStyle(fontFamily: 'Macadamia'),
                ),
              ),
            ),*/
          );
        }),
      ),
    );
  }
}
