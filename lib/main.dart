import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {//페이지는 무조건 statelessWidget 으로 만들어져야함
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter app 이름')),
      body: MyHomePage(title:'진짜 타이틀')
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  int titleValue = 100;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _changePage(context) {
    print("call _changePage()");
    Navigator.pushNamed(context, "/second");
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title + widget.titleValue.toString()),
      ),
      backgroundColor: Colors.deepOrange,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Floating action 버튼을 클릭해 보세요',
            ),
            Text(
              '$_counter 번 눌렸어요',
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FloatingActionButton(
                    heroTag: "btn1",
                    child: Icon(Icons.add),
                    onPressed: () => {
                          print("add"),
                          setState(() {
                            _counter++;
                            widget.titleValue = _counter;
                          })
                        }),
                FloatingActionButton(
                    heroTag: "btn2",// 기본 위젯 이동 애니메이션에서 hero 태그로 구분, 같은 위젯이 있는경우 hero 태그가 다르게 존재해야하는데 미 선언시 동일 태그로 오류 발생
                    child: Icon(Icons.remove),
                    onPressed: () => {
                          print("minus"),
                          setState(() {
                            --_counter;
                            widget.titleValue = _counter;
                          })
                        })
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        onPressed: () => {
          print("버튼 클릭"),
          print("이요"),
          _changePage(context),
        },
        tooltip: 'Increment',
        child: Icon(Icons.change_history),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
