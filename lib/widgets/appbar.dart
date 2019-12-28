import 'package:flutter/material.dart';

class CompanionAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final Color color;
  final Color foregroundColor;
  final double elevation;

  CompanionAppBar({
    @required this.title,
    this.color = Colors.transparent,
    this.foregroundColor = Colors.black87,
    this.elevation = 0
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: foregroundColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: foregroundColor
        ),
      ),
      backgroundColor: color,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}