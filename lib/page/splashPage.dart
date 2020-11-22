import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_example/page/mainTabbedPage.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SplashPage extends StatefulWidget {
  SplashPage(this.toggleBrightness);

  final void Function() toggleBrightness;

  @override
  _SplashPageState createState() => _SplashPageState(toggleBrightness);
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  _SplashPageState(this.toggleBrightness);

  final void Function() toggleBrightness;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();
    _animation.addStatusListener((state) {
      if (state == AnimationStatus.completed) {}
    });
    //애니메이션이 끝나고 대기시간 걸리는 부자연스러움을 없애기 위해
    // 애니메이션 끝나기 전에 이동하는 코드 추가.
    _delayedSplashPage().then((status) => {
          if (status) {_navigateToMainPage()}
        });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _delayedSplashPage() async {
    await Future.delayed(Duration(milliseconds: 1200), () {});
    return true;
  }

  void _navigateToMainPage() {
    Navigator.pushReplacement(
        context,
        platformPageRoute(
            context: context,
            builder: (BuildContext context) =>
                MainTabbedPage(toggleBrightness)));
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Center(
        child: FadeTransition(
            opacity: _animation,
            // The green box must be a child of the AnimatedOpacity widget.
            child: Container(
              child: Image.asset('assets/images/logo.png'),
            )),
      ),
    );
  }
}
