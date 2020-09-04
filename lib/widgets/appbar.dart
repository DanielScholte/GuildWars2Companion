import 'package:flutter/material.dart';

class CompanionAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final Widget icon;
  final Color color;
  final Color foregroundColor;
  final double elevation;
  final Widget bottom;
  final bool implyLeading;

  CompanionAppBar({
    @required this.title,
    this.icon,
    this.color = Colors.transparent,
    this.foregroundColor = Colors.white,
    this.elevation = 4.0,
    this.bottom,
    this.implyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: implyLeading,
      iconTheme: IconThemeData(
        color: foregroundColor,
      ),
      title: icon == null ? Text(
        title,
        style: TextStyle(
          color: foregroundColor
        ),
      ) : Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null)
            Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: icon,
            ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: foregroundColor
              ),
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.light ? color : Theme.of(context).cardColor,
      elevation: Theme.of(context).brightness == Brightness.light ? elevation : 0.0,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}