import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_example/component/templateContainer.dart';
import 'package:flutter_example/tab/secondTab.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TemplateSelectWidget extends StatelessWidget {
  void _onTemplateSelect(int index, BuildContext context) {
    print("call _onTemplateSelect() $index page");

    Navigator.push(
        context,
        platformPageRoute(
            builder: (_) {
              return SecondTabPage();
            },
            context: context));
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: new GridView.count(
        crossAxisCount: 2,
        children: new List.generate(16, (index) {
          return new GridTile(
            child: new TemplateContainer(
              onTap: _onTemplateSelect,
              containerIndex: index,
              child: new Text(
                'Tile $index',
                style: TextStyle(fontFamily: 'Macadamia'),
              ),
            ), /*new Card(
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
