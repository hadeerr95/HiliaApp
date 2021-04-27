// import 'package:flutter/material.dart';

// class NavigationIconView {
//   NavigationIconView({
//     Widget icon,
//     Widget child,
//     Widget activeIcon,
//     String title,
//     Color color,
//   })  : _child = child,
//         _color = color,
//         item = BottomNavigationBarItem(
//           icon: icon,
//           activeIcon: activeIcon,
//           title: AutoSizeText(title),
//           backgroundColor: color,
//         );

//   final Widget _child;
//   final Color _color;
//   final BottomNavigationBarItem item;

//   Widget transition(BuildContext context) {
//     Color iconColor;
//     // if (type == BottomNavigationBarType.shifting) {
//       iconColor = _color;
//     // } else {
//     //   final ThemeData themeData = Theme.of(context);
//     //   iconColor = themeData.brightness == Brightness.light
//     //       ? themeData.primaryColor
//     //       : themeData.accentColor;
//     // }

//     return Theme(
//         child: _child ?? SizedBox,
//         data: ThemeData(backgroundColor: iconColor),
//       );
//   }
// }

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
