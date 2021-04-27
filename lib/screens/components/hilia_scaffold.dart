import 'package:flutter/material.dart';
import '../../app_properties.dart';

class HiliaAppBar extends AppBar {
  final Widget title;
  final List<Widget> actions;
  final IconThemeData actionsIconTheme;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget bottom;
  final bool centerTitle;
  final Widget leading;
  final Widget flexibleSpace;
  final Color shadowColor;

  HiliaAppBar(
      {Key key,
      this.title,
      this.actions,
      this.actionsIconTheme,
      this.automaticallyImplyLeading = true,
      this.bottom,
      this.centerTitle,
      this.leading,
      this.flexibleSpace,
      this.shadowColor})
      : super(
          key: key,
          iconTheme: IconThemeData(color: Colors.grey[700]),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: title,
          actions: actions,
          actionsIconTheme: actionsIconTheme,
          automaticallyImplyLeading: automaticallyImplyLeading,
          bottom: bottom,
          centerTitle: centerTitle,
          leading: leading,
          flexibleSpace: flexibleSpace,
          shadowColor: shadowColor,
        );
}

class HiliaScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget appBar;
  final Widget body;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final Widget drawer;
  final Widget endDrawer;
  final Widget bottomNavigationBar;
  final Widget bottomSheet;

  const HiliaScaffold({
    Key key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
  }) : scaffoldKey = key;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: backgroundColor),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        drawer: drawer,
        endDrawer: endDrawer,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
      ),
    );
  }
}
