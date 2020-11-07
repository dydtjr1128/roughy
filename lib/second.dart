import 'package:flutter/material.dart';

class SecondApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter app 이름')),
      body: Center(
        child: RaisedButton(
          child: Text('이전페이지로'),
          onPressed: () => {Navigator.pop(context)},
        ),
      ),
    );
  }
}
