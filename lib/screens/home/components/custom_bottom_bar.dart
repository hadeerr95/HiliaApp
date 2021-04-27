import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final List<NavigationIconView> items;
  final int currentIndex;
  final Function(Widget index) onSelected;

  const CustomBottomBar(
      {Key key, this.items, this.onSelected, this.currentIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // return BottomNavigationBar(
    //   backgroundColor: Color(0xffc6cbcf),
    //   items: items
    //       .map<BottomNavigationBarItem>(
    //           (NavigationIconView navigationView) => navigationView.item)
    //       .toList(),
    //   currentIndex: currentIndex,
    //   // type: BottomNavigationBarType.shifting,
    //   onTap: (int index) {
    //     onSelected(items[index].child);
    //   },
    // );
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Color(0xffc6cbcf),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.black54,
            ),
            // icon: SvgPicture.asset(
            //   'assets/icons/home_icon.svg',
            //   fit: BoxFit.fitWidth,
            // ),
            onPressed: () {
              onSelected(items[0].child);
            },
          ),
          IconButton(
            icon: Image.asset('assets/icons/category_icon.png'),
            onPressed: () {
              onSelected(items[1].child);
            },
          ),
          // IconButton(
          //   icon: SvgPicture.asset('assets/icons/cart_icon.svg'),
          //   onPressed: () {
          //     controller.animateTo(2);
          //   },
          // ),
          // IconButton(
          //   icon: Icon(
          //     Icons.account_circle,
          //     color: Colors.black54,
          //   ),
          //   // icon: Image.asset('assets/icons/profile_icon.png'),
          //   onPressed: () {
          //     controller.animateTo(1);
          //   },
          // )
        ],
      ),
    );
  }
}

class NavigationIconView {
  NavigationIconView({
    this.child,
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
  })  : _color = color,
        item = BottomNavigationBarItem(
          icon: icon,
          // activeIcon: activeIcon,
          label: title,
          backgroundColor: color,
        );

  final Widget child;
  final Color _color;
  final BottomNavigationBarItem item;

  Widget transition(BuildContext context) {
    Color iconColor;
    // if (type == BottomNavigationBarType.shifting) {
    iconColor = _color;
    // } else {
    //   final ThemeData themeData = Theme.of(context);
    //   iconColor = themeData.brightness == Brightness.light
    //       ? themeData.primaryColor
    //       : themeData.accentColor;
    // }

    return Theme(
      child: child ?? SizedBox,
      data: ThemeData(backgroundColor: iconColor),
    );
  }
}

// class CustomInactiveIcon extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final IconThemeData iconTheme = IconTheme.of(context);
//     return Container(
//       margin: const EdgeInsets.all(4.0),
//       width: iconTheme.size - 8.0,
//       height: iconTheme.size - 8.0,
//       decoration: BoxDecoration(
//         border: Border.all(color: iconTheme.color, width: 2.0),
//       ),
//     );
//   }
// }
