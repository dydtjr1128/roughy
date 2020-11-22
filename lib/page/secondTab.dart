import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SecondTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text('Flutter app 이름')),
      body: Center(
        child: PlatformButton(
          child: PlatformText('이전페이지로'),
          onPressed: () => {
            print('이 버튼 누를때만 이전페이지로 이동!'),
            Navigator.pop(context)
          },
        ),
      ),
    );
  }
}
