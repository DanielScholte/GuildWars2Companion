import 'package:flutter/material.dart';

class CompanionContentElevation extends StatelessWidget {
  final Widget child;
  final double elevation;
  final BorderRadiusGeometry radius;

  CompanionContentElevation({
    @required this.child,
    this.elevation = 2.0,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return child;
    }

    return Material(
      elevation: elevation,
      color: Colors.transparent,
      borderRadius: radius != null ? radius : BorderRadius.circular(12.0),
      child: child,
    );
  }
}