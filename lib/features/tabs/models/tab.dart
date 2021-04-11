import 'package:flutter/widgets.dart';

class TabEntry {
  Widget widget;
  String title;
  IconData icon;
  double iconSize;
  Color color;

  TabEntry(Widget widget, String title, IconData icon, double iconSize, Color color) {
    this.widget = widget;
    this.title = title;
    this.icon = icon;
    this.iconSize = iconSize;
    this.color = color;
  }
}