import 'package:flutter/material.dart';

void showHiliaProgress(BuildContext context) {
  showDialog(
      barrierColor: Colors.black54.withOpacity(.1),
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.white10.withOpacity(.0),
          body: Center(
            child: HiliaProgressIndicator(),
          ),
        );
      });
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: Image.asset('assets/icons/logo.png'),
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

// #docregion print-state
class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      // #enddocregion print-state
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    // #docregion print-state
    // ..addStatusListener((state) => print('$state'));
    controller.forward();
  }
  // #enddocregion print-state

  @override
  Widget build(BuildContext context) => AnimatedLogo(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  // #docregion print-state
}

// // #docregion LogoWidget
// class LogoWidget extends StatelessWidget {
//   // Leave out the height and width so it fills the animating parent
//   Widget build(BuildContext context) => Container(
//         margin: EdgeInsets.symmetric(vertical: 10),
//         child: Image.asset('assets/icons/logo.png'),
//       );
// }
// // #enddocregion LogoWidget

// // #docregion GrowTransition
// class GrowTransition extends StatelessWidget {
//   GrowTransition({this.child, this.animation});

//   final Widget child;
//   final Animation<double> animation;

//   Widget build(BuildContext context) => Center(
//         child: AnimatedBuilder(
//             animation: animation,
//             builder: (context, child) => Container(
//                   height: animation.value,
//                   width: animation.value,
//                   child: child,
//                 ),
//             child: child),
//       );
// }
// // #enddocregion GrowTransition

// class LogoApp extends StatefulWidget {
//   _LogoAppState createState() => _LogoAppState();
// }

// // #docregion print-state
// class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
//   Animation<double> animation;
//   AnimationController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller =
//         AnimationController(duration: const Duration(seconds: 2), vsync: this);
//     animation = Tween<double>(begin: 0, end: 300).animate(controller);
//     controller.forward();
//   }
//   // #enddocregion print-state

//   @override
//   Widget build(BuildContext context) => GrowTransition(
//         child: LogoWidget(),
//         animation: animation,
//       );

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//   // #docregion print-state
// }

// // #docregion diff
// class AnimatedLogo extends AnimatedWidget {
//   // Make the Tweens static because they don't change.
//   static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
//   static final _sizeTween = Tween<double>(begin: 0, end: 300);

//   AnimatedLogo({Key key, Animation<double> animation})
//       : super(key: key, listenable: animation);

//   Widget build(BuildContext context) {
//     final animation = listenable as Animation<double>;
//     return Center(
//       child: Opacity(
//         opacity: _opacityTween.evaluate(animation),
//         child: Container(
//           margin: EdgeInsets.symmetric(vertical: 10),
//           height: _sizeTween.evaluate(animation),
//           width: _sizeTween.evaluate(animation),
//           child: FlutterLogo(),
//         ),
//       ),
//     );
//   }
// }

// class LogoApp extends StatefulWidget {
//   _LogoAppState createState() => _LogoAppState();
// }

// class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
//   Animation<double> animation;
//   AnimationController controller;

//   @override
//   void initState() {
//     super.initState();
//     // #docregion AnimationController, tweens
//     controller =
//         AnimationController(duration: const Duration(seconds: 2), vsync: this);
//     // #enddocregion AnimationController, tweens
//     animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controller.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controller.forward();
//         }
//       });
//     controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) => AnimatedLogo(animation: animation);

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }
// // #enddocregion diff

// // Extra code used only in the tutorial explanations. It is not used by the app.

// class UsedInTutorialTextOnly extends _LogoAppState {
//   UsedInTutorialTextOnly() {
//     // ignore: unused_local_variable
//     var animation, sizeAnimation, opacityAnimation, tween, colorTween;

//     // #docregion CurvedAnimation
//     animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
//     // #enddocregion CurvedAnimation

//     // #docregion tweens
//     sizeAnimation = Tween<double>(begin: 0, end: 300).animate(controller);
//     opacityAnimation = Tween<double>(begin: 0.1, end: 1).animate(controller);
//     // #enddocregion tweens

//     // #docregion tween
//     tween = Tween<double>(begin: -200, end: 0);
//     // #enddocregion tween

//     // #docregion colorTween
//     colorTween = ColorTween(begin: Colors.transparent, end: Colors.black54);
//     // #enddocregion colorTween
//   }

//   usedInTutorialOnly1() {
//     // #docregion IntTween
//     AnimationController controller = AnimationController(
//         duration: const Duration(milliseconds: 500), vsync: this);
//     Animation<int> alpha = IntTween(begin: 0, end: 255).animate(controller);
//     // #enddocregion IntTween
//     return alpha;
//   }

//   usedInTutorialOnly2() {
//     // #docregion IntTween-curve
//     AnimationController controller = AnimationController(
//         duration: const Duration(milliseconds: 500), vsync: this);
//     final Animation curve =
//         CurvedAnimation(parent: controller, curve: Curves.easeOut);
//     Animation<int> alpha = IntTween(begin: 0, end: 255).animate(curve);
//     // #enddocregion IntTween-curve
//     return alpha;
//   }
// }

// // #docregion ShakeCurve
// class ShakeCurve extends Curve {
//   @override
//   double transform(double t) => sin(t * pi * 2);
// }

/// This is the stateful widget that the main application instantiates.
class HiliaProgressIndicator extends StatefulWidget {
  HiliaProgressIndicator({Key key}) : super(key: key);

  @override
  _HiliaProgressIndicatorState createState() => _HiliaProgressIndicatorState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _HiliaProgressIndicatorState extends State<HiliaProgressIndicator>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _animation,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Image.asset('assets/icons/spining-logo.png'),
        ),
      ),
    );
  }
}
