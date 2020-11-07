import 'package:flutter/material.dart';

import 'main.dart';
import 'second.dart';

final routes = {
    '/' : (BuildContext context) => MyApp(),
    '/first' : (BuildContext context) => MyApp(),
    '/second' : (BuildContext context) => {print("second"),SecondApp()}
};

void main() {
    runApp(Router());
}

class Router extends StatelessWidget{

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "플루터 라우터 연습",
        routes: routes,
    );
  }
}