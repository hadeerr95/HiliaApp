import 'package:app/screens/intro_page.dart';
import 'package:app/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashScreen());
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation<double> opacity;
  // AnimationController controller;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3)).then((value) {
      SharedPreferences.getInstance().then((value) {
        if (value.getBool("AppInitialized") ?? false) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IntroPage()));
        }
      });
    });
    /* controller = AnimationController(
        duration: Duration(milliseconds: 2500), vsync: this);
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });*/
    // controller.forward().then((_) {
    //   navigationPage();
    // });
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  // void navigationPage() async {
  //   SharedPreferences prefer = await SharedPreferences.getInstance();
  //   if (prefer.getBool('Initialized') != null) {
  //     // Navigator.of(context)
  //     //     .pushReplacement(MaterialPageRoute(builder: (_) => MainPage()));
  //   } else {
  //     // Navigator.of(context)
  //     //     .pushReplacement(MaterialPageRoute(builder: (_) => IntroPage()));
  //   }
  // }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/splash.png'), fit: BoxFit.cover)),
      /* child: Container(
        decoration: BoxDecoration(color: transparentYellow),
        child: SafeArea(
          child: new Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Opacity(
                      opacity: opacity.value,
                      child:
                          new Image.asset('assets/icons/icon_hilia_3_1.png')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: 'powered_by'.tr()),
                          TextSpan(
                              text: 'FajerDigital',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),*/
    );
  }
}
