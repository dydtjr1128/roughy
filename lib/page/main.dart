import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:Roughy/page/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //페이지는 무조건 statelessWidget 으로 만들어져야함
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;
  int titleValue = 100;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/*class _MyHomePageState extends State<MyHomePage> {
  Brightness brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    final materialTheme = ThemeData(
      fontFamily: 'Yanolja',
    );
    final materialDarkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
    );

    final cupertinoTheme = CupertinoThemeData(
      brightness: brightness, // if null will use the system theme
      primaryColor: const CupertinoDynamicColor.withBrightness(
        color: Colors.black,
        darkColor: Colors.cyan,
      ),
    );
    return Theme(
      data: brightness == Brightness.light ? materialTheme : materialDarkTheme,
      child: PlatformProvider(
        builder: (context) => PlatformApp(
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          title: "Roughy App",
          debugShowCheckedModeBanner: false,
          //디버그용 체크 코드
          material: (_, __) {
            return MaterialAppData(
              theme: materialTheme,
              darkTheme: materialDarkTheme,
              themeMode: brightness == Brightness.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
            );
          },
          cupertino: (_, __) => CupertinoAppData(
            theme: cupertinoTheme,
          ),
          home: SplashPage(() {
            setState(() {
              brightness = brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light;
            });
          }),
        ),
      ),
    );
  }
}*/
class _MyHomePageState extends State<MyHomePage> {
  Brightness brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    // 세로 위쪽 방향 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        title: "Roughy App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Yanolja',
            textTheme: Theme.of(context)
                .textTheme
                .apply(fontSizeFactor: 1.2,fontFamily: 'Yanolja')),
        home: SplashPage(() {
          setState(() {
            brightness = brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light;
          });
        }));
  }
}
