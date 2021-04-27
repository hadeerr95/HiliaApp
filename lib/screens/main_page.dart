import 'dart:ui';

import 'package:app/bloc/authentication/authentication_bloc.dart';
import 'package:app/screens/components/components.dart';
import 'package:app/screens/favorite_page.dart';
import 'package:app/screens/home/home_page.dart';
import 'package:app/screens/profile_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MainPage());
  }

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PersistentTabController _controller;

  final _navigatorKey = GlobalObjectKey<NavigatorState>("main_navigator");

  bool ready = false;
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 2);
  }

  @override
  void dispose() {
    _navigatorKey?.currentState?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state.status == AuthenticationStatus.unauthenticated)
        return ConnectionFailed(
            onPressed: () =>
                context.bloc<AuthenticationBloc>().add(AuthenticationReload()));
      else if (state.status == AuthenticationStatus.unknown)
        return Scaffold(
          body: Center(
            child: HiliaProgressIndicator(),
          ),
        );

      return PersistentTabView(
        context,
        controller: _controller,
        bottomScreenMargin: kBottomNavigationBarHeight,
        onWillPop: onWillPop,
        backgroundColor: Colors.blue.withOpacity(.1),
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          colorBehindNavBar: Colors.white,
        ),
        // itemAnimationProperties: ItemAnimationProperties(
        //   duration: Duration(milliseconds: 400),
        //   curve: Curves.ease,
        // ),
        // screenTransitionAnimation: ScreenTransitionAnimation(
        //   animateTabTransition: true,
        //   curve: Curves.ease,
        //   duration: Duration(milliseconds: 200),
        // ),
        handleAndroidBackButtonPress: false,
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        hideNavigationBarWhenKeyboardShows: true,
        navBarStyle: NavBarStyle.style6,
        screens: [
          ProfilePage(),
          FavoritePage(),
          HomePage(),
        ],
        items: [
          PersistentBottomNavBarItem(
              icon: Icon(Icons.account_circle_outlined),
              title: "account".tr(),
              inactiveColor: Colors.grey[700],
              activeColor: Color(0xFF102c3b)),
          PersistentBottomNavBarItem(
              icon: Icon(Icons.favorite_outline_sharp),
              title: "favorite".tr(),
              inactiveColor: Colors.grey[700],
              activeColor: Color(0xFF102c3b)),
          PersistentBottomNavBarItem(
              // contentPadding: 0,
              // activeColor: Colors.grey[300],
              // activeColorAlternate: Colors.green,
              icon: Icon(Icons.home),
              title: "home_bottom".tr(),
              inactiveColor: Colors.grey[700],
              activeColor: Color(0xFF102c3b)
              /*textStyle: TextStyle(color: Colors.blue)*/
              ),
        ],
      );
    });
  }

  // void onMainRoute(String route) {
  //   if (activePage != route)
  //     _navigatorKey.currentState.pushNamedAndRemoveUntil(
  //       route,
  //       (r) => false,
  //     );
  // }

  Future<bool> onWillPop() {
    // setState(() {
    //   print(_navigatorKey.currentState.widget.initialRoute);
    //   // _navigatorKey.currentState
    // });
    // if (_navigatorKey.currentState.canPop()) {
    //   _navigatorKey.currentState.pop();
    //   return Future.value(false);
    // }
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "press_again_to_exit".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.value(false);
    }
    return Future.value(true);
  }
}

// class MainScaffold extends StatelessWidget {
//   const MainScaffold({
//     Key key,
//     @required GlobalObjectKey<ScaffoldState> scaffoldKey,
//     @required this.title,
//     @required this.activePage,
//     @required this.body,
//   })  : _scaffoldKey = scaffoldKey,
//         super(key: key);

//   final GlobalObjectKey<ScaffoldState> _scaffoldKey;

//   final String title;
//   final String activePage;
//   final Widget body;

//   @override
//   Widget build(BuildContext context) {
//     List<CustomBottomNavigationBar> tabs = [
//       CustomBottomNavigationBar(
//         icon: Icons.favorite_outline_sharp,
//         color: Colors.teal,
//         routePath: NestedRoutes.favorite,
//       ),
//       CustomBottomNavigationBar(
//         icon: Icons.home_outlined,
//         color: Colors.white,
//         routePath: NestedRoutes.home,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       CustomBottomNavigationBar(
//         icon: Icons.account_circle_outlined,
//         color: Colors.teal,
//         routePath: NestedRoutes.profile,
//       ),
//     ];
//     return Scaffold(
//       // key: _scaffoldKey,
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.grey[700]),
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//         title: AutoSizeText(
//           title,
//           style: TextStyle(color: Colors.grey[700]),
//         ),
//         actions: [
//           NotificationIcon(
//               onPressed: () => Navigator.of(context).push(
//                   MaterialPageRoute(builder: (_) => NotificationsPage()))),
//           ShoppingCartIcon(
//               onPressed: () => Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (_) => CheckOutPage()))),
//         ],
//       ),
//       bottomNavigationBar: CustomBottomBar(
//         items: tabs,
//         activePage: activePage,
//         onSelected: (active) => onMainRoute(active, context),
//       ),
//       body: body,
//     );
//   }

//   void onMainRoute(String route, context) {
//     if (activePage != route)
//       Navigator.of(context).pushNamedAndRemoveUntil(
//         route,
//         (r) => false,
//       );
//   }
// }
