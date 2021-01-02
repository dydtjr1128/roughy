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
  @override
  _TemplateSelectWidgetState createState() => _TemplateSelectWidgetState();
}

class _TemplateSelectWidgetState extends State<TemplateSelectWidget> {
  final List<TemplateContainer> templateContainerList = List();
  final List<Template> templateList = List();

  @override
  void initState() {
    super.initState();
    loadTemplates();
  }

  void loadTemplates() async {
    final String TEMPLATE_KEY = "TEMPLATE_LISTS";
    print("@@111");
    final prefs = await SharedPreferences.getInstance();

    List<String> myList = prefs.getStringList(TEMPLATE_KEY);
    if (myList == null) {
      print("null~@");
      myList = List();
      Template template;
      for (int i = 0; i < 9; i++) {
        template = new Template(imagePath: "base.png", isFavorite: false);
        myList.add(jsonEncode(template));
        templateList.add(template);
      }
      template = new Template(imagePath: "base2.jpg", isFavorite: false);
      myList.add(jsonEncode(template));
      templateList.add(template);
      prefs.setStringList(TEMPLATE_KEY, myList);
    } else {
      print("null이 아님~@" + myList.length.toString());
      for (String jsonTemplate in myList) {
        templateList.add(Template.fromJson(jsonDecode(jsonTemplate)));
      }
    }
    print(templateList.length.toString() + "@@@개 입니다.");
    setState(() {
      for (int i = 0; i < templateList.length; i++) {
        templateContainerList.add(new TemplateContainer(
          onTap: _onTemplateSelect,
          containerIndex: i,
          templateImagePath: "assets/templates/${templateList[i].imagePath}",
        ));
      }
    });
  }

  void _onTemplateSelect(int index, BuildContext context) {
    print("call _onTemplateSelect() $index page");

    Navigator.push(
        context,
        platformPageRoute(
            builder: (_) {
              return ImageViewPage(
                path: "assets/templates/${templateList[index].imagePath}",
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
    final double itemHeight = (size.height) / 3.5;
    final double itemWidth = size.width / 2;

    return Scaffold(
      appBar: RoughyAppBar(onClickedCallback: _onFavoriteButtonClicked),
      body: new GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        children: new List.generate(templateContainerList.length, (index) {
          return new GridTile(
            child: templateContainerList[index],
          );
        }),
      ),
    );
  }
}
