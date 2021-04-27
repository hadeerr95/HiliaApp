import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/screens/splash_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HiliaApp extends StatefulWidget {
  const HiliaApp({
    Key key,
  }) : super(key: key);

  @override
  _HiliaAppState createState() => _HiliaAppState();
}

class _HiliaAppState extends State<HiliaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          // bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          // bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            print(state.status);
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                break;
              case AuthenticationStatus.unauthenticated:
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) =>
              /*FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Future.delayed(Duration(seconds: 5)).then((value) {
                  if ((snapshot.data.getBool('AppInitialized') ?? false) ||
                      true)
                    return MainPage();
                  else
                    return IntroPage();
                  // });
                }
                return*/
              SplashScreen() /*;
              })*/
          ),
      onGenerateTitle: (BuildContext context) => 'title'.tr(),
    );
  }
}
