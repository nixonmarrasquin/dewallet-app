import 'package:flutter/material.dart';
import 'package:siglo21/Utils/slider_menu/slider_direction.dart';

class SliderAppBar extends StatelessWidget {
  final EdgeInsets appBarPadding;
  final Color appBarColor;
  final Widget? drawerIcon;
  final Color splashColor;
  final Color drawerIconColor;
  final double drawerIconSize;
  final double appBarHeight;
  final AnimationController animationController;
  final VoidCallback onTap;
  final Widget title;
  final bool isTitleCenter;
  final Widget? trailing;
  final SlideDirection slideDirection;

  const SliderAppBar(
      {Key? key,
      this.appBarPadding = const EdgeInsets.only(top: 24),
      this.appBarColor = Colors.blue,
      this.drawerIcon,
      this.splashColor = Colors.black,
      this.drawerIconColor = Colors.black87,
      this.drawerIconSize = 27,
      required this.animationController,
      required this.onTap,
      required this.title,
      required this.isTitleCenter,
      this.trailing,
      required this.slideDirection,
      required this.appBarHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appBarHeight,
      padding: appBarPadding,
      color: appBarColor,
      child: Row(
        children: appBar(),
      ),
    );
  }

  List<Widget> appBar() {
    List<Widget> list = [
      drawerIcon ??
          IconButton(
              splashColor: splashColor,
              icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  color: drawerIconColor,
                  size: drawerIconSize,
                  progress: animationController),
              onPressed: () => onTap()),
      Expanded(
        child: isTitleCenter
            ? Center(
                child: title,
              )
            : title,
      ),
      trailing ??
          SizedBox(
            width: 35,
          )
    ];

    if (slideDirection == SlideDirection.RIGHT_TO_LEFT) {
      return list.reversed.toList();
    }
    return list;
  }
}
